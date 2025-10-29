"""Alerts and notifications API endpoints"""
from flask import Blueprint, request, jsonify
from app.core.security import require_auth, get_user_id
from app.services.notification_service import get_user_alerts, acknowledge_alert
from app.core.database import db
import logging

logger = logging.getLogger(__name__)

bp = Blueprint('alerts', __name__, url_prefix='/alerts')

@bp.route('', methods=['GET'])
@require_auth
def get_alerts():
    """Get all alerts for user"""
    try:
        user_id = get_user_id()
        unacknowledged_only = request.args.get('unacknowledged', 'false').lower() == 'true'

        alerts = get_user_alerts(user_id, unacknowledged_only)

        # Categorize by severity
        critical = [a for a in alerts if a.get('severity') == 'critical']
        high = [a for a in alerts if a.get('severity') == 'high']
        normal = [a for a in alerts if a.get('severity') == 'normal']

        return jsonify({
            'alerts': alerts,
            'total': len(alerts),
            'by_severity': {
                'critical': len(critical),
                'high': len(high),
                'normal': len(normal)
            }
        }), 200

    except Exception as e:
        logger.error(f'Error getting alerts: {str(e)}')
        return jsonify({'error': 'Failed to fetch alerts'}), 500


@bp.route('/<alert_id>/acknowledge', methods='POST'])
@require_auth
def acknowledge(alert_id):
    """Mark alert as acknowledged"""
    try:
        user_id = get_user_id()

        success = acknowledge_alert(alert_id, user_id)

        if not success:
            return jsonify({'error': 'Failed to acknowledge alert'}), 400

        return jsonify({
            'success': True,
            'message': 'Alert acknowledged'
        }), 200

    except Exception as e:
        logger.error(f'Error acknowledging alert: {str(e)}')
        return jsonify({'error': 'Failed to acknowledge alert'}), 500


@bp.route('/statistics', methods=['GET'])
@require_auth
def get_statistics():
    """Get alert statistics for user"""
    try:
        user_id = get_user_id()

        # Get all alerts (last 30 days)
        from datetime import datetime, timedelta
        start_date = datetime.utcnow() - timedelta(days=30)

        # Get user's fields
        fields = db.query_collection(
            'fields',
            filters=[('user_id', '==', user_id)]
        )
        field_ids = [f.get('field_id') for f in fields]

        if not field_ids:
            return jsonify({
                'total_alerts': 0,
                'by_severity': {},
                'by_type': {},
                'acknowledged_rate': 0
            }), 200

        # Get alerts
        alerts = db.query_collection(
            'alerts',
            filters=[
                ('field_id', 'in', field_ids),
                ('timestamp', '>=', start_date)
            ]
        )

        # Calculate statistics
        total = len(alerts)
        acknowledged = len([a for a in alerts if a.get('acknowledged')])

        by_severity = {}
        by_type = {}

        for alert in alerts:
            severity = alert.get('severity', 'unknown')
            alert_type = alert.get('alert_type', 'unknown')

            by_severity[severity] = by_severity.get(severity, 0) + 1
            by_type[alert_type] = by_type.get(alert_type, 0) + 1

        return jsonify({
            'total_alerts': total,
            'acknowledged': acknowledged,
            'acknowledged_rate': (acknowledged / total * 100) if total > 0 else 0,
            'by_severity': by_severity,
            'by_type': by_type,
            'period_days': 30
        }), 200

    except Exception as e:
        logger.error(f'Error getting alert statistics: {str(e)}')
        return jsonify({'error': 'Failed to fetch statistics'}), 500
