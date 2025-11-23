"""Crop batch management API endpoints"""
from __future__ import annotations

import logging
import uuid
from datetime import datetime
from typing import Any, Dict, List, Tuple

from flask import Blueprint, Response, jsonify, request

from app.core.database import db
from app.core.security import get_user_id, require_auth

logger = logging.getLogger(__name__)

bp = Blueprint('batches', __name__, url_prefix='/batches')


@bp.route('/', methods=['GET'])
@require_auth
def get_batches() -> Tuple[Response, int]:
    """Get all crop batches for user"""
    try:
        user_id = get_user_id()
        field_id = request.args.get('field_id')
        status = request.args.get('status')  # active, completed, all

        logger.info(f'Fetching batches for user_id={user_id}, field_id={field_id}, status={status}')

        # Build filters
        filters: List[Tuple[str, Any, Any]] = [('user_id', '==', user_id)]
        if field_id:
            filters.append(('field_id', '==', field_id))
        if status:
            # Map filter status to backend status values
            # "active" -> matches "active" or "growing"
            # "completed" -> matches "harvested" or "failed" or "completed"
            if status == 'active':
                # For active, we'll filter in Python to match both "active" and "growing"
                pass  # Don't filter by status here, filter in Python
            elif status == 'completed':
                # For completed, match harvested, failed, or completed
                pass  # Don't filter by status here, filter in Python
            else:
                # For other statuses, use exact match
                filters.append(('status', '==', status))

        # Query batches WITHOUT order_by to avoid index requirement
        # Sort in Python instead
        batches = db.query_collection_no_order(
            'crop_batches',
            filters=filters,
            limit=100
        )

        logger.info(f'Found {len(batches)} batches before filtering and sorting')

        # Filter by status if needed (handle status mapping - case insensitive)
        if status:
            if status.lower() == 'active':
                # Match "active" or "growing" status (case insensitive)
                batches = [b for b in batches if b.get('status', '').lower() in ['active', 'growing']]
                logger.info(f'After active filter: {len(batches)} batches (matching active/growing)')
            elif status.lower() == 'completed':
                # Match "harvested", "failed", or "completed" status (case insensitive)
                batches = [b for b in batches if b.get('status', '').lower() in ['harvested', 'failed', 'completed']]
                logger.info(f'After completed filter: {len(batches)} batches (matching harvested/failed/completed)')
            else:
                # For other statuses, use case-insensitive exact match
                batches = [b for b in batches if b.get('status', '').lower() == status.lower()]
                logger.info(f'After status filter ({status}): {len(batches)} batches')

        # Sort by planting_date in Python (handle both string and date types)
        def get_planting_date(batch):
            planting_date = batch.get('planting_date')
            if isinstance(planting_date, str):
                try:
                    from dateutil import parser
                    return parser.parse(planting_date)
                except Exception:
                    return datetime.min
            elif isinstance(planting_date, datetime):
                return planting_date
            else:
                return datetime.min

        batches.sort(key=get_planting_date, reverse=True)

        logger.info(f'Returning {len(batches)} batches sorted by planting_date')

        return jsonify({
            'batches': batches,
            'total': len(batches)
        }), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting batches: {str(e)}', exc_info=True)
        return jsonify({'error': f'Failed to fetch batches: {str(e)}'}), 500


@bp.route('/<batch_id>', methods=['GET'])
@require_auth
def get_batch(batch_id: str) -> Tuple[Response, int]:
    """Get specific batch details"""
    try:
        user_id = get_user_id()

        batch = db.get_document('crop_batches', batch_id)
        if not batch:
            return jsonify({'error': 'Batch not found'}), 404

        # Verify ownership
        if batch.get('user_id') != user_id:
            return jsonify({'error': 'Unauthorized'}), 403

        # Get additional data
        field_id_for_batch = batch.get('field_id')
        field = db.get_document('fields', field_id_for_batch) if isinstance(field_id_for_batch, str) else None

        # Get disease detections count
        detections = db.query_collection(
            'disease_detections',
            filters=[('batch_id', '==', batch_id)]
        )

        # Get treatments count
        treatments = db.query_collection(
            'treatments',
            filters=[('batch_id', '==', batch_id)]
        )

        return jsonify({
            'batch': batch,
            'field': field,
            'disease_detections_count': len(detections),
            'treatments_count': len(treatments)
        }), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting batch: {str(e)}')
        return jsonify({'error': 'Failed to fetch batch'}), 500


