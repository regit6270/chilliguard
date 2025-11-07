"""Notification service for push notifications and alerts"""
from __future__ import annotations

import logging
from datetime import datetime
from typing import Any, Dict, List, Optional, Tuple

from firebase_admin import messaging  # type: ignore[import-untyped]

from app.core.database import db

logger = logging.getLogger(__name__)


def send_push_notification(
    user_id: str,
    title: str,
    body: str,
    data: Optional[Dict[str, str]] = None,
    priority: str = 'normal'
) -> bool:
    """
    Send push notification to user's device

    Args:
        user_id: User ID
        title: Notification title
        body: Notification body
        data: Additional data payload
        priority: normal or high

    Returns:
        Boolean indicating success
    """
    try:
        # Get user's FCM token
        user = db.get_document('users', user_id)
        if not user or not user.get('fcm_token'):
            logger.warning(f'No FCM token found for user {user_id}')
            return False

        fcm_token = user.get('fcm_token')

        # Create message
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body),
            data=data or {},
            token=fcm_token,
            android=messaging.AndroidConfig(
                priority=priority,
                notification=messaging.AndroidNotification(
                    channel_id='chilliguard_alerts' if priority == 'high' else 'chilliguard_info',
                    icon='ic_notification',
                    color='#2E7D32')))

        # Send message
        response = messaging.send(message)
        logger.info(f'Successfully sent notification to user {
                    user_id}: {response}')

        # Store notification in database
        db.create_document('notifications', {
            'user_id': user_id,
            'title': title,
            'body': body,
            'data': data,
            'sent_at': datetime.utcnow(),
            'read': False
        })

        return True

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error sending push notification: {str(e)}')
        return False


def send_alert_notification(
    field_id: str,
    alert_type: str,
    message: str,
    severity: str = 'normal',
) -> None:
    """
    Send alert notification to field owner

    Args:
        field_id: Field ID
        alert_type: Type of alert (sensor, disease, etc.)
        message: Alert message
        severity: normal, high, critical
    """
    try:
        # Get field owner
        field = db.get_document('fields', field_id)
        if not field:
            return

        user_id = field.get('user_id')
        if not isinstance(user_id, str):
            return

        # Determine priority and emoji
        priority_map: Dict[str, Tuple[str, str]] = {
            'normal': ('normal', '📊'),
            'high': ('high', '⚠️'),
            'critical': ('high', '🚨')
        }
        priority, emoji = priority_map.get(severity, ('normal', '📊'))

        # Send notification
        send_push_notification(
            user_id=user_id,
            title=f'{emoji} {alert_type.replace("_", " ").title()}',
            body=message,
            data={
                'type': 'alert',
                'field_id': field_id,
                'alert_type': alert_type,
                'severity': severity
            },
            priority=priority
        )

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error sending alert notification: {str(e)}')


def create_alert(
        field_id: str,
        alert_type: str,
        parameter: str,
        message: str,
        severity: str = 'normal') -> str:
    """
    Create and store alert in database

    Args:
        field_id: Field ID
        alert_type: Type of alert
        parameter: Related parameter (pH, moisture, etc.)
        message: Alert message
        severity: Alert severity

    Returns:
        Alert ID
    """
    try:
        alert_data = {
            'field_id': field_id,
            'alert_type': alert_type,
            'parameter': parameter,
            'message': message,
            'severity': severity,
            'timestamp': datetime.utcnow(),
            'acknowledged': False,
            'acknowledged_at': None
        }

        alert_id = db.create_document('alerts', alert_data)

        # Send push notification
        send_alert_notification(field_id, alert_type, message, severity)

        logger.info(f'Created alert {alert_id} for field {field_id}')
        return alert_id

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error creating alert: {str(e)}')
        raise


def get_user_alerts(
        user_id: str, unacknowledged_only: bool = False) -> List[Dict[str, Any]]:
    """Get all alerts for user's fields"""
    try:
        # Get user's fields
        fields = db.query_collection(
            'fields',
            filters=[('user_id', '==', user_id)]
        )

        field_ids = [f.get('field_id') for f in fields]

        if not field_ids:
            return []

        # Get alerts
        filters: List[Tuple[str, Any, Any]] = [('field_id', 'in', field_ids)]
        if unacknowledged_only:
            filters.append(('acknowledged', '==', False))

        alerts = db.query_collection(
            'alerts',
            filters=filters,
            order_by=[('timestamp', 'DESCENDING')],
            limit=50
        )

        return alerts

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting user alerts: {str(e)}')
        return []


def acknowledge_alert(alert_id: str, user_id: str) -> bool:
    """Mark alert as acknowledged"""
    try:
        alert = db.get_document('alerts', alert_id)
        if not alert:
            return False

        # Verify ownership
        field_id = alert.get('field_id')
        field = db.get_document('fields', field_id) if isinstance(field_id, str) else None
        if not field or field.get('user_id') != user_id:
            return False

        # Update alert
        db.update_document('alerts', alert_id, {
            'acknowledged': True,
            'acknowledged_at': datetime.utcnow()
        })

        return True

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error acknowledging alert: {str(e)}')
        return False
