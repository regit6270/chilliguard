"""Reports API endpoints"""
from __future__ import annotations

import logging
from typing import Any, Dict, List, Tuple

from flask import Blueprint, Response, jsonify, request

from app.core.database import db
from app.core.security import get_user_id, require_auth
from app.services.report_generator import generate_end_cycle_report


logger = logging.getLogger(__name__)

bp = Blueprint('reports', __name__, url_prefix='/reports')


@bp.route('/generate-end-cycle-report', methods=['POST'])
@require_auth
def generate_report() -> Tuple[Response, int]:
    """Generate end-cycle report for a batch"""
    try:
        user_id = get_user_id()
        data: Dict[str, Any] = request.get_json(silent=True) or {}

        batch_id = data.get('batch_id')
        if not batch_id:
            return jsonify({'error': 'batch_id is required'}), 400

        # Generate report
        report = generate_end_cycle_report(batch_id, user_id)

        return jsonify(report), 200

    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error generating report: {str(e)}')
        return jsonify({'error': 'Failed to generate report'}), 500


@bp.route('/<report_id>', methods=['GET'])
@require_auth
def get_report(report_id: str) -> Tuple[Response, int]:
    """Get report details"""
    try:
        user_id = get_user_id()

        report = db.get_document('reports', report_id)
        if not report:
            return jsonify({'error': 'Report not found'}), 404

        # Verify ownership
        if report.get('user_id') != user_id:
            return jsonify({'error': 'Unauthorized'}), 403

        return jsonify(report), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting report: {str(e)}')
        return jsonify({'error': 'Failed to fetch report'}), 500


@bp.route('/user-reports', methods=['GET'])
@require_auth
def get_user_reports() -> Tuple[Response, int]:
    """Get all reports for user"""
    try:
        user_id = get_user_id()
        report_type = request.args.get('type')  # end_cycle, comparison

        # Build filters
        filters: List[Tuple[str, Any, Any]] = [('user_id', '==', user_id)]
        if report_type:
            filters.append(('report_type', '==', report_type))

        reports = db.query_collection(
            'reports',
            filters=filters,
            order_by=[('generated_at', 'DESCENDING')],
            limit=50
        )

        return jsonify({
            'reports': reports,
            'total': len(reports)
        }), 200

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting user reports: {str(e)}')
        return jsonify({'error': 'Failed to fetch reports'}), 500
