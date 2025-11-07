"""Recommendation endpoints for soil and fertilizer advice.

ChilliGuard - UPDATED Science-Backed Recommendations Database
Research-based data for Indian chilli crop cultivation
Based on ICAR studies, TNAU research, and field-validated data

DELIVERABLE: SOIL HEALTH RECOMMENDATIONS & FERTILIZER SCHEDULE
NOW INCLUDES: 12 PARAMETER-BASED RULES (9 original + 3 HIGH NPK)
Crop: Chilli (Capsicum annuum) - Indian conditions
Soil conditions: Well-drained loamy soil ideal
"""
from __future__ import annotations

import logging
from datetime import datetime, timedelta
from typing import Any, Dict, List, Tuple

from flask import Blueprint, Response, jsonify, request

# Initialize blueprint
bp = Blueprint(
    'recommendations',
    __name__,
    url_prefix='/recommendations')

# Configure logging
logger = logging.getLogger(__name__)

SOIL_IMPROVEMENT_RULES = {
    # ============================================================================
    # ORIGINAL 9 RULES: LOW VALUES
    # ============================================================================

    "ph_low": {
        "issue": "Soil pH too low (acidic)",
        "issue_hi": "मिट्टी का pH बहुत कम (अम्लीय)",
        "description": "Chilli grows optimally at pH 6.5-7.5. Acidic soil reduces nutrient availability, especially phosphorus and potassium.",
        "description_hi": "मिर्च का इष्टतम pH 6.5-7.5 है। अम्लीय मिट्टी फॉस्फोरस और पोटेशियम की उपलब्धता को कम करती है।",
        "current_thresholds": "pH < 5.5",
        "target_range": "6.5-7.5",
        "solution": "Apply agricultural lime (calcium carbonate)",
        "solution_hi": "कृषि चूना (कैल्शियम कार्बोनेट) लगाएं",
        "dosage": "2-3 tons/hectare lime",
        "dosage_calculation": "For pH 4.5-5.0: Apply 600 kg/acre; for pH 5.1-5.5: Apply 350 kg/acre",
        "timeline": "3 weeks before sowing",
        "application_method": "Incorporate into soil during final ploughing",
        "organic_alternative": "Wood ash (500 kg/ha) or bone meal with compost",
        "estimated_cost": "₹8,000-12,000/hectare",
        "priority": "high",
        "indicators": ["Stunted growth", "Poor root development", "Yellow leaves"]
    },

    "ph_high": {
        "issue": "Soil pH too high (alkaline)",
        "issue_hi": "मिट्टी का pH बहुत अधिक (क्षारीय)",
        "description": "Alkaline soil (pH > 7.5) reduces iron, zinc, and manganese availability - essential for chilli growth.",
        "description_hi": "क्षारीय मिट्टी (pH > 7.5) लोहा, जस्ता और मैंगनीज की उपलब्धता को कम करती है।",
        "current_thresholds": "pH > 7.5",
        "target_range": "6.5-7.5",
        "solution": "Apply agricultural sulfur to reduce pH",
        "solution_hi": "pH कम करने के लिए कृषि सल्फर लगाएं",
        "dosage": "500-800 kg/hectare sulfur",
        "dosage_calculation": "Apply in 2 equal splits over 4 weeks. Sulfur converts to sulfuric acid gradually.",
        "timeline": "4 weeks (apply in 2 splits)",
        "application_method": "Mix sulfur with soil during land preparation, water thoroughly",
        "organic_alternative": "Composted pine needles or peat moss (5 tons/ha) with acidifying fertilizers",
        "estimated_cost": "₹3,000-5,000/hectare",
        "priority": "high",
        "indicators": ["Iron chlorosis (yellowing between leaf veins)", "Stunted growth", "Poor fruit quality"]
    },

    "nitrogen_low": {
        "issue": "Nitrogen deficiency",
        "issue_hi": "नाइट्रोजन की कमी",
        "description": "Nitrogen promotes vegetative growth, leaf development, and protein synthesis. Critical for robust chilli plants.",
        "description_hi": "नाइट्रोजन पत्तियों के विकास और प्रोटीन संश्लेषण के लिए महत्वपूर्ण है।",
        "current_thresholds": "< 100 ppm soil N",
        "target_range": "100-150 ppm",
        "solution": "Apply urea or nitrogen-rich organic fertilizer",
        "solution_hi": "यूरिया या नाइट्रोजन युक्त जैविक खाद लगाएं",
        "dosage": "For hybrid: 120 kg N/ha total; For local: 90 kg N/ha",
        "dosage_calculation": "Urea: 26 kg at sowing + 26 kg at 30 DAT + 26 kg at 60 DAT + 26 kg at 90 DAT (hybrid)",
        "timeline": "Apply in 4 splits (sowing, 30, 60, 90 days after transplanting)",
        "application_method": "Basal dose mixed with soil. Top dressing via side dressing near plant base.",
        "organic_alternative": "Vermicompost (5 tons/ha) or Jeevamrutha (2000 liters/ha) application",
        "estimated_cost": "₹1,500-2,500/hectare",
        "priority": "medium",
        "indicators": ["Light green older leaves", "Stunted growth", "Short branches", "Reduced fruit size"]
    },

    "phosphorus_low": {
        "issue": "Phosphorus deficiency",
        "issue_hi": "फॉस्फोरस की कमी",
        "description": "Phosphorus essential for root development, flowering, and fruit formation. Supports energy transfer in plants.",
        "description_hi": "फॉस्फोरस जड़ विकास, फूल और फल निर्माण के लिए आवश्यक है।",
        "current_thresholds": "< 50 ppm available P",
        "target_range": "50-75 ppm",
        "solution": "Apply phosphate-based fertilizer",
        "solution_hi": "फॉस्फेट आधारित खाद लगाएं",
        "dosage": "For hybrid: 80 kg P₂O₅/ha; For local: 60 kg P₂O₅/ha",
        "dosage_calculation": "Single Super Phosphate (SSP): 375-500 kg/ha (contains ~16-20% P₂O₅)",
        "timeline": "Apply entirely at basal (before sowing/transplanting)",
        "application_method": "Mix with soil during final land preparation",
        "organic_alternative": "Bone meal (1000 kg/ha) or Rock phosphate (2000 kg/ha) - slow release",
        "estimated_cost": "₹2,000-3,500/hectare",
        "priority": "medium",
        "indicators": ["Stunted plants", "Purple/reddish leaf coloration", "Poor branching", "Delayed flowering"]
    },

    "potassium_low": {
        "issue": "Potassium deficiency",
        "issue_hi": "पोटेशियम की कमी",
        "description": "Potassium crucial for water movement, enzyme activation, and fruit quality. Increases pest resistance.",
        "description_hi": "पोटेशियम फल की गुणवत्ता और कीट प्रतिरोध के लिए महत्वपूर्ण है।",
        "current_thresholds": "< 150 ppm available K",
        "target_range": "150-200 ppm",
        "solution": "Apply potassium sulfate for quality improvement",
        "solution_hi": "गुणवत्ता में सुधार के लिए पोटेशियम सल्फेट लगाएं",
        "dosage": "For hybrid: 80 kg K₂O/ha; For local: 50 kg K₂O/ha",
        "dosage_calculation": "Muriate of Potash (MOP): 130-160 kg/ha (contains ~60% K₂O); Potassium Sulfate (SOP): 130-160 kg/ha (50% K₂O)",
        "timeline": "Apply in splits: 50% basal + 25% at 30 DAT + 25% at 60 DAT",
        "application_method": "Basal mixed with soil. Top dressing via drip or side application.",
        "organic_alternative": "Wood ash (500 kg/ha) or Kelp meal with compost",
        "estimated_cost": "₹1,800-3,000/hectare",
        "priority": "medium",
        "indicators": ["Marginal scorching (brown leaf edges)", "Reduced fruit size", "Poor fruit color development", "Crinkled leaves"]
    },

    "moisture_high": {
        "issue": "Excessive soil moisture (waterlogging)",
        "issue_hi": "अत्यधिक मिट्टी में नमी (जलभराव)",
        "description": "Chilli cannot tolerate waterlogging. Excess moisture causes root rot, fungal diseases, and poor growth.",
        "description_hi": "मिर्च जलभराव सहन नहीं कर सकती। अतिरिक्त नमी जड़ सड़न और कवक रोग का कारण बनती है।",
        "current_thresholds": "> 75% soil moisture",
        "target_range": "60-70% (optimal)",
        "solution": "Improve field drainage immediately",
        "solution_hi": "तुरंत खेत की जल निकासी में सुधार करें",
        "dosage": "Install drainage channels (30 cm deep, 1m apart) and raised beds (20 cm height)",
        "dosage_calculation": "1 hectare requires ~10-15 drainage channels depending on slope",
        "timeline": "1-2 weeks before transplanting",
        "application_method": "Create raised beds or furrows. Use drip irrigation instead of flood.",
        "organic_alternative": "Mulching with straw (5-7 cm) to improve water drainage and reduce standing water",
        "estimated_cost": "₹5,000-8,000/hectare (one-time investment)",
        "priority": "high",
        "indicators": ["Root rot", "Yellowing leaves", "Fungal diseases", "Poor growth", "Bad odor from soil"]
    },

    "moisture_low": {
        "issue": "Low soil moisture (drought stress)",
        "issue_hi": "कम मिट्टी में नमी (सूखा तनाव)",
        "description": "Chilli requires consistent moisture (60-70%). Water stress reduces flowering and causes fruit drop.",
        "description_hi": "मिर्च को सुसंगत नमी (60-70%) की आवश्यकता है। पानी की कमी फूल और फल गिराव का कारण बनती है।",
        "current_thresholds": "< 55% soil moisture",
        "target_range": "60-70%",
        "solution": "Install drip irrigation system with mulching",
        "solution_hi": "ड्रिप सिंचाई प्रणाली लगाएं और गीली घास से ढकें",
        "dosage": "Drip irrigation: 5-6 days interval in summer, 9-10 days in winter. Mulch layer: 5-7 cm",
        "dosage_calculation": "Drip requirement: 2000-2500 mm annually depending on rainfall and season",
        "timeline": "Implement immediately after transplanting",
        "application_method": "Drip lines at plant base. Apply mulch (straw, dry leaves) around plants.",
        "organic_alternative": "Organic mulch (5 cm straw) + compost layer increases water retention by 15-20%",
        "estimated_cost": "₹3,000-6,000/hectare",
        "priority": "high",
        "indicators": ["Wilting leaves", "Flower/fruit drop", "Stunted growth", "Hard, cracked soil"]
    },

    "temperature_stress": {
        "issue": "Temperature outside optimal range",
        "issue_hi": "तापमान इष्टतम सीमा के बाहर",
        "description": "Chilli growth optimal at 20-25°C. Temperatures < 18°C or > 30°C reduce flowering and fruit set.",
        "description_hi": "मिर्च का विकास 20-25°C पर इष्टतम है। कम तापमान फूल निर्माण को कम करता है।",
        "current_thresholds": "< 18°C or > 30°C during critical stages",
        "target_range": "20-25°C (growth), 25-30°C (fruiting)",
        "solution": "Adjust sowing/transplanting time to match season",
        "solution_hi": "बुवाई का समय मौसम के अनुसार समायोजित करें",
        "dosage": "N/A - seasonal management",
        "timeline": "Plan cultivation calendar: Kharif (Jul-Nov) or Rabi (Oct-Mar) in India",
        "application_method": "Mulching provides cooling in summer, shade nets for extreme heat",
        "organic_alternative": "Shade nets (30-40% shade) in summer protect from heat stress",
        "estimated_cost": "₹2,000-4,000/hectare (shade nets)",
        "priority": "medium",
        "indicators": ["Reduced flowering at >30°C", "Fruit drop", "Poor fruit color development"]
    },

    "humidity_stress": {
        "issue": "High humidity favoring fungal diseases",
        "issue_hi": "उच्च आर्द्रता कवक रोग में सहायक",
        "description": "High humidity (> 80%) combined with warm weather promotes bacterial and fungal diseases.",
        "description_hi": "उच्च आर्द्रता और गर्म मौसम कवक रोग को बढ़ावा देते हैं।",
        "current_thresholds": "> 80% relative humidity",
        "target_range": "60-80% RH",
        "solution": "Improve air circulation through proper spacing and pruning",
        "solution_hi": "उचित दूरी और छंटाई से हवा के प्रवाह में सुधार करें",
        "dosage": "Plant spacing: 60 cm × 45 cm (for intercultivation)",
        "timeline": "Maintain throughout growing season",
        "application_method": "Pruning lower branches (15 cm), removing dense foliage, drip irrigation (not overhead)",
        "organic_alternative": "Neem oil spray (5 ml/L water) - preventive spraying every 7-10 days during high humidity",
        "estimated_cost": "₹500-1,000/hectare (spray materials)",
        "priority": "medium",
        "indicators": ["Powdery mildew", "Cercospora leaf spot", "Bacterial spot", "Fungal infections"]
    },

    # ============================================================================
    # NEW 3 RULES: HIGH VALUES (EXCESS NPK) - RESEARCH-BACKED
    # ============================================================================

    "nitrogen_high": {
        "issue": "Nitrogen excess (over-fertilization)",
        "issue_hi": "नाइट्रोजन की अधिकता (अत्यधिक खाद)",
        "description": "Excess nitrogen (>180 ppm) causes excessive vegetative growth with poor flowering and fruiting. Increases pest susceptibility and disease incidence. Reduces nitrogen use efficiency (NUE) and causes environmental pollution (nitrate leaching).",
        "description_hi": "अत्यधिक नाइट्रोजन (>180 ppm) के कारण अधिक पत्तियां बनती हैं लेकिन फूल और फल कम आते हैं। कीटों और रोगों का खतरा बढ़ता है।",
        "current_thresholds": "> 180 ppm soil N",
        "target_range": "100-150 ppm",
        "solution": "Stop nitrogen application immediately; increase potassium to balance growth",
        "solution_hi": "नाइट्रोजन का प्रयोग बंद करें; पोटेशियम बढ़ाएं",
        "dosage": "N/A - cease application. Apply 20-30 kg K₂O/ha to promote flowering",
        "dosage_calculation": "If soil N > 180 ppm: Skip 1-2 scheduled nitrogen applications. Increase K₂O to flower buds.",
        "timeline": "Immediate cessation until N drops to 150 ppm range (verified by soil test)",
        "application_method": "Apply only K-based fertilizers or potassium sulfate (SOP) for next 2-3 weeks",
        "organic_alternative": "Reduce organic matter application; flush with higher K ratio compost if available",
        "estimated_cost": "₹1,000-1,500/hectare (potassium fertilizer for balance)",
        "priority": "high",
        "indicators": [
            "Excessive vegetative growth ('lush green' plants)",
            "Poor flower formation - very few flowers",
            "Flower/fruit drop (high abscission)",
            "Small fruit size despite large canopy",
            "Delayed maturity",
            "Dark green leaves with thick branches",
            "High incidence of pests (whiteflies, thrips)",
            "Increased disease pressure",
            "Poor fruit color development"
        ],
        # "research_basis": "ICAR field studies show excessive N (>180 ppm) reduces fruit set by 30-40%. Bio-char + optimal N (375 kg/ha) study achieved 42.35% higher yield than excess N alone.",
        # "yield_impact": "Reduces yield by 20-30% despite lush growth"
    },

    "phosphorus_high": {
        "issue": "Phosphorus excess (over-application)",
        "issue_hi": "फॉस्फोरस की अधिकता (अत्यधिक लगाव)",
        "description": "Excess phosphorus (>150 ppm) induces calcium deficiency leading to Blossom End Rot (BER) in fruits. High P reduces Zn, Fe, Cu absorption. Creates nutrient imbalance affecting root development and disease resistance.",
        "description_hi": "अत्यधिक फॉस्फोरस (>150 ppm) कैल्शियम की कमी का कारण बनता है। फलों के सिरे पर सड़न आती है (BER)।",
        "current_thresholds": "> 150 ppm available P",
        "target_range": "50-75 ppm",
        "solution": "Cease phosphorus application; apply calcium and zinc to correct deficiencies",
        "solution_hi": "फॉस्फोरस का प्रयोग बंद करें; कैल्शियम और जस्ता लगाएं",
        "dosage": "N/A - cease SSP/DAP. Apply Gypsum 500 kg/ha + Zinc Sulfate 5 kg/ha",
        "dosage_calculation": "If P > 150 ppm: Skip basal P application. For BER correction: Gypsum 500-750 kg/ha (calcium) + foliar Zn spray",
        "timeline": "Immediate cessation. Apply gypsum at next irrigation or once per week",
        "application_method": "Band application of gypsum near plant base; foliar Zn spray (0.5g/L) every 10 days",
        "organic_alternative": "Bone meal ceases to be used. Apply wood ash (500 kg/ha) as mineral source",
        "estimated_cost": "₹2,000-3,000/hectare (gypsum + zinc corrective)",
        "priority": "high",
        "indicators": [
            "Blossom End Rot (BER) - sunken necrotic patches at fruit tip",
            "Yellow-green interveinal chlorosis (Zn deficiency)",
            "Iron chlorosis - yellowing between veins (induced Fe deficiency)",
            "Poor fruit quality",
            "Reduced fruit set",
            "Distorted leaf shape",
            "Weak root system",
            "Poor disease resistance"
        ],
        # "research_basis": "High P reduces micronutrient availability. TNAU research shows optimal P:Zn ratio critical for BER prevention. High P (>200 ppm) reduces Zn absorption by 40-50%.",
        # "yield_impact": "50-70% fruit loss due to BER if not corrected"
    },

    "potassium_high": {
        "issue": "Potassium excess (over-application)",
        "issue_hi": "पोटेशियम की अधिकता (अत्यधिक लगाव)",
        "description": "Excess potassium (>300 ppm) causes salt stress and nutrient imbalance. High K reduces magnesium and calcium absorption. Increases soil EC (Electrical Conductivity) causing osmotic stress and poor water uptake.",
        "description_hi": "अत्यधिक पोटेशियम (>300 ppm) से नमक का तनाव होता है। मैग्नीशियम और कैल्शियम की कमी हो जाती है।",
        "current_thresholds": "> 300 ppm available K",
        "target_range": "150-200 ppm",
        "solution": "Cease potassium application; increase magnesium and calcium inputs",
        "solution_hi": "पोटेशियम का प्रयोग बंद करें; मैग्नीशियम और कैल्शियम बढ़ाएं",
        "dosage": "N/A - cease MOP/SOP application. Apply Dolomite (CaMg CO₃) 1-1.5 tons/ha",
        "dosage_calculation": "If K > 300 ppm: Skip K applications for 4-6 weeks. Apply Dolomite 1 ton/ha + Mg sulfate 25 kg/ha in split doses",
        "timeline": "Immediate cessation. Apply dolomite and magnesium over 2-3 applications",
        "application_method": "Incorporate dolomite into soil; MgSO₄ as side dressing near plants",
        "organic_alternative": "Use wood ash cautiously (low ash sources); apply compost with natural Mg content",
        "estimated_cost": "₹1,500-2,500/hectare (dolomite + magnesium corrective)",
        "priority": "medium",
        "indicators": [
            "Wilting despite adequate moisture (osmotic stress)",
            "Marginal leaf scorch (initially from high K, later Mg-deficiency)",
            "Interveinal yellowing of older leaves (Mg deficiency)",
            "Yellowing between veins in new leaves (Ca deficiency)",
            "Poor flower quality and reduced fruit set",
            "Soil EC > 2 dS/m",
            "Fruit quality issues - small fruit, poor color",
            "Stunted root growth"
        ],
        # "research_basis": "Indian studies show K:Ca:Mg ratio critical for chilli. Excess K:Mg ratio (>3:1) reduces Mg uptake significantly. Biochar + balanced nutrients maintain optimal ratios.",
        # "yield_impact": "Reduces yield by 15-25% due to osmotic and nutrient antagonism"
    }
}

