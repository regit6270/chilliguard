"""Sensor data service for IoT sensor management"""
from __future__ import annotations

import logging
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional

from app.core.database import db

logger = logging.getLogger(__name__)


def get_latest_sensor_data(
    field_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """
    Get the latest sensor reading for a field
    ⭐ FIX: Uses NO ORDER BY - sorts in Python to avoid index requirement

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

        # ⭐ FIX: Query WITHOUT order_by to avoid index
        readings = db.query_collection_no_order(
            'sensor_readings',
            filters=[('field_id', '==', field_id)],
            limit=10  # Fetch 10 docs, will sort in Python
        )

        if not readings:
            logger.info(f'No sensor readings found for field {field_id}')
            return None

        # ⭐ FIX: Sort by timestamp in Python (not Firestore)
        latest = sorted(
            readings,
            key=lambda x: x.get('timestamp', datetime.utcnow()),
            reverse=True
        )[0]

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
        }

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error fetching latest sensor data: {str(e)}')
        raise


def get_sensor_history(field_id: str, user_id: str,
                       duration: str = '7d') -> List[Dict[str, Any]]:
    """
    Get historical sensor readings for a field
    ⭐ FIXED: Handles STRING timestamps from Firestore
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

        logger.info(f'📅 Fetching readings since: {start_date.isoformat()}')

        # ⭐ FIX: Query WITHOUT timestamp filter (no order_by)
        readings = db.query_collection_no_order(
            'sensor_readings',
            filters=[('field_id', '==', field_id)],
            limit=50  # Fetch up to 50 docs
        )

        logger.info(f'📊 Retrieved {len(readings)} total documents')

        # ⭐ CRITICAL FIX: Handle STRING timestamps from Firestore
        filtered_readings = []
        for reading in readings:
            timestamp_str = reading.get('timestamp')

            try:
                # ⭐ CONVERT STRING to datetime
                if isinstance(timestamp_str, str):
                    # Parse ISO format string
                    timestamp = datetime.fromisoformat(timestamp_str.replace('Z', '+00:00'))
                elif isinstance(timestamp_str, datetime):
                    timestamp = timestamp_str
                else:
                    logger.warning(f'Unknown timestamp format: {type(timestamp_str)}')
                    continue

                # ⭐ NOW check if within date range
                if timestamp >= start_date:
                    filtered_readings.append(reading)
                    logger.debug(f'✅ Included: {reading.get("id")} - {timestamp.isoformat()}')
                else:
                    logger.debug(f'⏭️ Skipped (too old): {reading.get("id")} - {timestamp.isoformat()}')

            except Exception as parse_err:
                logger.warning(f'⚠️ Failed to parse timestamp: {timestamp_str} - {str(parse_err)}')
                continue

        logger.info(f'📊 Found {len(filtered_readings)} readings after date filtering')

        # ⭐ FIX: Sort by timestamp in Python
        sorted_readings = sorted(
            filtered_readings,
            key=lambda x: x.get('timestamp', ''),
            reverse=True
        )

        # ⭐ CRITICAL FIX: Format each document properly
        results = []
        for doc in sorted_readings:
            try:
                formatted_doc = {
                    'id': doc.get('id', ''),
                    'field_id': doc.get('field_id', field_id),
                    'timestamp': doc.get('timestamp', ''),
                    'ph': float(doc.get('ph', 0)),
                    'nitrogen': float(doc.get('nitrogen', 0)),
                    'phosphorus': float(doc.get('phosphorus', 0)),
                    'potassium': float(doc.get('potassium', 0)),
                    'moisture': float(doc.get('moisture', 0)),
                    'temperature': float(doc.get('temperature', 0)),
                    'ec': float(doc.get('ec', 0)),
                }
                results.append(formatted_doc)
                logger.debug(f'✅ Formatted: {formatted_doc["id"]}')

            except (ValueError, KeyError, TypeError) as e:
                logger.warning(f'⚠️ Skipping malformed doc: {str(e)}')
                continue

        logger.info(f'✅ Returning {len(results)} formatted readings')
        return results

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'❌ Error fetching sensor history: {str(e)}')
        return []




def store_sensor_reading(field_id: str, sensor_type: str,
                         data: Dict[str, Any]) -> str:
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
        _ = sensor_type  # reserved for contextual processing
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

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error storing sensor reading: {str(e)}')
        raise


def _parse_duration(duration: str) -> int:
    """Parse duration string to days"""
    duration = duration.lower()

    if duration.endswith('d'):
        return int(duration[:-1])
    if duration.endswith('w'):
        return int(duration[:-1]) * 7
    if duration.endswith('m'):
        return int(duration[:-1]) * 30
    return 7  # Default 7 days


def _check_sensor_alerts(field_id: str, reading: Dict[str, Any]) -> None:
    """Check sensor readings for critical conditions"""
    try:
        from app.core.config import Config

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
                logger.warning(
                    f'Alert created for field {field_id}: {
                        alert["message"]}')

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error checking sensor alerts: {str(e)}')
