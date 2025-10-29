"""
Recommendations API Endpoints
Generates actionable recommendations for soil improvement and disease treatment
"""

from flask import Blueprint, request, jsonify
from typing import Dict, List
import logging

# Initialize blueprint
recommendations_bp = Blueprint('recommendations', __name__, url_prefix='/api/v1')

# Configure logging
logger = logging.getLogger(__name__)

# Recommendation rules database
SOIL_IMPROVEMENT_RULES = {
    "ph_high": {
        "issue": "pH too high (alkaline soil)",
        "issue_hi": "pH बहुत अधिक (क्षारीय मिट्टी)",
        "solution": "Apply sulfur to reduce pH",
        "solution_hi": "pH कम करने के लिए गंधक डालें",
        "dosage": "500-800 kg/ha sulfur, apply in 2 splits over 4 weeks",
        "timeline": "4 weeks",
        "organic_alternative": "Compost with pine needles or peat moss",
        "estimated_cost": "₹3,000-5,000",
        "priority": "high"
    },
    "ph_low": {
        "issue": "pH too low (acidic soil)",
        "issue_hi": "pH बहुत कम (अम्लीय मिट्टी)",
        "solution": "Apply lime to increase pH",
        "solution_hi": "pH बढ़ाने के लिए चूना डालें",
        "dosage": "2-3 tons/ha lime, incorporate 2-3 weeks before sowing",
        "timeline": "3 weeks",
        "organic_alternative": "Wood ash or bone meal",
        "estimated_cost": "₹8,000-12,000",
        "priority": "high"
    },
    "nitrogen_low": {
        "issue": "Nitrogen deficiency",
        "issue_hi": "नाइट्रोजन की कमी",
        "solution": "Apply nitrogen-rich fertilizer",
        "solution_hi": "नाइट्रोजन युक्त उर्वरक डालें",
        "dosage": "50 kg/ha urea, apply in 2 splits: at sowing and 30 days after",
        "timeline": "Immediate application recommended",
        "organic_alternative": "Compost 5 tons/ha or green manure",
        "estimated_cost": "₹1,500-2,500",
        "priority": "medium"
    },
    "phosphorus_low": {
        "issue": "Phosphorus deficiency",
        "issue_hi": "फॉस्फोरस की कमी",
        "solution": "Apply phosphate fertilizer",
        "solution_hi": "फॉस्फेट उर्वरक डालें",
        "dosage": "60 kg/ha single super phosphate at sowing",
        "timeline": "Before planting",
        "organic_alternative": "Bone meal or rock phosphate",
        "estimated_cost": "₹2,000-3,500",
        "priority": "medium"
    },
    "potassium_low": {
        "issue": "Potassium deficiency",
        "issue_hi": "पोटेशियम की कमी",
        "solution": "Apply potash fertilizer",
        "solution_hi": "पोटाश उर्वरक डालें",
        "dosage": "40 kg/ha muriate of potash in 2 splits",
        "timeline": "Split doses: sowing + 45 days",
        "organic_alternative": "Wood ash or kelp meal",
        "estimated_cost": "₹1,800-3,000",
        "priority": "medium"
    },
    "moisture_high": {
        "issue": "Excessive soil moisture",
        "issue_hi": "अत्यधिक मिट्टी में नमी",
        "solution": "Improve drainage system",
        "solution_hi": "जल निकासी प्रणाली में सुधार करें",
        "dosage": "Create raised beds (20cm height), install drainage channels",
        "timeline": "1-2 weeks",
        "organic_alternative": "Mulching to reduce waterlogging",
        "estimated_cost": "₹5,000-8,000",
        "priority": "high"
    },
    "moisture_low": {
        "issue": "Low soil moisture",
        "issue_hi": "कम मिट्टी में नमी",
        "solution": "Improve water retention",
        "solution_hi": "जल धारण क्षमता बढ़ाएँ",
        "dosage": "Apply mulch (5cm straw layer), install drip irrigation",
        "timeline": "Immediate",
        "organic_alternative": "Organic mulch with compost",
        "estimated_cost": "₹3,000-6,000",
        "priority": "high"
    }
}

