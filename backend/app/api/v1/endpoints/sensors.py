from flask import Blueprint, jsonify, request
from app.services.realtime_db import get_rtdb_service

bp = Blueprint('sensors', __name__, url_prefix='/sensors')


@bp.route('/latest', methods=['GET'])
def get_latest_sensor_reading():
    """
    Get latest sensor reading from RTDB (not Firestore)
    Query param: field_id
    """
    field_id = request.args.get('field_id', 'field_123')

    try:
        # Fetch from RTDB instead of Firestore
        sensor_data = get_rtdb_service().get_latest_sensor_reading(field_id)

        if not sensor_data:
            return jsonify({
                'success': False,
                'error': 'No sensor data found for this field'
            }), 404

        return jsonify({
            'success': True,
            'data': sensor_data
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@bp.route('/history', methods=['GET'])
def get_sensor_history():
    """
    Get historical sensor readings from RTDB
    Query params: field_id, duration (e.g., '7d', '14d', '30d')
    """
    field_id = request.args.get('field_id', 'field_123')
    duration = request.args.get('duration', '7d')

    # Parse duration
    duration_days = int(duration.replace('d', ''))

    try:
        # Fetch from RTDB
        historical_data = get_rtdb_service().get_sensor_history(field_id, duration_days)

        return jsonify({
            'success': True,
            'data': {
                'field_id': field_id,
                'duration': duration,
                'readings': historical_data,
                'count': len(historical_data)
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500