# VALIDATION CONSTANTS (Research-backed for Indian chilli cultivation)
VALID_SENSORS = {
    'ph': {'min': 4.0, 'max': 9.0, 'optimal': (6.5, 7.5)},
    'nitrogen': {'min': 0, 'max': 500, 'optimal': (100, 150), 'unit': 'ppm'},
    'phosphorus': {'min': 0, 'max': 300, 'optimal': (50, 75), 'unit': 'ppm'},
    'potassium': {'min': 0, 'max': 500, 'optimal': (150, 200), 'unit': 'ppm'},  # CORRECTED from (50, 100)
    'moisture': {'min': 0, 'max': 100, 'optimal': (60, 70), 'unit': '%'},
    'temperature': {'min': 5, 'max': 50, 'optimal': (20, 25), 'unit': '°C'},
    'humidity': {'min': 0, 'max': 100, 'optimal': (60, 80), 'unit': '%'}
}

# THRESHOLD CONSTANTS (Research-backed from ICAR/TNAU studies)
NPK_THRESHOLDS = {
    'nitrogen': {
        'low': 100,          # Below this = deficiency
        'optimal_min': 100,
        'optimal_max': 150,
        'high': 180          # Above this = excess (NEW)
    },
    'phosphorus': {
        'low': 50,           # Below this = deficiency
        'optimal_min': 50,
        'optimal_max': 75,
        'high': 150          # Above this = excess (NEW)
    },
    'potassium': {
        'low': 150,          # CORRECTED from 50 (was WRONG)
        'optimal_min': 150,  # CORRECTED from 100
        'optimal_max': 200,  # CORRECTED from (not present)
        'high': 300          # Above this = excess (NEW)
    }
}

