"""Report generation service for end-cycle and analytical reports"""
from __future__ import annotations

import io
import logging
from datetime import datetime
from typing import Any, Dict, List

from reportlab.lib import colors  # type: ignore[import-untyped]
from reportlab.lib.enums import TA_CENTER  # type: ignore[import-untyped]
from reportlab.lib.pagesizes import letter  # type: ignore[import-untyped]
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet  # type: ignore[import-untyped]
from reportlab.lib.units import inch  # type: ignore[import-untyped]
from reportlab.platypus import (Paragraph, SimpleDocTemplate, Spacer,  # type: ignore[import-untyped]
                                Table, TableStyle)

from app.core.database import db
from app.core.firebase import get_storage_bucket

logger = logging.getLogger(__name__)


def generate_end_cycle_report(batch_id: str, user_id: str) -> Dict[str, Any]:
    """
    Generate comprehensive end-cycle report for a crop batch

    Args:
        batch_id: Crop batch ID
        user_id: User ID for authorization

    Returns:
        Dictionary with report data and PDF URL
    """
    try:
        # Fetch batch data
        batch = db.get_document('crop_batches', batch_id)
        if not batch or batch.get('user_id') != user_id:
            raise ValueError('Batch not found or unauthorized')

        # Fetch related data
        field_id = batch.get('field_id')
        field = db.get_document('fields', field_id) if isinstance(field_id, str) else None
        user = db.get_document('users', user_id) or {}

        # Get disease detections for this batch
        detections = db.query_collection(
            'disease_detections',
            filters=[('batch_id', '==', batch_id)],
            order_by=[('timestamp', 'ASCENDING')]
        )

        # Get treatments applied
        treatments = db.query_collection(
            'treatments',
            filters=[('batch_id', '==', batch_id)],
            order_by=[('application_date', 'ASCENDING')]
        )

        # Get sensor data summary
        if isinstance(field_id, str):
            sensor_summary = _get_sensor_summary(field_id, batch)
        else:
            sensor_summary = {'status': 'field_unavailable'}

        # Calculate metrics
        metrics = _calculate_batch_metrics(
            batch, detections, treatments, sensor_summary)

        # Generate PDF
        pdf_url = _generate_pdf_report(
            batch,
            field or {},
            user,
            detections,
            treatments,
            sensor_summary,
            metrics)

        # Store report record
        report_data = {
            'batch_id': batch_id,
            'user_id': user_id,
            'report_type': 'end_cycle',
            'title': f"End Cycle Report - {batch.get('crop_type')} - {batch.get('planting_date')}",
            'pdf_url': pdf_url,
            'data': metrics,
            'generated_at': datetime.utcnow()
        }

        report_id = db.create_document('reports', report_data)

        return {
            'report_id': report_id,
            'pdf_url': pdf_url,
            'metrics': metrics,
            'generated_at': datetime.utcnow().isoformat()
        }

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error generating end-cycle report: {str(e)}')
        raise


def generate_batch_comparison(
        batch_ids: List[str], user_id: str) -> Dict[str, Any]:
    """
    Generate comparison report for multiple batches

    Args:
        batch_ids: List of batch IDs to compare
        user_id: User ID for authorization

    Returns:
        Dictionary with comparison data
    """
    try:
        comparison_data: List[Dict[str, Any]] = []

        for batch_id in batch_ids:
            batch = db.get_document('crop_batches', batch_id)
            if not batch or batch.get('user_id') != user_id:
                continue

            # Get disease count
            detections = db.query_collection(
                'disease_detections',
                filters=[('batch_id', '==', batch_id)]
            )

            # Get treatment count
            treatments = db.query_collection(
                'treatments',
                filters=[('batch_id', '==', batch_id)]
            )

            comparison_data.append({
                'batch_id': batch_id,
                'crop_type': batch.get('crop_type'),
                'planting_date': batch.get('planting_date'),
                'harvest_date': batch.get('actual_harvest_date'),
                'status': batch.get('status'),
                'health_score': batch.get('health_score'),
                'disease_count': len(detections),
                'treatment_count': len(treatments),
                'area': batch.get('area')
            })

        return {
            'batches': comparison_data,
            'total_batches': len(comparison_data),
            'comparison_type': 'year_on_year',
            'generated_at': datetime.utcnow().isoformat()
        }

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error generating batch comparison: {str(e)}')
        raise


