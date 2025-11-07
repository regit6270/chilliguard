"""
Disease detection API endpoint - SIMPLIFIED VERSION
"""
from flask import Blueprint, request, jsonify
import logging
import os
from typing import Tuple

from app.services.disease_detection_service import detect_disease, get_disease_details

logger = logging.getLogger(__name__)

bp = Blueprint('disease_detection', __name__, url_prefix='/disease')

ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'gif', 'bmp'}
MAX_FILE_SIZE = 10 * 1024 * 1024

def allowed_file(filename: str) -> bool:
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@bp.route('/detect', methods=['POST'])
def detect_disease_endpoint() -> Tuple[dict, int]:
    """Detect disease from uploaded image"""
    try:
        logger.info("🔄 Disease detection request received")

        if 'image' not in request.files:
            return jsonify({'error': 'No image file provided'}), 400

        file = request.files['image']

        if not file or file.filename == '':
            return jsonify({'error': 'No file selected'}), 400

        if not allowed_file(file.filename):
            return jsonify({'error': 'Invalid file type'}), 400

        image_bytes = file.read()
        logger.info(f"Image loaded: {len(image_bytes)} bytes")

        # Get optional parameters
        user_id = request.form.get('user_id', 'test_user')
        field_id = request.form.get('field_id', 'test_field')
        batch_id = request.form.get('batch_id')

        result = detect_disease(
            image_bytes=image_bytes,
            user_id=user_id,
            field_id=field_id,
            batch_id=batch_id
        )

        if result.get('status') == 'error':
            logger.error(f"Detection error: {result.get('message')}")
            return jsonify(result), 400

        logger.info(f"✅ Detection successful: {result.get('disease_name')}")
        return jsonify(result), 200

    except Exception as e:
        logger.error(f"❌ Endpoint error: {e}", exc_info=True)
        return jsonify({
            'status': 'error',
            'message': str(e),
            'error_type': 'server_error'
        }), 500

@bp.route('/details/<disease_name>', methods=['GET'])
def get_disease_details_endpoint(disease_name: str) -> Tuple[dict, int]:
    """Get detailed information about a disease"""
    try:
        logger.info(f"Fetching disease details for: {disease_name}")

        details = get_disease_details(disease_name)

        if not details:
            return jsonify({'error': f'Disease not found: {disease_name}'}), 404

        return jsonify(details), 200

    except Exception as e:
        logger.error(f"Error: {e}")
        return jsonify({'error': str(e)}), 500

@bp.route('/health', methods=['GET'])
def health_check() -> Tuple[dict, int]:
    """Health check endpoint"""
    try:
        return jsonify({
            'status': 'healthy',
            'service': 'disease_detection'
        }), 200
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return jsonify({'status': 'unhealthy', 'message': str(e)}), 503