MOISTURE_THRESHOLDS = {
    'low': 55,             # Below this = drought stress
    'optimal_min': 60,
    'optimal_max': 70,
    'high': 75             # Above this = waterlogging
}

TEMPERATURE_THRESHOLDS = {
    'low': 18,
    'optimal_min': 20,
    'optimal_max': 25,
    'high': 30
}

HUMIDITY_THRESHOLDS = {
    'low': 40,
    'optimal_min': 60,
    'optimal_max': 80,
    'high': 85             # >85% favors fungal diseases
}


@bp.route('/soil-improvements', methods=['POST'])
def get_soil_improvements() -> Tuple[Response, int]:
    """
    Generate soil improvement recommendations based on sensor data.

    RESEARCH-BACKED for Indian chilli (Capsicum annuum) cultivation
    Based on: ICAR recommendations, TNAU studies, field-validated data

    Request body: {
        "field_id": "field_123",
        "sensor_data": {
            "ph": 8.2,
            "nitrogen": 80,
            "phosphorus": 40,
            "potassium": 35,
            "moisture": 80,
            "temperature": 28.5,        # OPTIONAL (in °C)
            "humidity": 75.5            # OPTIONAL (in %)
        },
        "language": "en"  # or "hi" for Hindi
    }

    Response: {
        "status": "success",
        "count": 3,
        "recommendations": [
            {
                "issue": "Soil pH too high...",
                "current_value": 8.2,
                "target_range": "6.5-7.5",
                "solution": "...",
                "dosage": "...",
                "timeline": "...",
                "priority": "high",
                ...
            }
        ]
    }
    """

    try:
        # ====================================================================
        # 1. INPUT VALIDATION & PARSING
        # ====================================================================
        data: Dict[str, Any] = request.get_json(silent=True) or {}

        if not data:
            logger.warning("Empty request body received")
            return jsonify({
                'status': 'error',
                'message': 'Request body cannot be empty',
                'code': 'EMPTY_REQUEST'
            }), 400

        sensor_data: Dict[str, Any] = data.get('sensor_data', {})
        field_id: str = data.get('field_id', 'unknown')
        language: str = data.get('language', 'en')

        if not sensor_data:
            logger.warning(f"[{field_id}] No sensor_data provided")
            return jsonify({
                'status': 'error',
                'message': 'sensor_data is required',
                'code': 'MISSING_SENSOR_DATA'
            }), 400

        # Validate language
        if language not in ['en', 'hi']:
            language = 'en'
            logger.warning(f"Invalid language '{language}', defaulting to 'en'")

        recommendations: List[Dict[str, Any]] = []
        validation_errors: List[str] = []

        logger.info(f"[{field_id}] Processing soil improvement request - Language: {language}")

        # ====================================================================
        # 2. VALIDATE & SANITIZE SENSOR VALUES
        # ====================================================================

        validated_data = {}
        for sensor_name, thresholds in VALID_SENSORS.items():
            value = sensor_data.get(sensor_name)

            if value is None:
                # Optional sensors (temperature, humidity) can be missing
                if sensor_name not in ['temperature', 'humidity']:
                    validation_errors.append(f"Missing required sensor: {sensor_name}")
                continue

            # Type validation
            try:
                value = float(value)
            except (ValueError, TypeError):
                validation_errors.append(f"Invalid {sensor_name} value: {value} (must be numeric)")
                continue

            # Range validation
            if value < thresholds['min'] or value > thresholds['max']:
                validation_errors.append(
                    f"{sensor_name} value {value} outside valid range "
                    f"({thresholds['min']}-{thresholds['max']} {thresholds.get('unit', '')})"
                )
                continue

            validated_data[sensor_name] = value

        # Log validation errors but don't fail - use defaults for missing values
        if validation_errors:
            logger.warning(f"[{field_id}] Validation errors: {'; '.join(validation_errors)}")

        # ====================================================================
        # 3. pH RECOMMENDATIONS (RESEARCH-BACKED FOR CHILLI)
        # ====================================================================
        # Optimal pH for chilli: 6.5-7.5 (ICAR recommendation)

        ph = validated_data.get('ph', 7.0)

        if ph > 7.5:
            # ALKALINE SOIL
            rec = SOIL_IMPROVEMENT_RULES['ph_high'].copy()
            rec['current_value'] = ph
            rec['deviation'] = round(ph - 7.5, 2)
            rec['severity_percentage'] = min(100, round((ph - 7.5) * 10, 0))  # More alkaline = higher %
            recommendations.append(rec)
            logger.info(f"[{field_id}] pH HIGH detected: {ph} (deviation: +{ph-7.5:.2f})")

        elif ph < 5.5:
            # ACIDIC SOIL
            rec = SOIL_IMPROVEMENT_RULES['ph_low'].copy()
            rec['current_value'] = ph
            rec['deviation'] = round(5.5 - ph, 2)
            rec['severity_percentage'] = min(100, round((5.5 - ph) * 10, 0))
            recommendations.append(rec)
            logger.info(f"[{field_id}] pH LOW detected: {ph} (deviation: -{5.5-ph:.2f})")

        # ====================================================================
        # 4. NITROGEN RECOMMENDATIONS (CORRECTED LOGIC)
        # ====================================================================
        # Optimal for chilli: 100-150 ppm (ICAR)
        # Low: <100 ppm | High: >180 ppm (NEW - from research)

        nitrogen = validated_data.get('nitrogen', 125)  # Default to mid-range

        if nitrogen < NPK_THRESHOLDS['nitrogen']['low']:
            # NITROGEN DEFICIENCY
            rec = SOIL_IMPROVEMENT_RULES['nitrogen_low'].copy()
            rec['current_value'] = nitrogen
            rec['deficit'] = round(NPK_THRESHOLDS['nitrogen']['optimal_min'] - nitrogen, 2)
            rec['deficit_percentage'] = round(
                ((NPK_THRESHOLDS['nitrogen']['optimal_min'] - nitrogen) /
                 NPK_THRESHOLDS['nitrogen']['optimal_min']) * 100, 1
            )
            recommendations.append(rec)
            logger.info(f"[{field_id}] NITROGEN LOW: {nitrogen} ppm (deficit: {rec['deficit']} ppm)")

        elif nitrogen > NPK_THRESHOLDS['nitrogen']['high']:
            # NITROGEN EXCESS (NEW - from updated database)
            rec = SOIL_IMPROVEMENT_RULES['nitrogen_high'].copy()
            rec['current_value'] = nitrogen
            rec['excess'] = round(nitrogen - NPK_THRESHOLDS['nitrogen']['high'], 2)
            rec['excess_percentage'] = round(
                ((nitrogen - NPK_THRESHOLDS['nitrogen']['high']) / nitrogen) * 100, 1
            )
            recommendations.append(rec)
            logger.warning(f"[{field_id}] NITROGEN HIGH (excess): {nitrogen} ppm (excess: {rec['excess']} ppm)")

        # ====================================================================
        # 5. PHOSPHORUS RECOMMENDATIONS (CORRECTED LOGIC)
        # ====================================================================
        # Optimal for chilli: 50-75 ppm (ICAR)
        # Low: <50 ppm | High: >150 ppm (NEW - from research)

        phosphorus = validated_data.get('phosphorus', 62)  # Default to mid-range

        if phosphorus < NPK_THRESHOLDS['phosphorus']['low']:
            # PHOSPHORUS DEFICIENCY
            rec = SOIL_IMPROVEMENT_RULES['phosphorus_low'].copy()
            rec['current_value'] = phosphorus
            rec['deficit'] = round(NPK_THRESHOLDS['phosphorus']['optimal_min'] - phosphorus, 2)
            rec['deficit_percentage'] = round(
                ((NPK_THRESHOLDS['phosphorus']['optimal_min'] - phosphorus) /
                 NPK_THRESHOLDS['phosphorus']['optimal_min']) * 100, 1
            )
            recommendations.append(rec)
            logger.info(f"[{field_id}] PHOSPHORUS LOW: {phosphorus} ppm (deficit: {rec['deficit']} ppm)")

        elif phosphorus > NPK_THRESHOLDS['phosphorus']['high']:
            # PHOSPHORUS EXCESS (NEW - from updated database)
            # Risk of Blossom End Rot (BER) and Zn deficiency
            rec = SOIL_IMPROVEMENT_RULES['phosphorus_high'].copy()
            rec['current_value'] = phosphorus
            rec['excess'] = round(phosphorus - NPK_THRESHOLDS['phosphorus']['high'], 2)
            rec['excess_percentage'] = round(
                ((phosphorus - NPK_THRESHOLDS['phosphorus']['high']) / phosphorus) * 100, 1
            )
            rec['critical_warning'] = "High P causes Blossom End Rot (BER) - 50-70% fruit loss possible"
            recommendations.append(rec)
            logger.error(f"[{field_id}] PHOSPHORUS HIGH (CRITICAL): {phosphorus} ppm (excess: {rec['excess']} ppm)")

        # ====================================================================
        # 6. POTASSIUM RECOMMENDATIONS (CORRECTED LOGIC)
        # ====================================================================
        # Optimal for chilli: 150-200 ppm (ICAR) - CORRECTED from (50-100)
        # Low: <150 ppm (CORRECTED from <50) | High: >300 ppm (NEW)

        potassium = validated_data.get('potassium', 175)  # Default to mid-range

        if potassium < NPK_THRESHOLDS['potassium']['low']:
            # POTASSIUM DEFICIENCY
            rec = SOIL_IMPROVEMENT_RULES['potassium_low'].copy()
            rec['current_value'] = potassium
            rec['target_range'] = "150-200 ppm"  # CORRECTED from "50-100 ppm"
            rec['deficit'] = round(NPK_THRESHOLDS['potassium']['optimal_min'] - potassium, 2)
            rec['deficit_percentage'] = round(
                ((NPK_THRESHOLDS['potassium']['optimal_min'] - potassium) /
                 NPK_THRESHOLDS['potassium']['optimal_min']) * 100, 1
            )
            recommendations.append(rec)
            logger.info(f"[{field_id}] POTASSIUM LOW: {potassium} ppm (deficit: {rec['deficit']} ppm)")

        elif potassium > NPK_THRESHOLDS['potassium']['high']:
            # POTASSIUM EXCESS (NEW - from updated database)
            # Risk of salt stress and Mg/Ca antagonism
            rec = SOIL_IMPROVEMENT_RULES['potassium_high'].copy()
            rec['current_value'] = potassium
            rec['excess'] = round(potassium - NPK_THRESHOLDS['potassium']['high'], 2)
            rec['excess_percentage'] = round(
                ((potassium - NPK_THRESHOLDS['potassium']['high']) / potassium) * 100, 1
            )
            rec['critical_warning'] = "High K causes salt stress and Mg/Ca deficiency - 15-25% yield loss"
            recommendations.append(rec)
            logger.error(f"[{field_id}] POTASSIUM HIGH: {potassium} ppm (excess: {rec['excess']} ppm)")

        # ====================================================================
        # 7. MOISTURE RECOMMENDATIONS
        # ====================================================================
        # Optimal for chilli: 60-70% (ICAR)
        # Low (drought): <55% | High (waterlogging): >75%

        moisture = validated_data.get('moisture', 65)

        if moisture > MOISTURE_THRESHOLDS['high']:
            # WATERLOGGING / EXCESSIVE MOISTURE
            rec = SOIL_IMPROVEMENT_RULES['moisture_high'].copy()
            rec['current_value'] = f"{moisture}%"
            rec['excess_moisture'] = round(moisture - MOISTURE_THRESHOLDS['high'], 1)
            rec['risk_factors'] = [
                "Root rot from anaerobic conditions",
                "Fungal disease proliferation",
                f"Soil waterlogging at {moisture}% moisture"
            ]
            recommendations.append(rec)
            logger.warning(f"[{field_id}] MOISTURE HIGH (waterlogging risk): {moisture}%")

        elif moisture < MOISTURE_THRESHOLDS['low']:
            # DROUGHT / LOW MOISTURE
            rec = SOIL_IMPROVEMENT_RULES['moisture_low'].copy()
            rec['current_value'] = f"{moisture}%"
            rec['moisture_deficit'] = round(MOISTURE_THRESHOLDS['optimal_min'] - moisture, 1)
            rec['risk_factors'] = [
                "Flower/fruit drop from water stress",
                "Stunted plant growth",
                f"Soil drought stress at {moisture}% moisture"
            ]
            recommendations.append(rec)
            logger.warning(f"[{field_id}] MOISTURE LOW (drought risk): {moisture}%")

        # ====================================================================
        # 8. TEMPERATURE RECOMMENDATIONS (NEW - from updated database)
        # ====================================================================
        # Optimal for chilli: 20-25°C (ICAR)

        if 'temperature' in validated_data:
            temperature = validated_data['temperature']

            if temperature < TEMPERATURE_THRESHOLDS['low'] or temperature > TEMPERATURE_THRESHOLDS['high']:
                rec = SOIL_IMPROVEMENT_RULES['temperature_stress'].copy()
                rec['current_value'] = f"{temperature}°C"
                rec['deviation'] = (
                    f"High by {temperature - TEMPERATURE_THRESHOLDS['high']}°C"
                    if temperature > TEMPERATURE_THRESHOLDS['high']
                    else f"Low by {TEMPERATURE_THRESHOLDS['low'] - temperature}°C"
                )
                recommendations.append(rec)
                logger.info(f"[{field_id}] TEMPERATURE stress: {temperature}°C")

        # ====================================================================
        # 9. HUMIDITY RECOMMENDATIONS (NEW - from updated database)
        # ====================================================================
        # Optimal for chilli: 60-80% RH (ICAR)
        # High humidity (>85%) promotes fungal diseases

        if 'humidity' in validated_data:
            humidity = validated_data['humidity']

            if humidity > HUMIDITY_THRESHOLDS['high']:
                rec = SOIL_IMPROVEMENT_RULES['humidity_stress'].copy()
                rec['current_value'] = f"{humidity}%"
                rec['risk_factors'] = [
                    "High fungal disease pressure",
                    "Bacterial leaf spot proliferation",
                    "Cercospora and powdery mildew risk"
                ]
                rec['prevention_measures'] = [
                    "Improve spacing (60×45 cm minimum)",
                    "Ensure drip irrigation (not overhead)",
                    "Prune lower leaves for air circulation",
                    "Apply preventive fungicide sprays"
                ]
                recommendations.append(rec)
                logger.warning(f"[{field_id}] HUMIDITY HIGH (disease risk): {humidity}%")

        # ====================================================================
        # 10. PRIORITY SORTING & SEVERITY ASSIGNMENT
        # ====================================================================

        # Sort by priority (high > medium > low)
        priority_order = {'high': 0, 'medium': 1, 'low': 2}
        recommendations.sort(
            key=lambda x: priority_order.get(x.get('priority', 'medium'), 3)
        )

        # Add action urgency based on severity
        for idx, rec in enumerate(recommendations):
            priority = rec.get('priority', 'medium')

            if priority == 'high':
                rec['action_urgency'] = 'IMMEDIATE - Apply within 7 days'
                rec['action_urgency_hi'] = 'तुरंत - 7 दिन के भीतर लागू करें'
            elif priority == 'medium':
                rec['action_urgency'] = 'SOON - Apply within 14 days'
                rec['action_urgency_hi'] = 'जल्द - 14 दिन के भीतर लागू करें'
            else:
                rec['action_urgency'] = 'PLANNED - Apply within 30 days'
                rec['action_urgency_hi'] = 'योजनाबद्ध - 30 दिन के भीतर लागू करें'

            rec['recommendation_order'] = idx + 1

        # ====================================================================
        # 11. RESPONSE GENERATION
        # ====================================================================

        logger.info(f"[{field_id}] Generated {len(recommendations)} recommendations")

        return jsonify({
            'status': 'success',
            'field_id': field_id,
            'timestamp': str(datetime.now()),
            'count': len(recommendations),
            'language': language,
            'recommendations': recommendations,
            'summary': {
                'optimal_parameters': sum(1 for rec in recommendations if rec.get('priority') == 'low'),
                'attention_needed': sum(1 for rec in recommendations if rec.get('priority') == 'medium'),
                'critical_issues': sum(1 for rec in recommendations if rec.get('priority') == 'high')
            }
        }), 200

    # =========================================================================
    # ERROR HANDLING
    # =========================================================================

    except ValueError as ve:
        logger.error(f"[{field_id}] Value error: {str(ve)}")
        return jsonify({
            'status': 'error',
            'message': f'Invalid sensor data format: {str(ve)}',
            'code': 'VALUE_ERROR'
        }), 400

    except KeyError as ke:
        logger.error(f"[{field_id}] Missing required field: {str(ke)}")
        return jsonify({
            'status': 'error',
            'message': f'Missing required field: {str(ke)}',
            'code': 'MISSING_FIELD'
        }), 400

    except Exception as e:
        logger.exception(f"[{field_id}] Unexpected error in soil improvements: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Internal server error - Failed to generate recommendations',
            'code': 'INTERNAL_ERROR',
            'error_id': str(hash(str(e)))  # For debugging
        }), 500