def _get_sensor_summary(
        field_id: str, batch: Dict[str, Any]) -> Dict[str, Any]:
    """Get sensor data summary for batch duration"""
    try:
        planting_date_value = batch.get('planting_date')
        harvest_date_value = batch.get('actual_harvest_date')

        from dateutil import parser

        if isinstance(planting_date_value, str):
            planting_date_parsed = parser.parse(planting_date_value).date()
        elif isinstance(planting_date_value, datetime):
            planting_date_parsed = planting_date_value.date()
        else:
            planting_date_parsed = datetime.utcnow().date()

        if isinstance(harvest_date_value, str):
            harvest_date_parsed = parser.parse(harvest_date_value).date()
        elif isinstance(harvest_date_value, datetime):
            harvest_date_parsed = harvest_date_value.date()
        elif harvest_date_value is None:
            harvest_date_parsed = datetime.utcnow().date()
        else:
            harvest_date_parsed = harvest_date_value

        start_datetime = datetime.combine(planting_date_parsed, datetime.min.time())
        end_datetime = datetime.combine(harvest_date_parsed, datetime.max.time())

        # Get all sensor readings in date range
        readings = db.query_collection(
            'sensor_readings',
            filters=[
                ('field_id', '==', field_id),
                ('timestamp', '>=', start_datetime),
                ('timestamp', '<=', end_datetime)
            ]
        )

        if not readings:
            return {'status': 'no_data'}

        # Calculate averages
        def _collect_numeric(key: str) -> List[float]:
            values: List[float] = []
            for record in readings:
                value = record.get(key)
                if isinstance(value, (int, float)):
                    values.append(float(value))
            return values

        ph_values = _collect_numeric('ph')
        n_values = _collect_numeric('nitrogen')
        p_values = _collect_numeric('phosphorus')
        k_values = _collect_numeric('potassium')
        moisture_values = _collect_numeric('moisture')
        temp_values = _collect_numeric('temperature')

        return {
            'status': 'available',
            'total_readings': len(readings),
            'avg_ph': sum(ph_values) / len(ph_values) if ph_values else 0,
            'avg_nitrogen': sum(n_values) / len(n_values) if n_values else 0,
            'avg_phosphorus': sum(p_values) / len(p_values) if p_values else 0,
            'avg_potassium': sum(k_values) / len(k_values) if k_values else 0,
            'avg_moisture': sum(moisture_values) / len(moisture_values) if moisture_values else 0,
            'avg_temperature': sum(temp_values) / len(temp_values) if temp_values else 0}

    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error getting sensor summary: {str(e)}')
        return {'status': 'error'}


def _calculate_batch_metrics(
    batch: Dict[str, Any],
    detections: List[Dict[str, Any]],
    treatments: List[Dict[str, Any]],
    sensor_summary: Dict[str, Any],
) -> Dict[str, Any]:
    """Calculate comprehensive batch metrics"""

    # Calculate duration
    from dateutil import parser

    planting_date_value = batch.get('planting_date')
    harvest_date_value = batch.get('actual_harvest_date')

    if isinstance(planting_date_value, str):
        planting_date = parser.parse(planting_date_value).date()
    elif isinstance(planting_date_value, datetime):
        planting_date = planting_date_value.date()
    else:
        planting_date = datetime.utcnow().date()

    if isinstance(harvest_date_value, str):
        harvest_date = parser.parse(harvest_date_value).date()
    elif isinstance(harvest_date_value, datetime):
        harvest_date = harvest_date_value.date()
    elif harvest_date_value is None:
        harvest_date = datetime.utcnow().date()
    else:
        harvest_date = harvest_date_value

    duration_days = (harvest_date - planting_date).days

    # Disease statistics
    total_detections = len(detections)
    unique_diseases = len(set(d.get('disease_name')
                          for d in detections if d.get('disease_name') != 'healthy'))

    # Treatment statistics
    total_treatments = len(treatments)
    treatment_cost = sum(
        float(t['cost'])
        for t in treatments
        if isinstance(t.get('cost'), (int, float))
    )

    # Health score journey
    health_score_final = batch.get('health_score', 100)

    return {
        'duration_days': duration_days,
        'area_hectares': batch.get('area', 0),
        'status': batch.get('status'),
        'total_disease_detections': total_detections,
        'unique_diseases': unique_diseases,
        'total_treatments': total_treatments,
        'treatment_cost': treatment_cost,
        'health_score_final': health_score_final,
        'sensor_summary': sensor_summary,
        'seed_variety': batch.get('seed_variety', 'Unknown')
    }