DISEASE_TREATMENT_RULES = {
    "anthracnose": {
        "disease": "Anthracnose",
        "disease_hi": "एन्थ्रेक्नोज",
        "severity_low": {
            "treatment": "Remove infected leaves, improve air circulation",
            "chemical": "Copper oxychloride spray (2.5g/L water)",
            "organic": "Neem oil spray (5ml/L water) weekly",
            "frequency": "Weekly for 3 weeks"
        },
        "severity_high": {
            "treatment": "Remove and destroy infected plants",
            "chemical": "Mancozeb fungicide (2g/L) + Copper spray",
            "organic": "Bio-fungicide (Trichoderma) soil application",
            "frequency": "Twice weekly for 4 weeks"
        },
        "prevention": "Avoid overhead irrigation, maintain spacing",
        "cost_estimate": "₹800-1,500"
    },
    "powdery_mildew": {
        "disease": "Powdery Mildew",
        "disease_hi": "चूर्णिल आसिता",
        "severity_low": {
            "treatment": "Prune affected parts",
            "chemical": "Sulfur dust application",
            "organic": "Baking soda solution (1 tsp + 1L water)",
            "frequency": "Every 5 days for 2 weeks"
        },
        "severity_high": {
            "treatment": "Systemic fungicide required",
            "chemical": "Carbendazim spray (1g/L water)",
            "organic": "Milk spray (1:9 milk:water ratio)",
            "frequency": "Twice weekly for 3 weeks"
        },
        "prevention": "Reduce humidity, proper spacing",
        "cost_estimate": "₹600-1,200"
    },
    "leaf_spot": {
        "disease": "Leaf Spot",
        "disease_hi": "पत्ती धब्बा",
        "severity_low": {
            "treatment": "Remove affected leaves",
            "chemical": "Copper fungicide spray",
            "organic": "Garlic extract spray",
            "frequency": "Weekly for 2-3 weeks"
        },
        "severity_high": {
            "treatment": "Isolate plants, remove infected material",
            "chemical": "Chlorothalonil fungicide",
            "organic": "Neem + bio-fungicide combination",
            "frequency": "Twice weekly for 4 weeks"
        },
        "prevention": "Water at base, avoid leaf wetness",
        "cost_estimate": "₹700-1,400"
    }
}


@recommendations_bp.route('/soil-improvements', methods=['POST'])
def get_soil_improvements():
    """
    Generate soil improvement recommendations
    Request body: {
        "field_id": "string",
        "sensor_data": {
            "ph": 8.2,
            "nitrogen": 80,
            "phosphorus": 40,
            "potassium": 35,
            "moisture": 80
        },
        "language": "en"
    }
    """
    try:
        data = request.get_json()
        sensor_data = data.get('sensor_data', {})
        language = data.get('language', 'en')

        recommendations = []

        # pH recommendations
        ph = sensor_data.get('ph', 7.0)
        if ph > 7.5:
            rec = SOIL_IMPROVEMENT_RULES['ph_high'].copy()
            rec['current_value'] = ph
            rec['target_range'] = "5.5-7.5"
            recommendations.append(rec)
        elif ph < 5.5:
            rec = SOIL_IMPROVEMENT_RULES['ph_low'].copy()
            rec['current_value'] = ph
            rec['target_range'] = "5.5-7.5"
            recommendations.append(rec)

        # Nitrogen recommendations
        nitrogen = sensor_data.get('nitrogen', 100)
        if nitrogen < 100:
            rec = SOIL_IMPROVEMENT_RULES['nitrogen_low'].copy()
            rec['current_value'] = nitrogen
            rec['target_range'] = "100-150 ppm"
            recommendations.append(rec)

        # Phosphorus recommendations
        phosphorus = sensor_data.get('phosphorus', 50)
        if phosphorus < 50:
            rec = SOIL_IMPROVEMENT_RULES['phosphorus_low'].copy()
            rec['current_value'] = phosphorus
            rec['target_range'] = "50-75 ppm"
            recommendations.append(rec)

        # Potassium recommendations
        potassium = sensor_data.get('potassium', 50)
        if potassium < 50:
            rec = SOIL_IMPROVEMENT_RULES['potassium_low'].copy()
            rec['current_value'] = potassium
            rec['target_range'] = "50-100 ppm"
            recommendations.append(rec)

        # Moisture recommendations
        moisture = sensor_data.get('moisture', 65)
        if moisture > 75:
            rec = SOIL_IMPROVEMENT_RULES['moisture_high'].copy()
            rec['current_value'] = f"{moisture}%"
            rec['target_range'] = "60-70%"
            recommendations.append(rec)
        elif moisture < 55:
            rec = SOIL_IMPROVEMENT_RULES['moisture_low'].copy()
            rec['current_value'] = f"{moisture}%"
            rec['target_range'] = "60-70%"
            recommendations.append(rec)

        # Sort by priority
        priority_order = {'high': 0, 'medium': 1, 'low': 2}
        recommendations.sort(key=lambda x: priority_order.get(x['priority'], 3))

        return jsonify({
            'status': 'success',
            'count': len(recommendations),
            'recommendations': recommendations
        }), 200

    except Exception as e:
        logger.error(f"Error generating soil improvements: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to generate recommendations'
        }), 500