# ============================================================================
# HELPER ENDPOINTS
# ============================================================================

@bp.route('/soil-parameters-info', methods=['GET'])
def get_parameter_info() -> Tuple[Response, int]:
    """
    Get information about valid sensor parameters and their ranges.
    Useful for frontend validation.
    """
    try:
        return jsonify({
            'status': 'success',
            'parameters': VALID_SENSORS,
            'thresholds': {
                'npk': NPK_THRESHOLDS,
                'moisture': MOISTURE_THRESHOLDS,
                'temperature': TEMPERATURE_THRESHOLDS,
                'humidity': HUMIDITY_THRESHOLDS
            }
        }), 200
    except Exception as e:  # pylint: disable=broad-except
        logger.error(f"Error fetching parameter info: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to fetch parameter information'
        }), 500


# ============================================================================
# FERTILIZER SCHEDULE ENDPOINT
# ============================================================================

@bp.route('/fertilizer-schedule', methods=['POST'])
def get_fertilizer_schedule() -> Tuple[Response, int]:
    """
    Generate fertilizer application schedule for crop lifecycle

    Request body: {
        "planting_date": "2025-01-15",
        "field_area": 1.5,
        "crop_type": "chilli",
        "variety_type": "hybrid"
    }

    Response: {
        "status": "success",
        "crop_type": "chilli",
        "field_area": 1.5,
        "schedule": [...],
        "summary": {...}
    }
    """
    try:
        data: Dict[str, Any] = request.get_json(silent=True) or {}

        if not data:
            logger.warning("Empty request body received for fertilizer schedule")
            return jsonify({
                'status': 'error',
                'message': 'Request body cannot be empty',
                'code': 'EMPTY_REQUEST'
            }), 400

        planting_date = data.get('planting_date')
        field_area = data.get('field_area', 1.0)
        crop_type = data.get('crop_type', 'chilli')
        variety_type = data.get('variety_type', 'hybrid')

        # Validation
        if not planting_date:
            return jsonify({
                'status': 'error',
                'message': 'planting_date is required (format: YYYY-MM-DD)',
                'code': 'MISSING_PLANTING_DATE'
            }), 400

        if field_area <= 0:
            return jsonify({
                'status': 'error',
                'message': 'field_area must be greater than 0 hectares',
                'code': 'INVALID_FIELD_AREA'
            }), 400

        if field_area > 100:
            return jsonify({
                'status': 'error',
                'message': 'field_area exceeds 100 hectares - please verify input',
                'code': 'UNREALISTIC_FIELD_AREA'
            }), 400

        if variety_type not in ['hybrid', 'local']:
            logger.warning(f"Invalid variety_type '{variety_type}', defaulting to 'hybrid'")
            variety_type = 'hybrid'

        logger.info(f"Generating fertilizer schedule: {variety_type} {crop_type}, {field_area} ha, planting: {planting_date}")

        # Generate schedule
        result = _generate_fertilizer_schedule_internal(
            planting_date,
            field_area,
            crop_type,
            variety_type
        )

        return jsonify({
            'status': 'success',
            'crop_type': crop_type,
            'field_area': field_area,
            'variety_type': variety_type,
            'schedule': result['schedule'],
            'summary': result['summary']
        }), 200

    except ValueError as ve:
        logger.error(f"Value error in fertilizer schedule: {str(ve)}")
        return jsonify({
            'status': 'error',
            'message': str(ve),
            'code': 'VALUE_ERROR'
        }), 400
    except Exception as e:  # pylint: disable=broad-except
        logger.exception(f"Error generating fertilizer schedule: {str(e)}")
        return jsonify({
            'status': 'error',
            'message': 'Failed to generate fertilizer schedule',
            'code': 'INTERNAL_ERROR'
        }), 500


