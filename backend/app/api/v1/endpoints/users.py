"""User profile API endpoints"""
from flask import Blueprint, request, jsonify
from datetime import datetime
from app.core.security import require_auth, get_user_id
from app.core.database import db
import logging

logger = logging.getLogger(__name__)

bp = Blueprint('users', __name__, url_prefix='/users')

@bp.route('/profile', methods=['GET'])
@require_auth
def get_profile():
    """Get user profile"""
    try:
        user_id = get_user_id()

        user = db.get_document('users', user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404

        return jsonify(user), 200

    except Exception as e:
        logger.error(f'Error getting profile: {str(e)}')
        return jsonify({'error': 'Failed to fetch profile'}), 500


@bp.route('/profile', methods=['PUT'])
@require_auth
def update_profile():
    """Update user profile"""
    try:
        user_id = get_user_id()
        data = request.get_json()

        # Update allowed fields
        update_data = {}
        allowed_fields = ['name', 'email', 'location', 'fcm_token']

        for field in allowed_fields:
            if field in data:
                update_data[field] = data[field]

        update_data['updated_at'] = datetime.utcnow()

        db.update_document('users', user_id, update_data)

        return jsonify({
            'success': True,
            'message': 'Profile updated successfully'
        }), 200

    except Exception as e:
        logger.error(f'Error updating profile: {str(e)}')
        return jsonify({'error': 'Failed to update profile'}), 500