def _generate_pdf_report(
    batch: Dict[str, Any],
    field: Dict[str, Any],
    user: Dict[str, Any],
    detections: List[Dict[str, Any]],
    treatments: List[Dict[str, Any]],
    sensor_summary: Dict[str, Any],
    metrics: Dict[str, Any],
) -> str:
    """Generate PDF report and upload to Cloud Storage"""
    try:
        # Create PDF in memory
        buffer = io.BytesIO()
        doc = SimpleDocTemplate(buffer, pagesize=letter)
        story: List[Any] = []
        styles = getSampleStyleSheet()

        # Custom styles
        title_style = ParagraphStyle(
            'CustomTitle',
            parent=styles['Heading1'],
            fontSize=24,
            textColor=colors.HexColor('#2E7D32'),
            spaceAfter=30,
            alignment=TA_CENTER
        )

        heading_style = ParagraphStyle(
            'CustomHeading',
            parent=styles['Heading2'],
            fontSize=16,
            textColor=colors.HexColor('#2E7D32'),
            spaceAfter=12
        )

        # Title
        story.append(Paragraph('ChilliGuard - End Cycle Report', title_style))
        story.append(Spacer(1, 0.2 * inch))

        # Farmer & Field Info
        story.append(Paragraph('Farmer & Field Information', heading_style))
        farmer_data = [
            ['Farmer Name:', user.get('name', 'N/A')],
            ['Phone:', user.get('phone', 'N/A')],
            ['Field Name:', field.get('field_name', 'N/A')],
            ['Field Area:', f"{field.get('area', 0)} hectares"],
            ['Crop Type:', batch.get('crop_type', 'N/A').upper()],
            ['Seed Variety:', batch.get('seed_variety', 'Unknown')]
        ]

        farmer_table = Table(farmer_data, colWidths=[2 * inch, 4 * inch])
        farmer_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#E8F5E9')),
            ('TEXTCOLOR', (0, 0), (-1, -1), colors.black),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey)
        ]))
        story.append(farmer_table)
        story.append(Spacer(1, 0.3 * inch))

        # Cultivation Summary
        story.append(Paragraph('Cultivation Summary', heading_style))
        cultivation_data = [
            ['Planting Date:', str(batch.get('planting_date', 'N/A'))],
            ['Harvest Date:', str(batch.get('actual_harvest_date', 'N/A'))],
            ['Duration:', f"{metrics.get('duration_days', 0)} days"],
            ['Status:', batch.get('status', 'Unknown').upper()],
            ['Final Health Score:', f"{metrics.get('health_score_final', 0)}/100"]
        ]

        cultivation_table = Table(
            cultivation_data, colWidths=[
                2 * inch, 4 * inch])
        cultivation_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#E8F5E9')),
            ('TEXTCOLOR', (0, 0), (-1, -1), colors.black),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey)
        ]))
        story.append(cultivation_table)
        story.append(Spacer(1, 0.3 * inch))

        # Disease & Treatment Summary
        story.append(Paragraph('Disease & Treatment Summary', heading_style))
        disease_data = [
            ['Total Disease Detections:', str(metrics.get('total_disease_detections', 0))],
            ['Unique Diseases:', str(metrics.get('unique_diseases', 0))],
            ['Total Treatments Applied:', str(metrics.get('total_treatments', 0))],
            ['Treatment Cost:', f"₹{metrics.get('treatment_cost', 0):.2f}"]
        ]

        disease_table = Table(disease_data, colWidths=[2.5 * inch, 3.5 * inch])
        disease_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#FFF3E0')),
            ('TEXTCOLOR', (0, 0), (-1, -1), colors.black),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey)
        ]))
        story.append(disease_table)
        story.append(Spacer(1, 0.3 * inch))

        # Soil Health Summary
        if sensor_summary.get('status') == 'available':
            story.append(
                Paragraph(
                    'Average Soil Health Parameters',
                    heading_style))
            soil_data = [
                ['pH:', f"{sensor_summary.get('avg_ph', 0):.2f}"],
                ['Nitrogen (N):', f"{sensor_summary.get('avg_nitrogen', 0):.1f} kg/ha"],
                ['Phosphorus (P):', f"{sensor_summary.get('avg_phosphorus', 0):.1f} kg/ha"],
                ['Potassium (K):', f"{sensor_summary.get('avg_potassium', 0):.1f} kg/ha"],
                ['Soil Moisture:', f"{sensor_summary.get('avg_moisture', 0):.1f}%"],
                ['Temperature:', f"{sensor_summary.get('avg_temperature', 0):.1f}°C"]
            ]

            soil_table = Table(soil_data, colWidths=[2 * inch, 4 * inch])
            soil_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#E3F2FD')),
                ('TEXTCOLOR', (0, 0), (-1, -1), colors.black),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 10),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.grey)
            ]))
            story.append(soil_table)

        # Footer
        story.append(Spacer(1, 0.5 * inch))
        story.append(
            Paragraph(
                f'Report Generated: {
                    datetime.utcnow().strftime("%B %d, %Y at %H:%M UTC")}',
                styles['Normal']))
        story.append(
            Paragraph(
                'Powered by ChilliGuard - Smart Agriculture',
                styles['Normal']))

        # Build PDF
        doc.build(story)

        # Upload to Cloud Storage
        buffer.seek(0)
        bucket = get_storage_bucket()
        user_identifier = user.get('user_id') or 'anonymous'
        batch_identifier = batch.get('batch_id') or batch.get('id') or 'batch'
        blob_name = (
            f"reports/{user_identifier}/{batch_identifier}_end_cycle_"
            f"{datetime.utcnow().strftime('%Y%m%d')}.pdf"
        )
        blob = bucket.blob(blob_name)
        blob.upload_from_file(buffer, content_type='application/pdf')
        blob.make_public()

        logger.info('Generated PDF report: %s', blob.public_url)
        return str(blob.public_url)

    except Exception as e:  # pylint: disable=broad-except
        logger.error('Error generating PDF: %s', str(e))
        raise