def _generate_fertilizer_schedule_internal(
        planting_date: str,
        field_area_hectares: float,
        crop_type: str = "chilli",
        variety_type: str = "hybrid") -> Dict[str, Any]:
    """
    Generate dynamic fertilizer application schedule based on ACTUAL field area

    IMPORTANT: This function now properly calculates ALL quantities based on input field_area_hectares

    Parameters:
    -----------
    planting_date : str
        Format: "YYYY-MM-DD" (e.g., "2025-01-15")
    field_area_hectares : float
        Actual field area in hectares (e.g., 1.5, 2.0, 0.5, etc.)
        NOT hardcoded - used for ALL calculations
    crop_type : str
        Default: "chilli" (kept for future crop types)
    variety_type : str
        "hybrid" or "local" - determines NPK ratios

    Returns:
    --------
    dict : Complete fertilizer schedule with:
        - Stage information (timing, dates)
        - Per-hectare and per-field-area calculations
        - Cost estimates for actual area
        - Detailed application instructions

    Research Basis:
    ---------------
    - ICAR recommended NPK for chilli: Hybrid 120:80:80, Local 90:60:50 kg/ha
    - TNAU application timing: Split doses for better nutrient efficiency
    - Field studies: Optimal K delivery timing improves fruit set by 15-20%
    - Micronutrient studies: Zn and B critical at 60 DAT (flowering)
    """

    # Parse planting date
    try:
        planting = datetime.strptime(planting_date, "%Y-%m-%d")
    except ValueError:
        raise ValueError(f"Invalid date format. Use YYYY-MM-DD. Received: {planting_date}")

    # Define NPK doses PER HECTARE (research-backed ICAR recommendations)
    npk_doses_per_ha = {
        "hybrid": {
            "N": 120,      # kg N/ha - split into 4 applications
            "P": 80,       # kg P₂O₅/ha - entirely at basal
            "K": 80        # kg K₂O/ha - split into 3 applications
        },
        "local": {
            "N": 90,       # kg N/ha - split into 4 applications (conservative)
            "P": 60,       # kg P₂O₅/ha - entirely at basal
            "K": 50        # kg K₂O/ha - split into 3 applications
        }
    }

    doses = npk_doses_per_ha.get(variety_type, npk_doses_per_ha["hybrid"])

    # CRITICAL: Calculate total nutrients needed for ACTUAL field area
    # This is the KEY CHANGE - NOT hardcoded per 1 hectare
    total_N_needed = doses["N"] * field_area_hectares      # DYNAMIC based on input
    total_P2O5_needed = doses["P"] * field_area_hectares   # DYNAMIC based on input
    total_K2O_needed = doses["K"] * field_area_hectares    # DYNAMIC based on input

    schedule = [
        {
            "stage": "At Sowing/Before Transplanting Preparation",
            "stage_hi": "बुवाई से पहले/रोपण की तैयारी",
            "day": 0,
            "days_after_transplanting": -14,
            "application_date": (planting - timedelta(days=14)).strftime("%Y-%m-%d"),
            "application_method": "Mix into soil during final ploughing",
            "application_method_hi": "अंतिम जुताई के दौरान मिट्टी में मिलाएं",
            "notes": "Prepare field 2 weeks before transplanting",
            "research_note": "ICAR-TNAU recommendation: Prepare field with organic matter to improve water retention and microbial activity",
            "fertilizers": [
                {
                    "name": "Farm Yard Manure (FYM)",
                    "name_hi": "खेत की खाद",
                    "dosage_per_ha": 25 if variety_type == "hybrid" else 20,
                    "unit": "tons",
                    "total_quantity_for_field": round((25 if variety_type == "hybrid" else 20) * field_area_hectares, 2),
                    "cost_per_unit": 200,
                    "total_cost": round(((25 if variety_type == "hybrid" else 20) * field_area_hectares * 200), 0),
                    "supplier_note": "Ensure FYM is well-decomposed and pathogen-free"
                },
                {
                    "name": "Single Super Phosphate (SSP)",
                    "name_hi": "सिंगल सुपर फॉस्फेट",
                    "dosage_per_ha": 375 if variety_type == "hybrid" else 300,
                    "unit": "kg",
                    "contains": "P₂O₅ 16%",
                    "total_quantity_for_field": round((375 if variety_type == "hybrid" else 300) * field_area_hectares, 2),
                    "cost_per_unit": 12,
                    "total_cost": round(((375 if variety_type == "hybrid" else 300) * field_area_hectares * 12), 0),
                    "research_note": "All phosphorus applied at basal - P translocation in chilli is poor"
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 130 if variety_type == "hybrid" else 85,
                    "unit": "kg",
                    "contains": "K₂O 60%",
                    "total_quantity_for_field": round((130 if variety_type == "hybrid" else 85) * field_area_hectares, 2),
                    "cost_per_unit": 15,
                    "total_cost": round(((130 if variety_type == "hybrid" else 85) * field_area_hectares * 15), 0)
                }
            ],
            "total_cost_stage": "Calculated per item"
        },

        {
            "stage": "At Transplanting/Sowing",
            "stage_hi": "रोपण के समय",
            "day": 0,
            "days_after_transplanting": 0,
            "application_date": planting.strftime("%Y-%m-%d"),
            "application_method": "Apply with transplanting, mix with soil",
            "application_method_hi": "रोपण के साथ लगाएं, मिट्टी में मिलाएं",
            "notes": "Apply immediately at transplanting - THIS IS CRITICAL",
            "research_note": "First 25% N applied at sowing establishes strong root system",
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # 25% of total N at sowing
                    "unit": "kg",
                    "percentage_of_total": "25% of total N",
                    "total_quantity_for_field": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0),
                    "calculation_note": f"Total N needed: {total_N_needed} kg for {field_area_hectares} ha. First split: {round((doses['N'] / 4) * field_area_hectares, 2)} kg"
                }
            ]
        },

        {
            "stage": "30 Days After Transplanting (Vegetative Growth)",
            "stage_hi": "रोपण के 30 दिन बाद",
            "day": 30,
            "days_after_transplanting": 30,
            "application_date": (planting + timedelta(days=30)).strftime("%Y-%m-%d"),
            "application_method": "Side dressing near plant base, 10cm away from stem",
            "application_method_hi": "पौधे की जड़ के पास साइड ड्रेसिंग",
            "notes": "Critical for vegetative growth establishment",
            "research_note": "ICAR studies: Second N split at 30 DAT establishes branching structure for 20-30% more flower buds",
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # 25% of total N
                    "unit": "kg",
                    "percentage_of_total": "25% of total N",
                    "total_quantity_for_field": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0)
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 20 if variety_type == "hybrid" else 15,
                    "unit": "kg",
                    "percentage_of_total_K": "25% of total K",
                    "total_quantity_for_field": round((20 if variety_type == "hybrid" else 15) * field_area_hectares, 2),
                    "cost_per_unit": 15,
                    "total_cost": round(((20 if variety_type == "hybrid" else 15) * field_area_hectares * 15), 0)
                }
            ]
        },

        {
            "stage": "60 Days After Transplanting (Flowering Initiation)",
            "stage_hi": "रोपण के 60 दिन बाद (फूल आने के समय)",
            "day": 60,
            "days_after_transplanting": 60,
            "application_date": (planting + timedelta(days=60)).strftime("%Y-%m-%d"),
            "application_method": "Side dressing or Foliar spray",
            "application_method_hi": "साइड ड्रेसिंग या पत्तियों पर स्प्रे",
            "notes": "MOST CRITICAL STAGE - Flower and fruit formation",
            "research_note": "Zinc and Boron at 60 DAT increase fruit set by 30-40%. TNAU studies show this stage determines 50% of final yield",
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # 25% of total N
                    "unit": "kg",
                    "percentage_of_total": "25% of total N",
                    "total_quantity_for_field": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0)
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 20 if variety_type == "hybrid" else 15,
                    "unit": "kg",
                    "percentage_of_total_K": "25% of total K",
                    "total_quantity_for_field": round((20 if variety_type == "hybrid" else 15) * field_area_hectares, 2),
                    "cost_per_unit": 15,
                    "total_cost": round(((20 if variety_type == "hybrid" else 15) * field_area_hectares * 15), 0)
                },
                {
                    "name": "19:19:19 NPK (Foliar - OPTIONAL)",
                    "name_hi": "19:19:19 एनपीके (पत्तियों पर - वैकल्पिक)",
                    "dosage_per_ha": 20,
                    "unit": "kg",
                    "preparation": "1 g/liter water, spray on both leaf surfaces",
                    "total_quantity_for_field": round(20 * field_area_hectares, 2),
                    "cost_per_unit": 35,
                    "total_cost": round(20 * field_area_hectares * 35, 0),
                    "research_note": "Foliar nutrients bypass soil pH issues - quick absorption during critical flowering"
                },
                {
                    "name": "Zinc Sulfate (Micronutrient)",
                    "name_hi": "जस्ता सल्फेट",
                    "dosage_per_ha": 5,
                    "unit": "kg",
                    "preparation": "0.5 g/liter water, spray 3 times at 10-day intervals",
                    "total_quantity_for_field": round(5 * field_area_hectares, 2),
                    "cost_per_unit": 200,
                    "total_cost": round(5 * field_area_hectares * 200, 0),
                    "research_note": "Critical for pollen development - Zn deficiency causes 40-50% flower drop"
                },
                {
                    "name": "Boron (Micronutrient)",
                    "name_hi": "बोरॉन",
                    "dosage_per_ha": 2,
                    "unit": "kg",
                    "preparation": "1 g/liter water, essential for fruit set",
                    "total_quantity_for_field": round(2 * field_area_hectares, 2),
                    "cost_per_unit": 300,
                    "total_cost": round(2 * field_area_hectares * 300, 0),
                    "research_note": "Boron required for pollen germination - deficiency causes aborted flowers and poor fruit development"
                }
            ]
        },

        {
            "stage": "90 Days After Transplanting (Fruit Development)",
            "stage_hi": "रोपण के 90 दिन बाद (फल विकास)",
            "day": 90,
            "days_after_transplanting": 90,
            "application_date": (planting + timedelta(days=90)).strftime("%Y-%m-%d"),
            "application_method": "Side dressing or Drip irrigation fertigation",
            "application_method_hi": "साइड ड्रेसिंग या ड्रिप सिंचाई",
            "notes": "Final nitrogen for sustained fruiting across harvest period",
            "research_note": "Last N split maintains nutrient supply for continuous flowering and fruit maturation over 60-90 days",
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # Final 25% of total N
                    "unit": "kg",
                    "percentage_of_total": "25% of total N",
                    "total_quantity_for_field": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0)
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 20 if variety_type == "hybrid" else 15,
                    "unit": "kg",
                    "percentage_of_total_K": "25% of total K (final split)",
                    "total_quantity_for_field": round((20 if variety_type == "hybrid" else 15) * field_area_hectares, 2),
                    "cost_per_unit": 15,
                    "total_cost": round(((20 if variety_type == "hybrid" else 15) * field_area_hectares * 15), 0)
                }
            ]
        }
    ]

    # Add summary calculations at the end
    schedule_summary = {
        "field_area_hectares": field_area_hectares,
        "crop_type": crop_type,
        "variety_type": variety_type,
        "total_nutrients_calculated": {
            "total_N_kg": total_N_needed,
            "total_P2O5_kg": total_P2O5_needed,
            "total_K2O_kg": total_K2O_needed
        },
        "total_fertilizers_needed": {
            "FYM_tons": round((25 if variety_type == "hybrid" else 20) * field_area_hectares, 2),
            "SSP_kg": round((375 if variety_type == "hybrid" else 300) * field_area_hectares, 2),
            "MOP_kg": round((130 if variety_type == "hybrid" else 85) * field_area_hectares, 2),
            "Urea_kg": round(total_N_needed, 2),
            "Zn_kg": round(5 * field_area_hectares, 2),
            "B_kg": round(2 * field_area_hectares, 2)
        },
        "estimated_total_cost": {
            "hybrid": f"₹{round((15000 + (field_area_hectares - 1) * 3000), 0)}-{round((18000 + (field_area_hectares - 1) * 3000), 0)}/hectare equivalent",
            "local": f"₹{round((12000 + (field_area_hectares - 1) * 2500), 0)}-{round((15000 + (field_area_hectares - 1) * 2500), 0)}/hectare equivalent"
        },
        "expected_yield": {
            "hybrid": f"{round(27.5 * field_area_hectares, 1)} tons (25-30 tons/ha × {field_area_hectares} ha)",
            "local": f"{round(20 * field_area_hectares, 1)} tons (18-22 tons/ha × {field_area_hectares} ha)"
        }
    }

    logger.info(f"Generated fertilizer schedule with {len(schedule)} stages for {field_area_hectares} ha")

    return {
        "schedule": schedule,
        "summary": schedule_summary
    }
