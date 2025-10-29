"""Sensor data service for IoT sensor management"""
import logging
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional
from app.core.database import db
from app.models.sensor_reading import SensorReading

logger = logging.getLogger(__name__)

def get_latest_sensor_data(field_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """
    Get the latest sensor reading for a field

    Args:
        field_id: Field ID
        user_id: User ID for authorization

    Returns:
        Dictionary with sensor readings or None
    """
    try:
        # Verify field belongs to user
        field = db.get_document('fields', field_id)
        if not field or field.get('user_id') != user_id:
            logger.warning(f'Unauthorized access to field {field_id} by user {user_id}')
            return None

        # Query latest sensor reading
        readings = db.query_collection(
            'sensor_readings',
            filters=[('field_id', '==', field_id)],
            order_by=[('timestamp', 'DESCENDING')],
            limit=1
        )

        if not readings:
            logger.info(f'No sensor readings found for field {field_id}')
            return None

        latest = readings[0]

        # Format response
        return {
            'field_id': field_id,
            'ph': latest.get('ph'),
            'nitrogen': latest.get('nitrogen'),
            'phosphorus': latest.get('phosphorus'),
            'potassium': latest.get('potassium'),
            'moisture': latest.get('moisture'),
            'temperature': latest.get('temperature'),
            'humidity': latest.get('humidity'),
            'timestamp': latest.get('timestamp'),
            'device_id': latest.get('device_id')
        }

    except Exception as e:
        logger.error(f'Error fetching latest sensor data: {str(e)}')
        raise


def get_sensor_history(field_id: str, user_id: str, duration: str = '7d') -> List[Dict[str, Any]]:
    """
    Get historical sensor readings for a field

    Args:
        field_id: Field ID
        user_id: User ID for authorization
        duration: Duration string (e.g., '7d', '30d', '3m')

    Returns:
        List of sensor readings
    """
    try:
        # Verify field belongs to user
        field = db.get_document('fields', field_id)
        if not field or field.get('user_id') != user_id:
            logger.warning(f'Unauthorized access to field {field_id} by user {user_id}')
            return []

        # Parse duration
        days = _parse_duration(duration)
        start_date = datetime.utcnow() - timedelta(days=days)

        # Query historical readings
        readings = db.query_collection(
            'sensor_readings',
            filters=[
                ('field_id', '==', field_id),
                ('timestamp', '>=', start_date)
            ],
            order_by=[('timestamp', 'ASCENDING')],
            limit=1000
        )

        # Format response with aggregated data points
        return [
            {
                'ph': r.get('ph'),
                'nitrogen': r.get('nitrogen'),
                'phosphorus': r.get('phosphorus'),
                'potassium': r.get('potassium'),
                'moisture': r.get('moisture'),
                'temperature': r.get('temperature'),
                'humidity': r.get('humidity'),
                'timestamp': r.get('timestamp').isoformat() if r.get('timestamp') else None
            }
            for r in readings
        ]

    except Exception as e:
        logger.error(f'Error fetching sensor history: {str(e)}')
        raise


def store_sensor_reading(field_id: str, sensor_type: str, data: Dict[str, Any]) -> str:
    """
    Store a new sensor reading from IoT device

    Args:
        field_id: Field ID
        sensor_type: Type of sensor
        data: Sensor data payload

    Returns:
        Reading ID
    """
    try:
        reading_data = {
            'field_id': field_id,
            'device_id': data.get('device_id'),
            'ph': data.get('ph'),
            'nitrogen': data.get('nitrogen'),
            'phosphorus': data.get('phosphorus'),
            'potassium': data.get('potassium'),
            'moisture': data.get('moisture'),
            'temperature': data.get('temperature'),
            'humidity': data.get('humidity'),
            'timestamp': datetime.utcnow()
        }

        # Store in Firestore
        reading_id = db.create_document('sensor_readings', reading_data)

        logger.info(f'Stored sensor reading {reading_id} for field {field_id}')

        # Check for critical alerts
        _check_sensor_alerts(field_id, reading_data)

        return reading_id

    except Exception as e:
        logger.error(f'Error storing sensor reading: {str(e)}')
        raise


def _parse_duration(duration: str) -> int:
    """Parse duration string to days"""
    duration = duration.lower()

    if duration.endswith('d'):
        return int(duration[:-1])
    elif duration.endswith('w'):
        return int(duration[:-1]) * 7
    elif duration.endswith('m'):
        return int(duration[:-1]) * 30
    else:
        return 7  # Default 7 days


def _check_sensor_alerts(field_id: str, reading: Dict[str, Any]):
    """Check sensor readings for critical conditions"""
    try:
        from app.config import Config

        alerts = []

        # pH alerts
        if reading.get('ph'):
            if reading['ph'] < Config.CHILLI_PH_MIN - 0.5:
                alerts.append({
                    'type': 'critical',
                    'parameter': 'pH',
                    'message': f'pH critically low: {reading["ph"]:.1f}'
                })
            elif reading['ph'] > Config.CHILLI_PH_MAX + 0.5:
                alerts.append({
                    'type': 'critical',
                    'parameter': 'pH',
                    'message': f'pH critically high: {reading["ph"]:.1f}'
                })

        # Moisture alerts
        if reading.get('moisture'):
            if reading['moisture'] < Config.CHILLI_MOISTURE_MIN - 10:
                alerts.append({
                    'type': 'critical',
                    'parameter': 'moisture',
                    'message': f'Soil moisture critically low: {reading["moisture"]:.1f}%'
                })

        # Store alerts if any
        if alerts:
            for alert in alerts:
                db.create_document('alerts', {
                    'field_id': field_id,
                    'alert_type': alert['type'],
                    'parameter': alert['parameter'],
                    'message': alert['message'],
                    'timestamp': datetime.utcnow(),
                    'acknowledged': False
                })
                logger.warning(f'Alert created for field {field_id}: {alert["message"]}')

    except Exception as e:
        logger.error(f'Error checking sensor alerts: {str(e)}')
