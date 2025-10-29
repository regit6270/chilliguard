"""Recommendation engine for treatment suggestions"""
import logging
from typing import Dict, Any, List
from app.core.database import db

logger = logging.getLogger(__name__)

def recommend_treatment(disease_name: str, severity: str, field_id: str = None) -> Dict[str, Any]:
    """
    Generate treatment recommendations for detected disease

    Args:
        disease_name: Name of detected disease
        severity: Disease severity (mild, moderate, severe)
        field_id: Optional field ID for context-aware recommendations

    Returns:
        Dictionary with treatment recommendations
    """
    try:
        # Treatment database (can be moved to Firestore later)
        treatments = _get_treatment_database()

        disease_treatments = treatments.get(disease_name, {})

        if not disease_treatments:
            logger.warning(f'No treatments found for disease: {disease_name}')
            return {
                'disease_name': disease_name,
                'severity': severity,
                'primary_treatments': [],
                'alternative_treatments': [],
                'preventive_measures': []
            }

        # Select treatments based on severity
        primary = disease_treatments.get('primary', [])
        alternative = disease_treatments.get('alternative', [])
        preventive = disease_treatments.get('preventive', [])

        # Filter by severity if needed
        if severity == 'severe':
            primary = [t for t in primary if t.get('effectiveness') == 'high']

        return {
            'disease_name': disease_name,
            'severity': severity,
            'primary_treatments': primary[:3],  # Top 3
            'alternative_treatments': alternative[:2],  # Top 2
            'preventive_measures': preventive,
            'general_advice': _get_general_advice(severity)
        }

    except Exception as e:
        logger.error(f'Error generating treatment recommendations: {str(e)}')
        raise


def _get_treatment_database() -> Dict[str, Any]:
    """Get treatment recommendations database"""
    return {
        'anthracnose_leaf_spot': {
            'primary': [
                {
                    'name': 'Mancozeb 75% WP',
                    'type': 'chemical',
                    'dosage': '2g per liter water',
                    'application': 'Foliar spray every 7-10 days',
                    'effectiveness': 'high',
                    'cost_estimate': '₹500-800 per hectare',
                    'precautions': 'Use protective gear, avoid spraying during rain'
                },
                {
                    'name': 'Copper Oxychloride 50% WP',
                    'type': 'chemical',
                    'dosage': '3g per liter water',
                    'application': 'Foliar spray, 2-3 applications at 10-day interval',
                    'effectiveness': 'high',
                    'cost_estimate': '₹400-600 per hectare',
                    'precautions': 'Do not mix with other pesticides'
                }
            ],
            'alternative': [
                {
                    'name': 'Neem Oil',
                    'type': 'organic',
                    'dosage': '5ml per liter water',
                    'application': 'Spray on affected parts',
                    'effectiveness': 'moderate',
                    'cost_estimate': '₹300-500 per hectare'
                },
                {
                    'name': 'Trichoderma viride',
                    'type': 'biological',
                    'dosage': '5g per liter water',
                    'application': 'Soil application and foliar spray',
                    'effectiveness': 'moderate',
                    'cost_estimate': '₹200-400 per hectare'
                }
            ],
            'preventive': [
                'Use disease-free seeds',
                'Maintain proper plant spacing (45-60 cm)',
                'Avoid overhead irrigation',
                'Remove and destroy infected plant debris',
                'Ensure good drainage'
            ]
        },
        'bacterial_spot': {
            'primary': [
                {
                    'name': 'Streptocycline',
                    'type': 'chemical',
                    'dosage': '0.5g per liter water',
                    'application': 'Spray at 7-10 day intervals',
                    'effectiveness': 'high',
                    'cost_estimate': '₹600-900 per hectare'
                }
            ],
            'alternative': [
                {
                    'name': 'Copper Hydroxide',
                    'type': 'chemical',
                    'dosage': '2.5g per liter water',
                    'application': 'Preventive spray',
                    'effectiveness': 'moderate',
                    'cost_estimate': '₹400-600 per hectare'
                }
            ],
            'preventive': [
                'Use certified disease-free seeds',
                'Practice crop rotation',
                'Avoid working with wet plants',
                'Control insect vectors',
                'Use drip irrigation instead of overhead'
            ]
        },
        'powdery_mildew': {
            'primary': [
                {
                    'name': 'Sulfur 80% WP',
                    'type': 'chemical',
                    'dosage': '2-3g per liter water',
                    'application': 'Spray at first sign of disease',
                    'effectiveness': 'high',
                    'cost_estimate': '₹300-500 per hectare'
                }
            ],
            'alternative': [
                {
                    'name': 'Potassium Bicarbonate',
                    'type': 'organic',
                    'dosage': '5g per liter water',
                    'application': 'Weekly spray',
                    'effectiveness': 'moderate',
                    'cost_estimate': '₹200-350 per hectare'
                }
            ],
            'preventive': [
                'Ensure good air circulation',
                'Avoid excessive nitrogen fertilization',
                'Water early morning',
                'Remove infected leaves'
            ]
        },
        'healthy': {
            'primary': [],
            'alternative': [],
            'preventive': [
                'Continue regular monitoring',
                'Maintain balanced fertilization',
                'Ensure proper irrigation',
                'Practice integrated pest management'
            ]
        }
    }


def _get_general_advice(severity: str) -> str:
    """Get general advice based on severity"""
    advice = {
        'mild': 'Early intervention is key. Apply treatments as recommended and monitor progress closely.',
        'moderate': 'Immediate action required. Follow treatment schedule strictly and consider consulting an agricultural expert.',
        'severe': 'Critical situation. Apply intensive treatment regimen. Consider removing severely infected plants to prevent spread. Consult agricultural extension officer immediately.'
    }
    return advice.get(severity, 'Monitor the situation and apply recommended treatments.')