@bp.route('', methods=['POST'])
@require_auth
def create_batch() -> Tuple[Response, int]:
    """Create new crop batch"""
    try:
        user_id = get_user_id()
        data: Dict[str, Any] = request.get_json(silent=True) or {}

        logger.info(f'Creating batch for user_id={user_id}, data={data}')

        # Validate required fields
        required = ['field_id', 'crop_type', 'planting_date', 'area']
        missing = [field for field in required if field not in data]
        if missing:
            logger.warning(f'Missing required fields: {missing}')
            return jsonify({'error': f'Missing required fields: {", ".join(missing)}'}), 400

        # Verify field ownership
        field = db.get_document('fields', data['field_id'])
        if not field:
            logger.warning(f'Field not found: {data["field_id"]}')
            return jsonify({'error': 'Field not found'}), 400
        if field.get('user_id') != user_id:
            logger.warning(f'Field ownership mismatch: field.user_id={field.get("user_id")}, user_id={user_id}')
            return jsonify({'error': 'Invalid field'}), 400

        # Create batch
        batch_id = str(uuid.uuid4())
        batch_data = {
            'batch_id': batch_id,
            'user_id': user_id,
            'field_id': data['field_id'],
            'crop_type': data['crop_type'],
            'planting_date': data['planting_date'],
            'estimated_harvest_date': data.get('estimated_harvest_date'),
            'area': float(data['area']),
            'seed_variety': data.get('seed_variety'),
            'status': 'active',
            'health_score': 100.0,
            'created_at': datetime.utcnow(),
            'updated_at': datetime.utcnow()
        }

        logger.info(f'Creating batch document with batch_id={batch_id}')
        created_id = db.create_document(
            'crop_batches', batch_data, batch_id)

        logger.info(f'Batch created successfully: batch_id={created_id}')

        return jsonify({
            'success': True,
            'batch_id': created_id,
            'message': 'Batch created successfully'
        }), 201

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error creating batch: {str(e)}', exc_info=True)
        return jsonify({'error': f'Failed to create batch: {str(e)}'}), 500


@bp.route('/<batch_id>', methods=['PUT'])
@require_auth
def update_batch(batch_id: str) -> Tuple[Response, int]:
    """Update batch information"""
    try:
        user_id = get_user_id()
        data: Dict[str, Any] = request.get_json(silent=True) or {}

        # Verify ownership
        batch = db.get_document('crop_batches', batch_id)
        if not batch or batch.get('user_id') != user_id:
            return jsonify({'error': 'Unauthorized'}), 403

        # Update allowed fields
        update_data: Dict[str, Any] = {}
        allowed_fields = [
            'estimated_harvest_date',
            'actual_harvest_date',
            'status',
            'health_score',
            'seed_variety']

        for field in allowed_fields:
            if field in data:
                update_data[field] = data[field]

        update_data['updated_at'] = datetime.utcnow()

        db.update_document('crop_batches', batch_id, update_data)

        return jsonify({
            'success': True,
            'message': 'Batch updated successfully'
        }), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error updating batch: {str(e)}')
        return jsonify({'error': 'Failed to update batch'}), 500


@bp.route('/<batch_id>/timeline', methods=['GET'])
@require_auth
def get_batch_timeline(batch_id: str) -> Tuple[Response, int]:
    """Get timeline of events for a batch"""
    try:
        user_id = get_user_id()

        # Verify ownership
        batch = db.get_document('crop_batches', batch_id)
        if not batch or batch.get('user_id') != user_id:
            return jsonify({'error': 'Unauthorized'}), 403

        # Get all events
        timeline: List[Dict[str, Any]] = []

        # Add planting event
        timeline.append({
            'type': 'planting',
            'date': batch.get('planting_date'),
            'description': (
                f"Planted {batch.get('crop_type')} - "
                f"{batch.get('seed_variety', 'Unknown variety')}"
            )
        })

        # Get disease detections
        detections = db.query_collection(
            'disease_detections',
            filters=[('batch_id', '==', batch_id)],
            order_by=[('timestamp', 'ASCENDING')]
        )

        for detection in detections:
            timeline.append({
                'type': 'disease_detection',
                'date': detection.get('timestamp'),
                'description': f"Detected {detection.get('disease_name')} - {detection.get('severity')} severity"
            })

        # Get treatments
        treatments = db.query_collection(
            'treatments',
            filters=[('batch_id', '==', batch_id)],
            order_by=[('application_date', 'ASCENDING')]
        )

        for treatment in treatments:
            timeline.append({
                'type': 'treatment',
                'date': treatment.get('application_date'),
                'description': f"Applied {treatment.get('treatment_name')} - {treatment.get('treatment_type')}"
            })

        # Add harvest event if completed
        if batch.get('actual_harvest_date'):
            timeline.append({
                'type': 'harvest',
                'date': batch.get('actual_harvest_date'),
                'description': f"Harvested - Status: {batch.get('status')}"
            })

        # Sort timeline by date
        timeline.sort(key=lambda x: x['date'] if x['date'] else datetime.min)

        return jsonify({
            'batch_id': batch_id,
            'timeline': timeline,
            'total_events': len(timeline)
        }), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting batch timeline: {str(e)}')
        return jsonify({'error': 'Failed to fetch timeline'}), 500
