"""
Disease detection service - TFLite inference
"""
import logging
import numpy as np
from PIL import Image
from io import BytesIO
import uuid
from datetime import datetime
from typing import Dict, Any, Optional

from app.ml_models.model_loader import predict_disease, get_class_names
from app.utils.disease_metadata import get_disease_by_class, DISEASE_CLASSES

logger = logging.getLogger(__name__)

# Image preprocessing constants
IMG_SIZE = 224

def preprocess_image(image_bytes: bytes) -> np.ndarray:
    """
    Preprocess image for TFLite model inference
    Input: Raw image bytes
    Output: Preprocessed numpy array (1, 224, 224, 3) with values [0, 1]
    """
    try:
        # Load image
        img = Image.open(BytesIO(image_bytes)).convert('RGB')

        # Resize to model input size (224x224)
        img = img.resize((IMG_SIZE, IMG_SIZE))

        # Convert to numpy array
        img_array = np.array(img, dtype=np.float32)

        # Normalize to [0, 1]
        img_array = img_array / 255.0

        # Add batch dimension: (224, 224, 3) -> (1, 224, 224, 3)
        img_array = np.expand_dims(img_array, axis=0)

        logger.info(f"✅ Image preprocessed: shape={img_array.shape}, dtype={img_array.dtype}")
        return img_array

    except Exception as e:
        logger.error(f"❌ Image preprocessing failed: {e}")
        raise ValueError(f"Invalid image: {str(e)}")

def detect_disease(image_bytes: bytes,
                  user_id: Optional[str] = None,
                  field_id: Optional[str] = None,
                  batch_id: Optional[str] = None) -> Dict[str, Any]:
    """
    Main disease detection function using TFLite model

    Args:
        image_bytes: Raw image data
        user_id: Optional user identifier
        field_id: Optional field identifier
        batch_id: Optional batch identifier

    Returns:
        {
            'detection_id': str,
            'disease_name': str,
            'disease_class': int,
            'confidence': float,
            'severity': str,
            'affected_area_percentage': float,
            'treatments': list,
            'recommendations': list,
            'timestamp': str,
            'status': 'success'
        }
    """
    try:
        # Step 1: Preprocess image
        logger.info("🔄 Step 1: Preprocessing image...")
        preprocessed_img = preprocess_image(image_bytes)

        # Step 2: Run TFLite inference
        logger.info("🔄 Step 2: Running TFLite model inference...")
        predictions = predict_disease(preprocessed_img)

        # Step 3: Get prediction results
        class_id = int(np.argmax(predictions[0]))
        confidence = float(np.max(predictions[0]))

        logger.info(f"✅ Prediction complete: class={class_id}, confidence={confidence:.4f}")

        # Step 4: Get disease metadata
        disease_info = get_disease_by_class(class_id)

        if not disease_info:
            raise ValueError(f"Unknown disease class: {class_id}")

        # Step 5: Calculate severity based on confidence
        if confidence > 0.95:
            severity_level = 'Critical'
        elif confidence > 0.85:
            severity_level = disease_info.get('severity', 'High')
        elif confidence > 0.70:
            severity_level = 'Medium'
        else:
            severity_level = 'Low'

        # Step 6: Calculate affected area percentage
        # Higher confidence = higher affected area
        affected_area = min(confidence * 100, 95.0)

        # Step 7: Generate detection ID
        detection_id = str(uuid.uuid4())

        # Step 8: Construct result
        result = {
            'detection_id': detection_id,
            'disease_name': disease_info.get('name', 'Unknown'),
            'disease_class': class_id,
            'scientific_name': disease_info.get('scientific_name', ''),
            'description': disease_info.get('description', ''),
            'confidence': round(confidence, 4),
            'severity': severity_level,
            'affected_area_percentage': round(affected_area, 2),
            'symptoms': disease_info.get('symptoms', []),
            'causes': disease_info.get('causes', []),
            'treatments': disease_info.get('treatments', []),
            'recommendations': disease_info.get('recommendations', []),
            'user_id': user_id,
            'field_id': field_id,
            'batch_id': batch_id,
            'timestamp': datetime.utcnow().isoformat(),
            'model_info': {
                'type': 'TFLite',
                'input_size': IMG_SIZE,
                'num_classes': 6
            },
            'status': 'success'
        }

        logger.info(f"✅ Disease detected: {disease_info.get('name')} ({confidence:.2%} confidence)")
        return result

    except ValueError as ve:
        logger.error(f"⚠️ Validation error: {ve}")
        return {
            'status': 'error',
            'message': str(ve),
            'error_type': 'validation_error'
        }
    except Exception as e:
        logger.error(f"❌ Disease detection failed: {e}", exc_info=True)
        return {
            'status': 'error',
            'message': f"Detection failed: {str(e)}",
            'error_type': 'detection_error'
        }

def get_disease_details(disease_name: str) -> Dict[str, Any]:
    """Get detailed info about a disease by name"""
    for disease_info in DISEASE_CLASSES.values():
        if disease_info['name'].lower() == disease_name.lower():
            return disease_info
    return {}
