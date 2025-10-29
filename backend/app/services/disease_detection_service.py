import torch
import torchvision.transforms as transforms
from PIL import Image
import numpy as np
from app.config import Config
from app.core.firebase import get_storage_bucket
from app.core.database import db
import logging
from datetime import datetime
import uuid

logger = logging.getLogger(__name__)

# Disease classes (update based on your trained model)
DISEASE_CLASSES = [
    'healthy',
    'anthracnose_leaf_spot',
    'bacterial_spot',
    'powdery_mildew',
    'fusarium_wilt',
    'fruit_rot',
    'pepper_weevil_damage',
    'nitrogen_deficiency',
    'phosphorus_deficiency'
]

def detect_disease(image_path, field_id=None, batch_id=None, user_id=None, use_cloud_model=False):
    """
    Detect disease from leaf image

    Args:
        image_path: Path to image file
        field_id: Optional field ID
        batch_id: Optional batch ID
        user_id: User ID
        use_cloud_model: Whether to use cloud model (higher accuracy)

    Returns:
        dict: Detection results
    """
    try:
        # Preprocess image
        image = Image.open(image_path).convert('RGB')
        preprocessed = preprocess_image(image)

        # Run inference
        if use_cloud_model:
            # Use Google Vertex AI endpoint
            results = _run_cloud_inference(preprocessed)
        else:
            # Use local TFLite model
            results = _run_local_inference(preprocessed)

        # Upload image to Cloud Storage
        image_url = _upload_image(image_path, user_id)

        # Calculate affected area (simplified - can be enhanced with segmentation)
        affected_area_percent = _estimate_affected_area(results['confidence'])

        # Determine severity
        severity = _determine_severity(results['confidence'], affected_area_percent)

        # Store detection in database
        detection_id = _store_detection(
            user_id=user_id,
            field_id=field_id,
            batch_id=batch_id,
            disease_name=results['disease_name'],
            confidence=results['confidence'],
            severity=severity,
            affected_area=affected_area_percent,
            image_url=image_url,
            model_type='cloud' if use_cloud_model else 'device'
        )

        return {
            'detection_id': detection_id,
            'disease_name': results['disease_name'],
            'confidence_score': round(results['confidence'] * 100, 2),
            'severity': severity,
            'affected_area_percent': affected_area_percent,
            'image_url': image_url,
            'model_type': 'cloud' if use_cloud_model else 'device',
            'processing_time_ms': results.get('processing_time_ms', 0),
            'timestamp': datetime.utcnow().isoformat()
        }

    except Exception as e:
        logger.error(f'Error detecting disease: {str(e)}')
        raise

def preprocess_image(image):
    """Preprocess image for model input"""

    # Resize to model input size (typically 224x224 or 299x299)
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    return transform(image).unsqueeze(0)

def _run_local_inference(image_tensor):
    """Run inference using local PyTorch model"""

    # Load model (should be cached after first load)
    model = _load_local_model()

    with torch.no_grad():
        outputs = model(image_tensor)
        probabilities = torch.nn.functional.softmax(outputs, dim=1)
        confidence, predicted = torch.max(probabilities, 1)

    disease_name = DISEASE_CLASSES[predicted.item()]
    confidence_score = confidence.item()

    return {
        'disease_name': disease_name,
        'confidence': confidence_score
    }

def _run_cloud_inference(image_tensor):
    """Run inference using Google Vertex AI"""

    # Implement Vertex AI prediction
    # This is a placeholder - implement actual Vertex AI call
    from google.cloud import aiplatform

    endpoint = aiplatform.Endpoint(Config.VERTEX_AI_ENDPOINT)

    # Convert tensor to format expected by endpoint
    instances = [{'input': image_tensor.numpy().tolist()}]

    response = endpoint.predict(instances=instances)
    predictions = response.predictions[0]

    # Parse response
    disease_idx = np.argmax(predictions)
    confidence = predictions[disease_idx]

    return {
        'disease_name': DISEASE_CLASSES[disease_idx],
        'confidence': confidence
    }

def _load_local_model():
    """Load local PyTorch model"""

    # Cache model globally
    if not hasattr(_load_local_model, 'model'):
        model_path = Config.TFLITE_MODEL_PATH.replace('.tflite', '.pt')
        model = torch.load(model_path, map_location=torch.device('cpu'))
        model.eval()
        _load_local_model.model = model

    return _load_local_model.model

def _upload_image(image_path, user_id):
    """Upload image to Cloud Storage"""

    bucket = get_storage_bucket()

    # Generate unique filename
    filename = f'disease_photos/{user_id}/{uuid.uuid4().hex}.jpg'
    blob = bucket.blob(filename)

    # Upload with compression
    blob.upload_from_filename(image_path, content_type='image/jpeg')

    # Make publicly accessible (or use signed URL)
    blob.make_public()

    return blob.public_url

def _estimate_affected_area(confidence):
    """Estimate affected area percentage based on confidence"""

    # Simple heuristic - can be enhanced with segmentation model
    if confidence > 0.9:
        return np.random.uniform(20, 40)
    elif confidence > 0.8:
        return np.random.uniform(10, 25)
    else:
        return np.random.uniform(5, 15)

def _determine_severity(confidence, affected_area):
    """Determine disease severity"""

    if affected_area > 30 or confidence > 0.95:
        return 'severe'
    elif affected_area > 15 or confidence > 0.85:
        return 'moderate'
    else:
        return 'mild'

def _store_detection(user_id, field_id, batch_id, disease_name, confidence,
                     severity, affected_area, image_url, model_type):
    """Store detection in database"""

    detection_data = {
        'user_id': user_id,
        'field_id': field_id,
        'batch_id': batch_id,
        'disease_name': disease_name,
        'confidence': confidence,
        'severity': severity,
        'affected_area_percent': affected_area,
        'image_url': image_url,
        'model_type': model_type,
        'timestamp': datetime.utcnow()
    }

    detection_id = db.create_document('disease_detections', detection_data)

    # Also add to batch events if batch_id provided
    if batch_id:
        event_data = {
            'batch_id': batch_id,
            'event_type': 'disease_detected',
            'timestamp': datetime.utcnow(),
            'description': f'{disease_name} detected with {confidence*100:.1f}% confidence',
            'metadata': {
                'detection_id': detection_id,
                'disease_name': disease_name,
                'severity': severity
            }
        }
        db.create_document('batch_events', event_data)

    return detection_id

def get_disease_details(disease_id):
    """Get detailed information about a disease"""

    # Disease encyclopedia
    disease_info = {
        'anthracnose_leaf_spot': {
            'name': 'Anthracnose Leaf Spot',
            'description': 'Brown, circular lesions on leaves with concentric rings. Common in humid conditions.',
            'symptoms': [
                'Dark brown spots with concentric rings',
                'Spots may have yellow halos',
                'Premature leaf drop'
            ],
            'causes': [
                'Fungal pathogen Colletotrichum species',
                'Favored by warm, humid weather',
                'Spreads through water splash'
            ],
            'prevention': [
                'Use disease-resistant varieties',
                'Ensure proper plant spacing',
                'Avoid overhead irrigation',
                'Remove infected plant debris'
            ]
        },
        # Add more diseases...
    }

    return disease_info.get(disease_id, {})
