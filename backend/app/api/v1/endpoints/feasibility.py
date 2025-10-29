from flask import Blueprint, request, jsonify
from app.core.security import require_auth, get_user_id
from app.services.feasibility_service import (
    check_feasibility,
    get_improvement_recommendations,
    get_crop_requirements
)
import logging

logger = logging.getLogger(__name__)

bp = Blueprint('feasibility', __name__, url_prefix='/feasibility')

@bp.route('/check', methods=['POST'])
@require_auth
def feasibility_check():
    """Check soil feasibility for chilli cultivation"""
    try:
        data = request.get_json()
        field_id = data.get('field_id')
        crop_type = data.get('crop_type', 'chilli')

        if not field_id:
            return jsonify({'error': 'field_id is required'}), 400

        user_id = get_user_id()
        result = check_feasibility(field_id, crop_type, user_id)

        return jsonify(result), 200

    except Exception as e:
        logger.error(f'Error checking feasibility: {str(e)}')
        return jsonify({'error': 'Failed to check feasibility'}), 500

@bp.route('/improvements', methods=['GET'])
@require_auth
def get_improvements():
    """Get soil improvement recommendations"""
    try:
        field_id = request.args.get('field_id')

        if not field_id:
            return jsonify({'error': 'field_id is required'}), 400

        user_id = get_user_id()
        recommendations = get_improvement_recommendations(field_id, user_id)

        return jsonify({'recommendations': recommendations}), 200

    except Exception as e:
        logger.error(f'Error getting improvements: {str(e)}')
        return jsonify({'error': 'Failed to get recommendations'}), 500

@bp.route('/crop-requirements', methods=['GET'])
def crop_requirements():
    """Get crop requirements"""
    try:
        crop_type = request.args.get('crop', 'chilli')
        requirements = get_crop_requirements(crop_type)

        return jsonify(requirements), 200

    except Exception as e:
        logger.error(f'Error getting crop requirements: {str(e)}')
        return jsonify({'error': 'Failed to get requirements'}), 500
