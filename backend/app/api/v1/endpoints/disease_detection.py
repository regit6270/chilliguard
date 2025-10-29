from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
from app.core.security import require_auth, get_user_id
from app.services.disease_detection_service import (
    detect_disease,
    get_disease_details
)
import logging
import os

logger = logging.getLogger(__name__)

bp = Blueprint('disease_detection', __name__, url_prefix='/disease')

@bp.route('/detect', methods=['POST'])
@require_auth
def disease_detect():
    """Detect disease from leaf image"""
    try:
        # Check if image file is present
        if 'file' not in request.files:
            return jsonify({'error': 'No image file provided'}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({'error': 'No selected file'}), 400

        # Get optional parameters
        field_id = request.form.get('field_id')
        batch_id = request.form.get('batch_id')
        use_cloud = request.form.get('use_cloud', 'false').lower() == 'true'

        user_id = get_user_id()

        # Save temp file
        temp_path = os.path.join('/tmp', secure_filename(file.filename))
        file.save(temp_path)

        # Detect disease
        result = detect_disease(
            temp_path,
            field_id=field_id,
            batch_id=batch_id,
            user_id=user_id,
            use_cloud_model=use_cloud
        )

        # Clean up temp file
        os.remove(temp_path)

        return jsonify(result), 200

    except Exception as e:
        logger.error(f'Error detecting disease: {str(e)}')
        return jsonify({'error': 'Failed to detect disease'}), 500

@bp.route('/<disease_id>', methods=['GET'])
@require_auth
def get_disease(disease_id):
    """Get disease details"""
    try:
        disease = get_disease_details(disease_id)

        if not disease:
            return jsonify({'error': 'Disease not found'}), 404

        return jsonify(disease), 200

    except Exception as e:
        logger.error(f'Error getting disease: {str(e)}')
        return jsonify({'error': 'Failed to get disease details'}), 500