@recommendations_bp.route('/disease-treatment', methods=['POST'])
def get_disease_treatment():
    """
    Get treatment recommendations for detected disease
    Request body: {
        "disease_name": "anthracnose",
        "severity": "high",
        "language": "en"
    }
    """
    try:
        data = request.get_json()
        disease_name = data.get('disease_name', '').lower()
        severity = data.get('severity', 'low')
        language = data.get('language', 'en')

        # Find disease in rules
        disease_key = disease_name.replace(' ', '_')
        disease_info = DISEASE_TREATMENT_RULES.get(disease_key)

        if not disease_info:
            return jsonify({
                'status': 'error',
                'message': f'Treatment information not available for {disease_name}'
            }), 404

        # Get severity-specific treatment
        severity_key = f"severity_{severity}"
        treatment = disease_info.get(severity_key, disease_info.get('severity_low'))

        response = {
            'disease': disease_info.get(f'disease_{language}', disease_info['disease']),
            'severity': severity,
            'treatment': treatment['treatment'],
            'chemical_option': treatment['chemical'],
            'organic_option': treatment['organic'],
            'frequency': treatment['frequency'],
            'prevention': disease_info['prevention'],
            'estimated_cost': disease_info['cost_estimate']
        }

        return jsonify({
            'status': 'success',
            'recommendation': response
        }), 200

    except Exception as e:
        logger.error(f"Error generating treatment recommendation: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to generate treatment recommendation'
        }), 500


@recommendations_bp.route('/fertilizer-schedule', methods=['POST'])
def get_fertilizer_schedule():
    """
    Generate fertilizer application schedule for crop lifecycle
    Request body: {
        "planting_date": "2024-01-15",
        "crop_type": "chilli",
        "field_area": 1.5
    }
    """
    try:
        data = request.get_json()
        crop_type = data.get('crop_type', 'chilli')
        field_area = data.get('field_area', 1.0)

        # Chilli fertilizer schedule (standard recommendations)
        schedule = [
            {
                "stage": "At Sowing",
                "stage_hi": "बुवाई के समय",
                "day": 0,
                "fertilizers": [
                    {"name": "Urea", "dosage_per_ha": 25, "unit": "kg"},
                    {"name": "Single Super Phosphate", "dosage_per_ha": 60, "unit": "kg"},
                    {"name": "Muriate of Potash", "dosage_per_ha": 20, "unit": "kg"}
                ],
                "application_method": "Mix with soil during final land preparation"
            },
            {
                "stage": "30 Days After Transplanting",
                "stage_hi": "रोपाई के 30 दिन बाद",
                "day": 30,
                "fertilizers": [
                    {"name": "Urea", "dosage_per_ha": 25, "unit": "kg"},
                    {"name": "Muriate of Potash", "dosage_per_ha": 20, "unit": "kg"}
                ],
                "application_method": "Side dressing near plant base"
            },
            {
                "stage": "60 Days After Transplanting (Flowering)",
                "stage_hi": "रोपाई के 60 दिन बाद (फूल आने पर)",
                "day": 60,
                "fertilizers": [
                    {"name": "19:19:19 NPK", "dosage_per_ha": 30, "unit": "kg"}
                ],
                "application_method": "Foliar spray or drip irrigation"
            }
        ]

        # Calculate for actual field area
        for stage in schedule:
            for fertilizer in stage['fertilizers']:
                fertilizer['total_quantity'] = round(fertilizer['dosage_per_ha'] * field_area, 2)

        return jsonify({
            'status': 'success',
            'crop_type': crop_type,
            'field_area': field_area,
            'schedule': schedule
        }), 200

    except Exception as e:
        logger.error(f"Error generating fertilizer schedule: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to generate fertilizer schedule'
        }), 500
