# ChilliGuard - Science-Backed Recommendations Database
# Research-based data for Indian chilli crop cultivation
# Based on ICAR studies, TNAU research, and field-validated data

"""
DELIVERABLE 1: SOIL HEALTH RECOMMENDATIONS RULES DATABASE
Based on: ICAR recommendations, TNAU studies, Indian spice research
Crop: Chilli (Capsicum annuum) - Indian conditions
Soil conditions: Well-drained loamy soil ideal
"""

SOIL_IMPROVEMENT_RULES = {
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
    }
}


"""
DELIVERABLE 2: DISEASE METADATA AND TREATMENT PROTOCOLS
Based on: ICAR field studies, IJCMAS research, Indian pathology research
Diseases: 6 classes identified in your ML model
"""

DISEASE_METADATA = {
    0: {
        "name": "Bacterial Spot",
        "name_hi": "जीवाणु धब्बा",
        "scientific_name": "Xanthomonas campestris pv. vesicatoria",
        "scientific_name_hi": "जैंथोमोनास कैम्पेस्ट्रिस",
        "description": "Bacterial infection causing necrotic spots on leaves and fruits. Transmitted through water, contaminated tools, and seed.",
        "description_hi": "जीवाणु संक्रमण जो पत्तियों और फलों पर धब्बे पैदा करता है। पानी और संक्रमित बीजों से फैलता है।",
        "symptoms": [
            "Small water-soaked lesions (2-5mm) with greasy appearance",
            "Brown/black spots with bright yellow halos (3-10mm)",
            "Lesions on both sides of leaves",
            "Leaf yellowing around lesions",
            "Premature leaf defoliation",
            "Fruit lesions appear raised and corky",
            "Defoliation reduces yield by 20-40%"
        ],
        "symptoms_hi": [
            "छोटे जल-भिगोए हुए घाव (2-5 मिमी)",
            "पीले प्रभामंडल के साथ भूरे/काले धब्बे",
            "पत्तियों की समय से पहले गिरना",
            "फलों पर उठे हुए घाव"
        ],
        "causes": [
            "Xanthomonas bacteria from contaminated seeds/soil",
            "Warm (20-30°C) and humid conditions (>80%)",
            "Overhead irrigation (water splash)",
            "Poor air circulation",
            "Contaminated pruning tools"
        ],
        "severity": "High (can cause 20-40% yield loss)",
        "severity_score": 8,
        "onset_period": "30-45 days after transplanting (during rainy season)",
        "treatments": [
            {
                "type": "Cultural",
                "name": "Field Sanitation",
                "name_hi": "खेत की सफाई",
                "description": "Remove infected leaves/fruits immediately. Burn or bury deep in soil. Do not compost.",
                "description_hi": "संक्रमित पत्तियों को तुरंत निकालें और जला दें।",
                "dosage": "N/A",
                "frequency": "Weekly scouting, remove immediately upon detection",
                "timeline": "Throughout growing season",
                "cost_estimate": "₹300-500 (labor)"
            },
            {
                "type": "Chemical",
                "name": "Copper Oxychloride",
                "name_hi": "कॉपर ऑक्सीक्लोराइड",
                "description": "Protectant bactericide. Spray 1% Bordeaux mixture or Copper Oxychloride 3g/liter. Apply preventively during rainy season.",
                "description_hi": "कॉपर ऑक्सीक्लोराइड 3 ग्राम/लीटर पानी में मिलाकर छिड़काव करें।",
                "dosage": "3 g/liter water (or 1% Bordeaux mixture)",
                "frequency": "Every 7-10 days during high humidity (>80%)",
                "timeline": "Start from 30 DAT, intensify during monsoon",
                "cost_estimate": "₹700-1,200/hectare"
            },
            {
                "type": "Antibiotic (Curative)",
                "name": "Streptocycline + Copper Oxychloride",
                "name_hi": "स्ट्रेप्टोसाइक्लिन + कॉपर ऑक्सीक्लोराइड",
                "description": "Use when infection detected. Streptocycline targets bacteria, copper provides broad protection. Alternate with copper to prevent resistance.",
                "description_hi": "संक्रमण दिखाई देने पर तुरंत स्ट्रेप्टोसाइक्लिन लगाएं।",
                "dosage": "Streptocycline 0.5g/liter + Copper Oxychloride 3g/liter",
                "frequency": "Every 10 days for 3-4 sprays",
                "timeline": "Apply upon first detection",
                "cost_estimate": "₹800-1,400/hectare"
            },
            {
                "type": "Biological",
                "name": "Bacillus subtilis + Pseudomonas fluorescens",
                "name_hi": "जैविक नियंत्रण",
                "description": "Bio-agents compete with bacteria and produce antibiotics. Apply as preventive sprays.",
                "description_hi": "जैविक कीटनाशक बैक्टीरिया से लड़ते हैं।",
                "dosage": "10 ml/liter water (each bioagent)",
                "frequency": "Every 7 days preventively, every 5-7 days if infected",
                "timeline": "Start from 30 DAT",
                "cost_estimate": "₹600-900/hectare"
            }
        ],
        "recommendations": [
            "Use disease-free certified seeds",
            "Maintain field spacing 60×45 cm for air circulation",
            "Use drip irrigation - NEVER overhead watering",
            "Remove lower leaves (first 15 cm) for better air flow",
            "Sterilize pruning tools with 1% bleach solution",
            "Apply copper spray preventively during monsoon (June-Sept)",
            "Crop rotation with non-host crops (2 years)",
            "Destroy crop residue after harvest",
            "Maintain field hygiene - remove weeds",
            "Monitor plants weekly for early detection"
        ],
        "control_efficacy": "Copper oxychloride: 60-70% | Streptocycline: 65-75% | Cultural: 40-50%",
        "economic_threshold": "5% leaf area affected - start treatment",
        "cost_estimate": "₹700-1,400/hectare"
    },

    1: {
        "name": "Chilli Leaf Curl Virus",
        "name_hi": "मिर्च पत्ती कर्ल वायरस",
        "scientific_name": "Begomovirus (Chilli Leaf Curl Virus - CLCV)",
        "scientific_name_hi": "बेगोमोवायरस",
        "description": "Viral disease transmitted by whiteflies. First reported in India in 2006. Causes significant yield reduction (30-80%).",
        "description_hi": "वाइट फ्लाई द्वारा प्रेषित वायरस रोग। 2006 में भारत में पहली बार रिपोर्ट किया गया।",
        "symptoms": [
            "Upward curling of leaf margins toward midrib",
            "Leaf distortion and severe deformation",
            "Shortened internodes leading to stunted growth",
            "Reduced leaf size (30-50% smaller)",
            "Pale yellow discoloration of leaves",
            "Flower buds drop (abscission)",
            "Poor pollen viability - no fruit set",
            "Plant height reduced by 50-60%",
            "Complete crop loss in severe cases"
        ],
        "symptoms_hi": [
            "पत्तियों की ऊपर की ओर कर्लिंग",
            "पत्तियां विकृत और छोटी हो जाती हैं",
            "पौधों की रोकथाम",
            "पीले रंग की पत्तियां"
        ],
        "causes": [
            "Begomovirus transmitted by Bemisia tabaci (whitefly)",
            "Whitefly presence >10 insects per leaf indicates high risk",
            "Seed transmission rate: 0-5% (some sources)",
            "Persistent, semi-persistent virus",
            "Warm conditions (>25°C) favor whitefly multiplication",
            "No curative treatment available - preventive only"
        ],
        "severity": "Very High (can cause 50-80% crop loss)",
        "severity_score": 9,
        "onset_period": "2-3 weeks after whitefly infestation",
        "treatments": [
            {
                "type": "Cultural/Preventive",
                "name": "Whitefly Vector Control",
                "name_hi": "वाइट फ्लाई नियंत्रण",
                "description": "Eliminate whitefly vector. Install yellow sticky traps to monitor and trap adults. Use reflective mulch to confuse insects.",
                "description_hi": "पीले चिपचिपे ट्रैप लगाएं। चांदी की पन्नी की गीली घास का उपयोग करें।",
                "dosage": "1 yellow trap per 100 sq m | Silver-coated plastic mulch (45-60 micron)",
                "frequency": "Place traps from 15 DAT onwards, monitor bi-weekly",
                "timeline": "Throughout season, especially during June-October",
                "cost_estimate": "₹1,000-1,500/hectare"
            },
            {
                "type": "Chemical (Insecticide)",
                "name": "Imidacloprid (Systemic) + Diafenthiuron (Contact)",
                "name_hi": "इमिडाक्लोप्रिड + डायफेंथियुरॉन",
                "description": "Systemic insecticide penetrates plant tissues, killing nymphs inside. Diafenthiuron is contact killer for adults. Rotate to prevent resistance.",
                "description_hi": "प्रणालीगत कीटनाशक जो पत्तियों में प्रवेश करता है।",
                "dosage": "Imidacloprid 17.8% SL: 17.5 ml/10 liters | Diafenthiuron 50% WP: 1 g/liter",
                "frequency": "Alternate - Week 1: Imidacloprid, Week 3: Diafenthiuron, Week 5: Imidacloprid",
                "timeline": "Start from 15 DAT, continue every 2 weeks",
                "cost_estimate": "₹900-1,400/hectare"
            },
            {
                "type": "Bio-pesticide",
                "name": "Neem Oil Extract + Imidacloprid",
                "name_hi": "नीम का तेल + इमिडाक्लोप्रिड",
                "description": "Neem oil disrupts whitefly reproduction and feeding. Less toxic than chemical insecticide.",
                "description_hi": "नीम का तेल वाइट फ्लाई प्रजनन को बाधित करता है।",
                "dosage": "Neem oil 5%: 5 ml/liter water | Add imidacloprid for quick knockdown",
                "frequency": "Every 7 days from 15 DAT",
                "timeline": "Entire growing season",
                "cost_estimate": "₹700-1,000/hectare"
            },
            {
                "type": "Viral Protective Spray",
                "name": "Salicylic Acid-based Viricide",
                "name_hi": "वायरस सुरक्षा स्प्रे",
                "description": "Does not kill virus but triggers plant's own immunity. Recommended product: Katyayani Antivirus or similar.",
                "description_hi": "पौधे की अपनी रक्षा को सक्रिय करता है।",
                "dosage": "2 ml/liter water",
                "frequency": "Every 7-10 days from 20 DAT",
                "timeline": "Preventive only, must be applied before infection",
                "cost_estimate": "₹800-1,200/hectare"
            }
        ],
        "recommendations": [
            "Use disease-free, certified seeds from authorized sources",
            "Avoid monoculture - rotate crops annually",
            "Grow border crops (sunflower, marigold) to trap whiteflies",
            "Plant nursery under nylon netting to prevent whitefly entry",
            "Destroy infected plants completely (burn or deep bury)",
            "Install yellow sticky traps from 15 DAT",
            "Apply silver-coated mulch (reflective) to confuse whiteflies",
            "Spray insecticides weekly during June-Oct (high whitefly season)",
            "Maintain field hygiene - remove weeds harboring whiteflies",
            "Avoid planting near contaminated fields",
            "Isolate infected plants immediately",
            "Monitor whitefly population - spray when >5 insects per leaf"
        ],
        "control_efficacy": "Whitefly control: 70-80% | Insecticides prevent spread: 60-70%",
        "economic_threshold": ">5 whiteflies per leaf - immediate insecticide application",
        "preventive_success_rate": "95% if whitefly controlled before 20 DAT",
        "cost_estimate": "₹1,200-1,800/hectare (for prevention)"
    },

    2: {
        "name": "Cercospora Leaf Spot (Frog Eye)",
        "name_hi": "सर्कोस्पोरा पत्ती धब्बा",
        "scientific_name": "Cercospora capsici",
        "scientific_name_hi": "सर्कोस्पोरा कैप्सिसी",
        "description": "Fungal disease causing circular spots resembling frog eyes. Severe in humid regions of India (NE, coastal areas).",
        "description_hi": "कवक रोग जो गोल धब्बे बनाता है। नम क्षेत्रों में गंभीर।",
        "symptoms": [
            "Small circular spots (3-5mm) on leaves",
            "Brown concentric rings with gray center (frog-eye appearance)",
            "Yellow halo around lesions (characteristic)",
            "Spots coalesce and merge with age",
            "Central portion of lesion drops out ('shot-hole' appearance)",
            "Affected leaves turn yellow and drop prematurely",
            "Can affect stems and fruits in severe infections",
            "Defoliation reduces photosynthesis and yield by 30-50%"
        ],
        "symptoms_hi": [
            "पत्तियों पर गोल भूरे धब्बे",
            "धब्बों के चारों ओर पीले रंग का प्रभामंडल",
            "धब्बे बड़े होकर मिल जाते हैं",
            "पत्तियां पीली पड़कर गिरती हैं"
        ],
        "causes": [
            "High humidity (>80% RH) and warm temperature (25-28°C)",
            "Excessive irrigation/overhead watering",
            "Poor air circulation in dense canopy",
            "Nitrogen deficiency increases susceptibility",
            "Fungal spores spread through water splash",
            "Favored during monsoon season (June-Sept)"
        ],
        "severity": "Medium-High (can cause 20-50% yield loss)",
        "severity_score": 6,
        "onset_period": "30-45 days after transplanting",
        "treatments": [
            {
                "type": "Cultural",
                "name": "Air Circulation & Pruning",
                "name_hi": "हवा का संचार",
                "description": "Remove lower leaves (15cm height), dense foliage. Maintain spacing 60×45cm. Switch to drip irrigation.",
                "description_hi": "निचली पत्तियों को निकालें। ड्रिप सिंचाई का उपयोग करें।",
                "dosage": "N/A",
                "frequency": "Continuous maintenance during growing season",
                "timeline": "Implement immediately after transplanting",
                "cost_estimate": "₹400-600/hectare"
            },
            {
                "type": "Chemical (Preventive)",
                "name": "Mancozeb (broad-spectrum)",
                "name_hi": "मैंकोजेब",
                "description": "Multi-site fungicide. Protects against Cercospora. Apply preventively during high humidity.",
                "description_hi": "व्यापक स्पेक्ट्रम कवकनाशी। उच्च आर्द्रता के दौरान निवारक रूप से लगाएं।",
                "dosage": "2 g/liter water (75% WP formulation)",
                "frequency": "Every 7-10 days during monsoon",
                "timeline": "Start from 30 DAT, critical June-Sept",
                "cost_estimate": "₹600-900/hectare"
            },
            {
                "type": "Chemical (Curative)",
                "name": "Azoxystrobin + Tebuconazole",
                "name_hi": "एज़ॉक्सीस्ट्रोबिन + टेबुकोनाज़ोल",
                "description": "Strobilurin + Triazole combination. Highly effective - 64.69% disease control with 1650 kg/ha yield.",
                "description_hi": "संयोजित कवकनाशी - अधिक प्रभावी।",
                "dosage": "1 ml/liter water (1.5 ml if severe)",
                "frequency": "Double spray (10 days apart) at first sign of infection",
                "timeline": "Upon detection of symptoms",
                "cost_estimate": "₹800-1,200/hectare"
            },
            {
                "type": "Alternative",
                "name": "Carbendazim + Mancozeb",
                "name_hi": "कार्बेंडाजिम + मैंकोजेब",
                "description": "Systemic + contact combination. Good results: 60-65% control.",
                "description_hi": "प्रणालीगत और संपर्क कवकनाशी का मिश्रण।",
                "dosage": "300-400 g/acre (12% + 63% WP)",
                "frequency": "Every 7-10 days",
                "timeline": "During monsoon season",
                "cost_estimate": "₹700-1,000/hectare"
            }
        ],
        "recommendations": [
            "Maintain field spacing 60×45 cm minimum",
            "Use drip irrigation - avoid overhead watering",
            "Remove lower leaves up to 15-20 cm height",
            "Reduce nitrogen fertilizer in humid season (increases susceptibility)",
            "Destroy infected leaves immediately",
            "Avoid working in field when wet (spreads spores)",
            "Alternate fungicides to prevent resistance",
            "Apply Mancozeb preventively every 7-10 days during June-Sept",
            "Use Azoxystrobin + Tebuconazole for severe outbreaks",
            "Ensure good drainage and avoid water stagnation",
            "Mulch to keep leaves dry",
            "Monitor field weekly during high humidity"
        ],
        "control_efficacy": "Azoxystrobin+Tebuconazole (double spray): 64.69% | Carbendazim+Mancozeb: 60-65%",
        "economic_threshold": "10% leaf area affected or 5% defoliation - start treatment",
        "cost_estimate": "₹700-1,400/hectare"
    },

    3: {
        "name": "Nutritional Deficiency",
        "name_hi": "पोषण कमी",
        "scientific_name": "Multiple nutrient deficiencies (N, P, K, Zn, B, Mg)",
        "scientific_name_hi": "विभिन्न पोषक तत्वों की कमी",
        "description": "Visible symptoms when soil/plant nutrient levels fall below critical thresholds. Affects growth, flowering, and fruit quality.",
        "description_hi": "जब मिट्टी में पोषक तत्व कम हों तो पत्तियों में लक्षण दिखाई देते हैं।",
        "symptoms": [
            "Nitrogen deficiency: Older leaves turn light green/yellow, stunted growth",
            "Phosphorus deficiency: Purple/pinkish leaf margins, poor branching, delayed flowering",
            "Potassium deficiency: Marginal scorching (brown edges), reduced fruit size",
            "Zinc deficiency: Interveinal chlorosis on young leaves (yellow between veins)",
            "Boron deficiency: Distorted flowers, no fruit set, hollow fruits",
            "Magnesium deficiency: Interveinal yellowing of older leaves",
            "General: Stunted growth, poor root development, reduced yield"
        ],
        "symptoms_hi": [
            "नाइट्रोजन की कमी: पुरानी पत्तियां पीली हो जाती हैं",
            "फॉस्फोरस की कमी: बैंगनी रंग की पत्तियां",
            "पोटेशियम की कमी: पत्तियों के किनारे भूरे हो जाते हैं",
            "जस्ता की कमी: पत्तियों में पीलापन"
        ],
        "causes": [
            "Inadequate fertilizer application",
            "Soil pH outside optimal range (6.5-7.5) reducing nutrient availability",
            "Poor drainage leading to nutrient leaching",
            "Excessive rainfall/irrigation",
            "Acidic soil (<5.5 pH) reducing availability of P, K",
            "Alkaline soil (>7.5 pH) reducing availability of Zn, Fe, Mn",
            "Single nutrient fertilizers (unbalanced nutrition)"
        ],
        "severity": "Medium (yields reduced by 20-40%)",
        "severity_score": 5,
        "onset_period": "Visible 30-45 days after transplanting if nutrients depleted",
        "treatments": [
            {
                "type": "Soil Correction",
                "name": "Soil Testing + Corrective Fertilization",
                "name_hi": "मिट्टी परीक्षण और सुधार",
                "description": "Get soil tested for NPK, pH, micronutrients. Apply targeted fertilizers based on results.",
                "description_hi": "मिट्टी की जांच करें। परिणाम के आधार पर खाद लगाएं।",
                "dosage": "Per soil test recommendations. Standard: N: 100-120 kg/ha, P: 60-80 kg/ha, K: 50-80 kg/ha",
                "frequency": "Once at season start based on test results",
                "timeline": "Before sowing/transplanting",
                "cost_estimate": "₹500 (soil test) + ₹2,000-3,000 (fertilizers)"
            },
            {
                "type": "Basal Dressing",
                "name": "Balanced Fertilizer at Planting",
                "name_hi": "बुवाई के समय संतुलित खाद",
                "description": "Apply 25 tons/ha FYM + NPK 30:60:30 kg/ha for local varieties or 30:80:80 for hybrids.",
                "description_hi": "रोपण के समय संतुलित खाद लगाएं।",
                "dosage": "FYM: 25-30 tons/ha | NPK: 30:60:30 kg/ha (local) or 30:80:80 (hybrid)",
                "frequency": "Once, mix with soil during final ploughing",
                "timeline": "Before planting",
                "cost_estimate": "₹3,000-5,000/hectare"
            },
            {
                "type": "Top Dressing",
                "name": "Urea Application in Splits",
                "name_hi": "यूरिया का विभाजित अनुप्रयोग",
                "description": "Apply nitrogen in 4 splits (sowing + 30, 60, 90 DAT) for sustained nutrition.",
                "description_hi": "चार भागों में यूरिया डालें (बुवाई + 30, 60, 90 दिन बाद)।",
                "dosage": "26 kg N at each stage = 104 kg total for hybrid (divided into urea splits)",
                "frequency": "At 0, 30, 60, 90 days after transplanting",
                "timeline": "Throughout growing season",
                "cost_estimate": "₹1,500-2,000/hectare"
            },
            {
                "type": "Foliar Spray",
                "name": "Micronutrient Complex Spray",
                "name_hi": "सूक्ष्म पोषक तत्व स्प्रे",
                "description": "Rapid absorption through leaves. For Zn, B deficiency - spray from 40 DAT onwards.",
                "description_hi": "पत्तियों के माध्यम से तेजी से अवशोषण। 40 दिन के बाद स्प्रे करें।",
                "dosage": "Zinc: 0.5-0.6 g/liter | Boron: 1 g/liter | 19:19:19 NPK: 1 g/liter",
                "frequency": "3 sprays with 10-day intervals starting 40 DAT",
                "timeline": "40-90 DAT (vegetative and flowering stages)",
                "cost_estimate": "₹600-900/hectare"
            },
            {
                "type": "pH Correction",
                "name": "Soil pH Amendment",
                "name_hi": "मिट्टी pH सुधार",
                "description": "If pH < 5.5: Apply lime (2-3 tons/ha). If pH > 7.5: Apply sulfur (500-800 kg/ha).",
                "description_hi": "अगर pH कम है तो चूना, अगर अधिक है तो गंधक लगाएं।",
                "dosage": "Per soil pH test recommendation",
                "frequency": "Once per season if needed",
                "timeline": "Before planting",
                "cost_estimate": "₹3,000-5,000/hectare"
            }
        ],
        "recommendations": [
            "Conduct soil testing before sowing - CRITICAL",
            "Apply 25-30 tons/ha FYM (farm yard manure) for organic matter",
            "Use balanced NPK fertilizers - not single nutrients",
            "For hybrids: Apply 30:80:80 kg/ha NPK (higher P and K)",
            "For local varieties: Apply 30:60:30 kg/ha NPK",
            "Split nitrogen application in 4 equal parts (0, 30, 60, 90 DAT)",
            "Monitor leaf color - early detection is key",
            "Spray Zn (0.5 g/L) and B (1 g/L) from 40 DAT onwards",
            "Correct soil pH to 6.5-7.5 - prevents many deficiencies",
            "Use drip irrigation for efficient nutrient delivery",
            "Apply bio-fertilizers (Azospirillum, Phosphobacteria) 1L + 50kg FYM",
            "Avoid excessive nitrogen - causes vegetative growth at expense of fruiting"
        ],
        "control_efficacy": "Soil test guided approach: 85-95% prevention | Corrective foliar spray: 70-80%",
        "economic_threshold": "Visible symptoms on >20% plants - start corrective action",
        "cost_estimate": "₹2,500-4,000/hectare (preventive nutrition plan)"
    },

    4: {
        "name": "White Spot Disease",
        "name_hi": "सफेद धब्बा रोग",
        "scientific_name": "Likely Alternaria species or Phomopsis species (secondary fungus)",
        "scientific_name_hi": "अल्टरनेरिया या फोमोप्सिस प्रजाति",
        "description": "Fungal disease causing white/light colored spots on leaves. Less common than Cercospora but damaging in specific conditions.",
        "description_hi": "पत्तियों पर सफेद धब्बे पैदा करने वाला कवक रोग।",
        "symptoms": [
            "Small white or light cream-colored spots (2-4mm) on leaves",
            "Spots have darker concentric rings or borders",
            "Spotting appears on leaf surface, sometimes on stems",
            "Spots may merge and coalesce in severe infections",
            "Affected tissue becomes papery and may crack",
            "In severe cases: Leaf yellowing and premature drop",
            "Can affect fruit - white lesions with dark center",
            "Development accelerated by overhead irrigation"
        ],
        "symptoms_hi": [
            "पत्तियों पर सफेद गोल धब्बे",
            "धब्बों के चारों ओर गहरे रंग की सीमा",
            "गंभीर संक्रमण में पत्तियां पीली हो जाती हैं",
            "फलों पर भी धब्बे दिख सकते हैं"
        ],
        "causes": [
            "High humidity (>75%) and temperature (25-28°C)",
            "Water-logged conditions from excessive irrigation",
            "Overhead or flood irrigation spreading spores",
            "Poor air circulation in dense canopy",
            "Weak plants with low vigor susceptible",
            "Fungal spores from soil/crop residue",
            "More prevalent in coastal/high rainfall areas"
        ],
        "severity": "Low-Medium (yields reduced by 10-30%)",
        "severity_score": 4,
        "onset_period": "40-60 days after transplanting",
        "treatments": [
            {
                "type": "Cultural",
                "name": "Moisture Management",
                "name_hi": "नमी प्रबंधन",
                "description": "Switch to drip irrigation immediately. Remove lower leaves for air circulation. Avoid working in wet field.",
                "description_hi": "ड्रिप सिंचाई का उपयोग करें। नमी नियंत्रित करें।",
                "dosage": "N/A",
                "frequency": "Daily inspection and preventive actions",
                "timeline": "Throughout season",
                "cost_estimate": "₹300-500/hectare"
            },
            {
                "type": "Chemical (Preventive)",
                "name": "Mancozeb or Chlorothalonil",
                "name_hi": "मैंकोजेब या क्लोरोथलोनिल",
                "description": "Broad-spectrum contact fungicide. Use preventively during high humidity periods.",
                "description_hi": "व्यापक स्पेक्ट्रम कवकनाशी। उच्च आर्द्रता के दौरान लगाएं।",
                "dosage": "Mancozeb: 2 g/liter | Chlorothalonil: 2.5 g/liter",
                "frequency": "Every 7-10 days during wet season",
                "timeline": "June-September (monsoon)",
                "cost_estimate": "₹600-900/hectare"
            },
            {
                "type": "Chemical (Curative)",
                "name": "Carbendazim + Mancozeb",
                "name_hi": "कार्बेंडाजिम + मैंकोजेब",
                "description": "Systemic + contact combination for active infection. More effective than single product.",
                "description_hi": "संयोजित कवकनाशी अधिक प्रभावी है।",
                "dosage": "300-400 g/acre (12% + 63% WP combination)",
                "frequency": "Every 7 days when infection detected",
                "timeline": "Upon symptom appearance",
                "cost_estimate": "₹700-1,000/hectare"
            },
            {
                "type": "Biological",
                "name": "Trichoderma viride",
                "name_hi": "ट्राइकोडर्मा विराइड",
                "description": "Bioagent spray - antagonistic to fungal pathogens. Preventive application.",
                "description_hi": "जैविक कवकनाशी - रोग-पैदा करने वाले कवक के विरुद्ध।",
                "dosage": "10 ml/liter water",
                "frequency": "Every 7 days preventively, every 5 days if infection present",
                "timeline": "From 30 DAT onwards",
                "cost_estimate": "₹500-800/hectare"
            }
        ],
        "recommendations": [
            "Use drip irrigation - NEVER overhead irrigation",
            "Maintain field spacing 60×45 cm for good air circulation",
            "Remove lower leaves (15cm) weekly",
            "Do NOT work in field when plants are wet",
            "Spray preventive fungicide every 7-10 days during June-Sept",
            "Keep field weed-free to improve air flow",
            "Avoid excessive nitrogen fertilizer",
            "Destroy infected leaves immediately",
            "Apply mulch to keep soil moist but prevent leaf wetness",
            "Monitor field 2-3 times per week",
            "Use resistant varieties if available",
            "Maintain good plant health through balanced nutrition"
        ],
        "control_efficacy": "Mancozeb (preventive): 60-70% | Carbendazim+Mancozeb (curative): 70-75%",
        "economic_threshold": "15% leaf area affected - start treatment",
        "cost_estimate": "₹600-1,000/hectare"
    },

    5: {
        "name": "Healthy Leaf",
        "name_hi": "स्वस्थ पत्ती",
        "scientific_name": "Capsicum annuum - Normal",
        "scientific_name_hi": "सामान्य और स्वस्थ पत्ती",
        "description": "Plant showing no signs of disease, nutritional deficiency, or pest damage. Green, vibrant foliage indicates good health.",
        "description_hi": "बिना किसी रोग के स्वस्थ पत्ती। हरी, जीवंत पत्ती पौधे की अच्छी स्वास्थ्य को दर्शाती है।",
        "symptoms": [
            "Uniform green leaf color (no yellowing)",
            "Leaf margins intact (no browning/scorching)",
            "Veins clearly visible and green",
            "Leaf size appropriate for plant age",
            "No spots, lesions, or discoloration",
            "No visible pest damage",
            "Plant vigor excellent",
            "Flowers abundant with good fruit set"
        ],
        "symptoms_hi": [
            "समान हरा रंग, कोई पीलापन नहीं",
            "पत्तियों की किनारें सुरक्षित",
            "कोई धब्बे या रंग परिवर्तन नहीं",
            "कोई कीट क्षति नहीं"
        ],
        "causes": [
            "Optimal soil health (pH 6.5-7.5)",
            "Balanced NPK nutrition",
            "Adequate moisture (60-70%)",
            "Good air circulation",
            "Proper plant spacing",
            "Absence of diseases and pests",
            "Suitable temperature (20-25°C)"
        ],
        "severity": "None - Healthy plant",
        "severity_score": 0,
        "onset_period": "N/A",
        "treatments": [
            {
                "type": "Maintenance",
                "name": "Regular Monitoring & Prevention",
                "name_hi": "नियमित निरीक्षण और रोकथाम",
                "description": "Continue with preventive practices to maintain health. Scout field weekly for early disease detection.",
                "description_hi": "स्वास्थ्य बनाए रखने के लिए निवारक उपाय करते रहें।",
                "dosage": "N/A",
                "frequency": "Weekly field inspection",
                "timeline": "Throughout growing season",
                "cost_estimate": "₹200/hectare (labor)"
            },
            {
                "type": "Fertilizer Management",
                "name": "Continue Scheduled Nutrition",
                "name_hi": "पोषण योजना जारी रखें",
                "description": "Follow original fertilizer schedule (top dressing at 30, 60, 90 DAT). Maintain balanced nutrition.",
                "description_hi": "निर्धारित खाद का कार्यक्रम जारी रखें।",
                "dosage": "Per original nutrition plan for hybrid/local varieties",
                "frequency": "As per predetermined schedule",
                "timeline": "Entire growing season",
                "cost_estimate": "₹2,000-3,000/hectare"
            },
            {
                "type": "Preventive Spray",
                "name": "Alternating Preventive Sprays",
                "name_hi": "निवारक स्प्रे",
                "description": "Apply preventive fungicide sprays during high-risk periods (monsoon June-Sept) to prevent disease outbreak.",
                "description_hi": "मानसून के दौरान निवारक स्प्रे लगाएं।",
                "dosage": "Mancozeb 2 g/L OR Neem oil 5 ml/L (alternate weekly)",
                "frequency": "Every 10-14 days during June-Sept",
                "timeline": "High-risk monsoon season",
                "cost_estimate": "₹400-600/hectare"
            }
        ],
        "recommendations": [
            "Maintain current cultural practices - spacing, irrigation, pruning",
            "Continue scheduled fertilizer applications",
            "Scout field every 7 days to detect early disease signs",
            "Apply preventive sprays during high humidity months (June-Sept)",
            "Ensure proper drainage to prevent waterlogging",
            "Maintain field hygiene - remove dead leaves/plants",
            "Keep tools sterilized (1% bleach solution)",
            "Use drip irrigation consistently",
            "Do not skip any scheduled tasks",
            "Monitor weather - increase vigilance during prolonged rains",
            "Continue insect monitoring (especially whiteflies)",
            "Plan crop rotation for next season to break pest cycles"
        ],
        "control_efficacy": "Maintenance: 100% (prevention of disease)",
        "economic_threshold": "N/A - Continue preventive practices",
        "expected_yield": "25-30 tons/hectare (healthy crop)",
        "cost_estimate": "₹2,500-3,500/hectare (maintenance + prevention)"
    }
}


