from __future__ import annotations

import logging
from typing import Any, Dict, Tuple

from flask import Blueprint, Response, jsonify, request

from app.core.security import get_user_id, require_auth
from app.services.feasibility_service import (check_feasibility,
                                              get_crop_requirements,
                                              get_improvement_recommendations)

logger = logging.getLogger(__name__)

bp = Blueprint('feasibility', __name__, url_prefix='/feasibility')


@bp.route('/check', methods=['POST'])
@require_auth
def feasibility_check() -> Tuple[Response, int]:
    """Check soil feasibility for chilli cultivation"""
    try:
        data: Dict[str, Any] = request.get_json(silent=True) or {}
        field_id = data.get('field_id')
        crop_type = data.get('crop_type', 'chilli')

        if not field_id:
            return jsonify({'error': 'field_id is required'}), 400

        user_id = get_user_id()
        result = check_feasibility(field_id, crop_type, user_id)

        return jsonify(result), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error checking feasibility: {str(e)}')
        return jsonify({'error': 'Failed to check feasibility'}), 500


@bp.route('/improvements', methods=['GET'])
@require_auth
def get_improvements() -> Tuple[Response, int]:
    """Get soil improvement recommendations"""
    try:
        field_id = request.args.get('field_id')

        if not field_id:
            return jsonify({'error': 'field_id is required'}), 400

        user_id = get_user_id()
        recommendations = get_improvement_recommendations(field_id, user_id)

        return jsonify({'recommendations': recommendations}), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting improvements: {str(e)}')
        return jsonify({'error': 'Failed to get recommendations'}), 500


@bp.route('/crop-requirements', methods=['GET'])
def crop_requirements() -> Tuple[Response, int]:
    """Get crop requirements"""
    try:
        crop_type = request.args.get('crop', 'chilli')
        requirements = get_crop_requirements(crop_type)

        return jsonify(requirements), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting crop requirements: {str(e)}')
        return jsonify({'error': 'Failed to get requirements'}), 500
