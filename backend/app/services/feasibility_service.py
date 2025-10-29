from app.core.database import db
from app.config import Config
from app.services.sensor_data_service import get_latest_sensor_data
import logging

logger = logging.getLogger(__name__)

def check_feasibility(field_id, crop_type, user_id):
    """
    Check if soil is feasible for given crop

    Returns:
        dict: Feasibility score, status, and parameter breakdown
    """
    try:
        # Get latest sensor data
        sensor_data = get_latest_sensor_data(field_id, user_id)

        if not sensor_data:
            raise ValueError('No sensor data available for this field')

        # Get crop requirements
        requirements = get_crop_requirements(crop_type)

        # Calculate feasibility for each parameter
        scores = {}
        breakdown = {}

        for param, (min_val, max_val) in requirements.items():
            value = sensor_data.get(param)

            if value is None:
                continue

            # Calculate score
            if min_val <= value <= max_val:
                score = 100
                status = 'optimal'
            else:
                # Calculate deviation penalty
                if value < min_val:
                    deviation = min_val - value
                    range_size = max_val - min_val
                    score = max(0, 100 - (deviation / range_size * 100))
                    status = 'low'
                else:
                    deviation = value - max_val
                    range_size = max_val - min_val
                    score = max(0, 100 - (deviation / range_size * 100))
                    status = 'high'

            scores[param] = score
            breakdown[param] = {
                'value': value,
                'required_min': min_val,
                'required_max': max_val,
                'score': score,
                'status': status
            }

        # Calculate weighted feasibility score
        weights = Config.FEASIBILITY_WEIGHTS
        feasibility_score = sum(
            scores.get(param, 0) * weight
            for param, weight in weights.items()
        )

        # Determine overall status
        if feasibility_score >= Config.CHILLI_PH_MIN:  # Using placeholder, should be 75
            status = 'ready_for_sowing'
        elif feasibility_score >= 50:
            status = 'requires_minor_adjustments'
        else:
            status = 'needs_significant_improvement'

        return {
            'feasibility_score': round(feasibility_score, 2),
            'status': status,
            'breakdown': breakdown,
            'field_id': field_id,
            'crop_type': crop_type
        }

    except Exception as e:
        logger.error(f'Error checking feasibility: {str(e)}')
        raise

def get_crop_requirements(crop_type):
    """Get crop-specific requirements"""

    # Currently only supports chilli, but designed for extensibility
    requirements = {
        'chilli': {
            'ph': (Config.CHILLI_PH_MIN, Config.CHILLI_PH_MAX),
            'nitrogen': (Config.CHILLI_N_MIN, Config.CHILLI_N_MAX),
            'phosphorus': (Config.CHILLI_P_MIN, Config.CHILLI_P_MAX),
            'potassium': (Config.CHILLI_K_MIN, Config.CHILLI_K_MAX),
            'moisture': (Config.CHILLI_MOISTURE_MIN, Config.CHILLI_MOISTURE_MAX),
            'temperature': (Config.CHILLI_TEMP_MIN, Config.CHILLI_TEMP_MAX),
        }
    }

    return requirements.get(crop_type, requirements['chilli'])

def get_improvement_recommendations(field_id, user_id):
    """Get soil improvement recommendations based on feasibility check"""

    try:
        # Get feasibility results
        feasibility = check_feasibility(field_id, 'chilli', user_id)

        recommendations = []

        # Generate recommendations for each parameter
        for param, data in feasibility['breakdown'].items():
            if data['status'] != 'optimal':
                rec = _generate_parameter_recommendation(param, data)
                if rec:
                    recommendations.append(rec)

        # Sort by priority (critical first)
        recommendations.sort(key=lambda x: x['priority'], reverse=True)

        return recommendations

    except Exception as e:
        logger.error(f'Error getting recommendations: {str(e)}')
        raise

def _generate_parameter_recommendation(param, data):
    """Generate specific recommendation for a parameter"""

    recommendations_db = {
        'ph': {
            'high': {
                'issue': 'pH too high (alkaline)',
                'solution': 'Add sulfur to lower pH',
                'dosage': '500-800 kg/ha sulfur in 2 splits over 4 weeks',
                'timeline': '4 weeks',
                'organic_alternative': 'Add compost or peat moss',
                'estimated_cost': '₹3,000-5,000 per hectare',
                'priority': 95
            },
            'low': {
                'issue': 'pH too low (acidic)',
                'solution': 'Apply agricultural lime',
                'dosage': '2-3 tons/ha lime, incorporate 2-3 weeks before sowing',
                'timeline': '3 weeks',
                'organic_alternative': 'Use wood ash or dolomite lime',
                'estimated_cost': '₹4,000-6,000 per hectare',
                'priority': 95
            }
        },
        'nitrogen': {
            'low': {
                'issue': 'Nitrogen deficiency',
                'solution': 'Apply urea fertilizer',
                'dosage': '50 kg/ha urea in 2 splits (at sowing + 30 days)',
                'timeline': '2 weeks',
                'organic_alternative': 'Apply compost 5 tons/ha',
                'estimated_cost': '₹2,000-3,500 per hectare',
                'priority': 85
            }
        },
        'phosphorus': {
            'low': {
                'issue': 'Phosphorus deficiency',
                'solution': 'Apply Single Super Phosphate (SSP)',
                'dosage': '150 kg/ha SSP as basal application',
                'timeline': '1 week',
                'organic_alternative': 'Bone meal or rock phosphate',
                'estimated_cost': '₹2,500-4,000 per hectare',
                'priority': 80
            }
        },
        'potassium': {
            'low': {
                'issue': 'Potassium deficiency',
                'solution': 'Apply Muriate of Potash (MOP)',
                'dosage': '100 kg/ha MOP in splits',
                'timeline': '2 weeks',
                'organic_alternative': 'Wood ash or kelp meal',
                'estimated_cost': '₹2,000-3,000 per hectare',
                'priority': 75
            }
        },
        'moisture': {
            'high': {
                'issue': 'Excess soil moisture',
                'solution': 'Improve drainage',
                'dosage': 'Use raised beds (20cm height); mulching with straw 5cm',
                'timeline': '1-2 weeks',
                'organic_alternative': 'Natural drainage improvement',
                'estimated_cost': '₹5,000-8,000 per hectare',
                'priority': 90
            },
            'low': {
                'issue': 'Low soil moisture',
                'solution': 'Increase irrigation frequency',
                'dosage': 'Drip irrigation recommended; mulch with straw 5cm',
                'timeline': 'Immediate',
                'organic_alternative': 'Mulching with organic matter',
                'estimated_cost': '₹1,000-2,000 per hectare',
                'priority': 85
            }
        }
    }

    param_recs = recommendations_db.get(param, {})
    rec_data = param_recs.get(data['status'])

    if rec_data:
        return {
            'parameter': param,
            'current_value': data['value'],
            'required_range': f"{data['required_min']}-{data['required_max']}",
            **rec_data
        }

    return None