"""
DELIVERABLE 3: CHILLI FERTILIZER SCHEDULE
Based on: TNAU recommendations, ICAR field studies, Indian hybrid/local variety data
Calculated for actual field area application
"""

def generate_fertilizer_schedule(planting_date, field_area_hectares, crop_type="chilli", variety_type="hybrid"):
    """
    Generate detailed fertilizer application schedule
    Parameters:
    - planting_date: "YYYY-MM-DD"
    - field_area_hectares: numeric (e.g., 1.5)
    - crop_type: "chilli" (default)
    - variety_type: "hybrid" or "local"
    """
    
    from datetime import datetime, timedelta
    
    # Parse planting date
    planting = datetime.strptime(planting_date, "%Y-%m-%d")
    
    # Define NPK doses per hectare based on variety
    npk_doses = {
        "hybrid": {"N": 120, "P": 80, "K": 80},  # Higher for hybrids
        "local": {"N": 90, "P": 60, "K": 50}      # Conservative for local
    }
    
    doses = npk_doses.get(variety_type, npk_doses["hybrid"])
    
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
            "fertilizers": [
                {
                    "name": "Farm Yard Manure (FYM)",
                    "name_hi": "खेत की खाद",
                    "dosage_per_ha": 25 if variety_type == "hybrid" else 20,
                    "unit": "tons",
                    "total_quantity": round((25 if variety_type == "hybrid" else 20) * field_area_hectares, 2),
                    "cost_per_unit": 200,
                    "total_cost": round(((25 if variety_type == "hybrid" else 20) * field_area_hectares * 200), 0)
                },
                {
                    "name": "Single Super Phosphate (SSP)",
                    "name_hi": "सिंगल सुपर फॉस्फेट",
                    "dosage_per_ha": 375 if variety_type == "hybrid" else 300,
                    "unit": "kg",
                    "contains": "P₂O₅ 16%",
                    "total_quantity": round((375 if variety_type == "hybrid" else 300) * field_area_hectares, 2),
                    "cost_per_unit": 12,
                    "total_cost": round(((375 if variety_type == "hybrid" else 300) * field_area_hectares * 12), 0)
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 130 if variety_type == "hybrid" else 85,
                    "unit": "kg",
                    "contains": "K₂O 60%",
                    "total_quantity": round((130 if variety_type == "hybrid" else 85) * field_area_hectares, 2),
                    "cost_per_unit": 15,
                    "total_cost": round(((130 if variety_type == "hybrid" else 85) * field_area_hectares * 15), 0)
                }
            ],
            "total_cost": "Calculated per item"
        },
        
        {
            "stage": "At Transplanting/Sowing",
            "stage_hi": "रोपण के समय",
            "day": 0,
            "days_after_transplanting": 0,
            "application_date": planting.strftime("%Y-%m-%d"),
            "application_method": "Apply with transplanting, mix with soil",
            "application_method_hi": "रोपण के साथ लगाएं, मिट्टी में मिलाएं",
            "notes": "Apply immediately at transplanting",
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # 25% of total N at sowing
                    "unit": "kg",
                    "percentage": f"{doses['N']/4} kg/ha (25% of total N)",
                    "total_quantity": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0)
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
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # 25% of total N
                    "unit": "kg",
                    "total_quantity": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0)
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 20 if variety_type == "hybrid" else 15,
                    "unit": "kg",
                    "total_quantity": round((20 if variety_type == "hybrid" else 15) * field_area_hectares, 2),
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
            "notes": "Critical for flower and fruit formation",
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # 25% of total N
                    "unit": "kg",
                    "total_quantity": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0)
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 20 if variety_type == "hybrid" else 15,
                    "unit": "kg",
                    "total_quantity": round((20 if variety_type == "hybrid" else 15) * field_area_hectares, 2),
                    "cost_per_unit": 15,
                    "total_cost": round(((20 if variety_type == "hybrid" else 15) * field_area_hectares * 15), 0)
                },
                {
                    "name": "19:19:19 NPK (Foliar) [OPTIONAL]",
                    "name_hi": "19:19:19 एनपीके (पत्तियों पर)",
                    "dosage_per_ha": 20,
                    "unit": "kg",
                    "application_note": "For foliar spray: 1 g/liter water, spray on both sides of leaves",
                    "total_quantity": round(20 * field_area_hectares, 2),
                    "cost_per_unit": 35,
                    "total_cost": round(20 * field_area_hectares * 35, 0)
                },
                {
                    "name": "Zinc Sulfate (Micronutrient)",
                    "name_hi": "जस्ता सल्फेट",
                    "dosage_per_ha": 5,
                    "unit": "kg",
                    "application_note": "0.5 g/liter water, spray 3 times at 10-day intervals",
                    "total_quantity": round(5 * field_area_hectares, 2),
                    "cost_per_unit": 200,
                    "total_cost": round(5 * field_area_hectares * 200, 0)
                },
                {
                    "name": "Boron (Micronutrient)",
                    "name_hi": "बोरॉन",
                    "dosage_per_ha": 2,
                    "unit": "kg",
                    "application_note": "1 g/liter water, critical for fruit set",
                    "total_quantity": round(2 * field_area_hectares, 2),
                    "cost_per_unit": 300,
                    "total_cost": round(2 * field_area_hectares * 300, 0)
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
            "notes": "Final nitrogen for sustained fruiting",
            "fertilizers": [
                {
                    "name": "Urea (Nitrogen)",
                    "name_hi": "यूरिया",
                    "dosage_per_ha": doses["N"] / 4,  # Final 25% of total N
                    "unit": "kg",
                    "total_quantity": round((doses["N"] / 4) * field_area_hectares, 2),
                    "cost_per_unit": 5,
                    "total_cost": round(((doses["N"] / 4) * field_area_hectares * 5), 0)
                },
                {
                    "name": "Muriate of Potash (MOP)",
                    "name_hi": "म्यूरिएट ऑफ पोटाश",
                    "dosage_per_ha": 20 if variety_type == "hybrid" else 15,
                    "unit": "kg",
                    "total_quantity": round((20 if variety_type == "hybrid" else 15) * field_area_hectares, 2),
                    "cost_per_unit": 15,
                    "total_cost": round(((20 if variety_type == "hybrid" else 15) * field_area_hectares * 15), 0)
                }
            ]
        }
    ]
    
    return schedule


# Summary table for typical 1 hectare hybrid chilli crop
FERTILIZER_SUMMARY = {
    "hybrid_1ha": {
        "total_N_kg": 120,
        "total_P2O5_kg": 80,
        "total_K2O_kg": 80,
        "total_FYM_tons": 25,
        "total_SSP_kg": 375,
        "total_MOP_kg": 130,
        "total_Zn_kg": 5,
        "total_B_kg": 2,
        "total_cost_estimate": "₹15,000-18,000/hectare",
        "expected_yield": "25-30 tons/hectare fresh fruit"
    },
    "local_1ha": {
        "total_N_kg": 90,
        "total_P2O5_kg": 60,
        "total_K2O_kg": 50,
        "total_FYM_tons": 20,
        "total_SSP_kg": 300,
        "total_MOP_kg": 85,
        "total_Zn_kg": 4,
        "total_B_kg": 1.5,
        "total_cost_estimate": "₹12,000-15,000/hectare",
        "expected_yield": "18-22 tons/hectare fresh fruit"
    }
}
