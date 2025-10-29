from flask import Blueprint, request, jsonify
from app.core.security import require_auth, get_user_id
from app.services.sensor_data_service import (
    get_latest_sensor_data,
    get_sensor_history,
    store_sensor_reading
)
import logging

logger = logging.getLogger(__name__)

bp = Blueprint('sensors', __name__, url_prefix='/sensors')

@bp.route('/latest', methods=['GET'])
@require_auth
def get_latest():
    """Get latest sensor readings for a field"""
    try:
        field_id = request.args.get('field_id')
        if not field_id:
            return jsonify({'error': 'field_id is required'}), 400

        user_id = get_user_id()
        data = get_latest_sensor_data(field_id, user_id)

        if not data:
            return jsonify({'error': 'No sensor data found'}), 404

        return jsonify(data), 200

    except Exception as e:
        logger.error(f'Error getting latest sensor data: {str(e)}')
        return jsonify({'error': 'Failed to fetch sensor data'}), 500

@bp.route('/history', methods=['GET'])
@require_auth
def get_history():
    """Get historical sensor readings"""
    try:
        field_id = request.args.get('field_id')
        duration = request.args.get('duration', '7d')

        if not field_id:
            return jsonify({'error': 'field_id is required'}), 400

        user_id = get_user_id()
        data = get_sensor_history(field_id, user_id, duration)

        return jsonify(data), 200

    except Exception as e:
        logger.error(f'Error getting sensor history: {str(e)}')
        return jsonify({'error': 'Failed to fetch sensor history'}), 500

@bp.route('/readings', methods=['POST'])
def store_reading():
    """Store sensor reading (called by IoT devices)"""
    try:
        data = request.get_json()

        required_fields = ['device_id', 'field_id', 'sensor_type']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        result = store_sensor_reading(
            data['field_id'],
            data['sensor_type'],
            data
        )

        return jsonify({'success': True, 'id': result}), 201

    except Exception as e:
        logger.error(f'Error storing sensor reading: {str(e)}')
        return jsonify({'error': 'Failed to store sensor reading'}), 500
