"""Fields management API endpoints"""
from __future__ import annotations

import logging
import uuid
from datetime import datetime
from typing import Any, Dict, Tuple

from flask import Blueprint, Response, jsonify, request

from app.core.database import db
from app.core.security import get_user_id, require_auth


logger = logging.getLogger(__name__)

bp = Blueprint('fields', __name__, url_prefix='/fields')


@bp.route('', methods=['GET'])
@require_auth
def get_fields() -> Tuple[Response, int]:
    """Get all fields for user"""
    try:
        user_id = get_user_id()

        fields = db.query_collection(
            'fields',
            filters=[('user_id', '==', user_id)],
            order_by=[('created_at', 'DESCENDING')]
        )

        return jsonify({
            'fields': fields,
            'total': len(fields)
        }), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting fields: {str(e)}')
        return jsonify({'error': 'Failed to fetch fields'}), 500


@bp.route('/<field_id>', methods=['GET'])
@require_auth
def get_field(field_id: str) -> Tuple[Response, int]:
    """Get specific field details"""
    try:
        user_id = get_user_id()

        field = db.get_document('fields', field_id)
        if not field:
            return jsonify({'error': 'Field not found'}), 404

        # Verify ownership
        if field.get('user_id') != user_id:
            return jsonify({'error': 'Unauthorized'}), 403

        return jsonify(field), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting field: {str(e)}')
        return jsonify({'error': 'Failed to fetch field'}), 500


@bp.route('', methods=['POST'])
@require_auth
def create_field() -> Tuple[Response, int]:
    """Create new field"""
    try:
        user_id = get_user_id()
        data: Dict[str, Any] = request.get_json(silent=True) or {}

        # Validate required fields
        required = ['field_name', 'area']
        if not all(field in data for field in required):
            return jsonify({'error': 'Missing required fields'}), 400

        # Create field
        field_data = {
            'field_id': str(uuid.uuid4()),
            'user_id': user_id,
            'field_name': data['field_name'],
            'area': float(data['area']),
            'soil_type': data.get('soil_type'),
            'location': data.get('location'),
            'created_at': datetime.utcnow(),
            'updated_at': datetime.utcnow()
        }

        field_id = db.create_document(
            'fields', field_data, field_data['field_id'])

        return jsonify({
            'success': True,
            'field_id': field_id,
            'message': 'Field created successfully'
        }), 201

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error creating field: {str(e)}')
        return jsonify({'error': 'Failed to create field'}), 500


@bp.route('/<field_id>', methods=['PUT'])
@require_auth
def update_field(field_id: str) -> Tuple[Response, int]:
    """Update field information"""
    try:
        user_id = get_user_id()
        data: Dict[str, Any] = request.get_json(silent=True) or {}

        # Verify ownership
        field = db.get_document('fields', field_id)
        if not field or field.get('user_id') != user_id:
            return jsonify({'error': 'Unauthorized'}), 403

        # Update allowed fields
        update_data: Dict[str, Any] = {}
        allowed_fields = ['field_name', 'area', 'soil_type', 'location']

        for field_key in allowed_fields:
            if field_key in data:
                update_data[field_key] = data[field_key]

        update_data['updated_at'] = datetime.utcnow()

        db.update_document('fields', field_id, update_data)

        return jsonify({
            'success': True,
            'message': 'Field updated successfully'
        }), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error updating field: {str(e)}')
        return jsonify({'error': 'Failed to update field'}), 500
