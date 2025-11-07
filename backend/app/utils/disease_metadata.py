"""
Disease metadata for 6 chilli disease classes
Based on model_info.json: Bacterial Spot, Cercospora, Curl Virus, Healthy, Nutrition Deficiency, White Spot
"""

DISEASE_CLASSES = {
    0: {
        'name': 'Bacterial Spot',
        'scientific_name': 'Xanthomonas campestris pv. vesicatoria',
        'description': 'Bacterial infection causing necrotic spots on leaves and fruits',
        'symptoms': ['Small water-soaked lesions', 'Brown/black spots with yellow halos', 'Leaf yellowing', 'Premature defoliation', 'Fruit lesions'],
        'causes': ['Xanthomonas bacteria', 'Warm humid weather', 'Overhead irrigation', 'Poor air circulation', 'Contaminated seeds'],
        'severity': 'High',
        'treatments': [
            {
                'type': 'Chemical',
                'name': 'Copper-based fungicide',
                'description': 'Spray 1% Bordeaux mixture or Copper Oxychloride (3g/liter) every 7-10 days',
                'dosage': '3g per liter',
                'frequency': 'Every 7-10 days'
            },
            {
                'type': 'Antibiotic',
                'name': 'Streptocycline',
                'description': 'Apply Streptocycline (0.5g per liter) + Copper Oxychloride',
                'dosage': '0.5g per liter',
                'frequency': 'Every 10 days'
            },
            {
                'type': 'Cultural',
                'name': 'Field sanitation',
                'description': 'Remove infected plant parts immediately and destroy',
                'dosage': 'N/A',
                'frequency': 'As needed'
            }
        ],
        'recommendations': [
            'Remove infected leaves and fruits immediately',
            'Ensure good air circulation by proper spacing (60x45 cm)',
            'Avoid overhead irrigation - use drip irrigation',
            'Apply copper-based fungicide preventively during rainy season',
            'Use disease-free certified seeds',
            'Crop rotation with non-host crops',
            'Maintain field hygiene'
        ]
    },
    1: {
        'name': 'Cercospora Leaf Spot',
        'scientific_name': 'Cercospora capsici',
        'description': 'Fungal disease causing circular leaf spots with concentric rings',
        'symptoms': ['Circular brown spots with gray centers', 'Concentric rings (target spot)', 'Yellowing around lesions', 'Premature leaf drop', 'Reduced yield'],
        'causes': ['Cercospora fungus', 'High humidity (>85%)', 'Warm temperature (25-30°C)', 'Prolonged leaf wetness', 'Dense plant canopy'],
        'severity': 'High',
        'treatments': [
            {
                'type': 'Fungicide',
                'name': 'Mancozeb',
                'description': 'Spray Mancozeb 75% WP (2.5g/liter) every 10-12 days',
                'dosage': '2.5g per liter',
                'frequency': 'Every 10-12 days'
            },
            {
                'type': 'Fungicide',
                'name': 'Carbendazim',
                'description': 'Spray Carbendazim 0.5g/liter alternating with Mancozeb',
                'dosage': '0.5g per liter',
                'frequency': 'Every 10-12 days (alternating)'
            },
            {
                'type': 'Organic',
                'name': 'Neem oil',
                'description': 'Spray 3-5% Neem oil solution as preventive measure',
                'dosage': '30-50ml per liter',
                'frequency': 'Every 7-10 days'
            }
        ],
        'recommendations': [
            'Remove infected leaves immediately',
            'Improve air circulation through pruning',
            'Avoid wetting foliage during irrigation',
            'Apply fungicide preventively during monsoon',
            'Maintain proper plant spacing',
            'Use mulching to prevent soil splash',
            'Avoid working in wet fields'
        ]
    },
    2: {
        'name': 'Curl Virus',
        'scientific_name': 'Chilli Leaf Curl Virus (ChiLCV)',
        'description': 'Viral disease causing severe leaf curling, yellowing and stunting transmitted by whiteflies',
        'symptoms': ['Upward/downward leaf curling', 'Yellowing of young leaves', 'Severe stunting', 'Reduced fruit size', 'Flower drop', 'Distorted leaf shape'],
        'causes': ['Chilli leaf curl virus', 'Whitefly vector (Bemisia tabaci)', 'Virus transmission from infected plants', 'Warm weather (25-35°C)'],
        'severity': 'Critical',
        'treatments': [
            {
                'type': 'Insecticide',
                'name': 'Imidacloprid',
                'description': 'Spray Imidacloprid 17.8% SL (0.5ml/liter) for whitefly control',
                'dosage': '0.5ml per liter',
                'frequency': 'Every 7 days'
            },
            {
                'type': 'Insecticide',
                'name': 'Thiamethoxam',
                'description': 'Spray Thiamethoxam 25% WG (0.3g/liter) alternating with Imidacloprid',
                'dosage': '0.3g per liter',
                'frequency': 'Every 7 days (alternating)'
            },
            {
                'type': 'Organic',
                'name': 'Neem oil',
                'description': 'Spray 3% Neem oil + sticky yellow traps for whitefly management',
                'dosage': '30ml per liter',
                'frequency': 'Every 5-7 days'
            },
            {
                'type': 'Cultural',
                'name': 'Rogue infected plants',
                'description': 'Remove and destroy severely infected plants immediately',
                'dosage': 'N/A',
                'frequency': 'Weekly monitoring'
            }
        ],
        'recommendations': [
            'Remove severely infected plants immediately and destroy',
            'Control whitefly population aggressively',
            'Use yellow sticky traps (20-25 per acre)',
            'Apply reflective mulch (silver/white)',
            'Use resistant/tolerant varieties if available',
            'Avoid water stress',
            'Border crop with marigold to trap whiteflies',
            'Maintain weed-free fields'
        ]
    },
    3: {
        'name': 'Healthy Leaf',
        'scientific_name': 'Healthy',
        'description': 'Plant showing no signs of disease or stress - optimal health',
        'symptoms': ['Normal dark green color', 'No spots or lesions', 'Normal growth', 'Healthy fruit development'],
        'causes': ['Good growing conditions', 'Proper nutrition', 'Adequate water', 'Pest-free environment'],
        'severity': 'None',
        'treatments': [
            {
                'type': 'Preventive',
                'name': 'Regular monitoring',
                'description': 'Continue regular field monitoring and maintenance',
                'dosage': 'N/A',
                'frequency': 'Weekly'
            },
            {
                'type': 'Nutrition',
                'name': 'Balanced fertilization',
                'description': 'Apply balanced NPK as per soil test recommendations',
                'dosage': 'As per soil test',
                'frequency': 'Monthly'
            }
        ],
        'recommendations': [
            'Continue current management practices',
            'Maintain optimal soil moisture (60-70% field capacity)',
            'Provide 6-8 hours of sunlight daily',
            'Apply NPK fertilizer: 100:60:60 kg/ha split doses',
            'Continue regular pest monitoring',
            'Maintain proper spacing and pruning',
            'Apply organic mulch to conserve moisture'
        ]
    },
    4: {
        'name': 'Nutrition Deficiency',
        'scientific_name': 'Nutrient Deficiency Syndrome',
        'description': 'Nutritional imbalance causing yellowing, stunting and poor growth - primarily Nitrogen deficiency',
        'symptoms': ['Yellowing of older leaves (chlorosis)', 'Interveinal chlorosis', 'Stunted growth', 'Reduced fruiting', 'Pale green to yellow leaves', 'Thin stems'],
        'causes': ['Low nitrogen in soil', 'Imbalanced fertilization', 'Poor soil quality', 'Excessive leaching', 'Low organic matter', 'Improper pH'],
        'severity': 'Medium',
        'treatments': [
            {
                'type': 'Chemical',
                'name': 'NPK fertilizer',
                'description': 'Apply NPK 19:19:19 (10g per plant) as top dressing',
                'dosage': '10g per plant',
                'frequency': 'Every 15 days'
            },
            {
                'type': 'Foliar',
                'name': 'Urea spray',
                'description': 'Foliar spray of 2% Urea solution for quick recovery',
                'dosage': '20g per liter',
                'frequency': 'Every 10 days (2-3 sprays)'
            },
            {
                'type': 'Organic',
                'name': 'Vermicompost',
                'description': 'Apply well-decomposed vermicompost (2-3 kg per plant)',
                'dosage': '2-3 kg per plant',
                'frequency': 'Once a month'
            },
            {
                'type': 'Micronutrients',
                'name': 'Micronutrient mixture',
                'description': 'Spray micronutrient mixture (Zn, Fe, Mn, B) at 2g/liter',
                'dosage': '2g per liter',
                'frequency': 'Every 20 days'
            }
        ],
        'recommendations': [
            'Apply nitrogen-rich fertilizer immediately (Urea @ 50kg/acre)',
            'Correct soil pH to 6.0-7.0 using lime if needed',
            'Improve soil drainage to prevent leaching',
            'Add organic matter (FYM/compost 10-15 tons/ha)',
            'Apply foliar spray of 19:19:19 + micronutrients',
            'Conduct soil test to identify specific deficiencies',
            'Mulch with organic materials',
            'Ensure adequate irrigation (not excessive)'
        ]
    },
    5: {
        'name': 'White Spot',
        'scientific_name': 'Powdery Mildew (Leveillula taurica)',
        'description': 'Fungal disease causing white powdery coating on leaves and stems',
        'symptoms': ['White/gray powdery coating', 'Primarily on upper leaf surface', 'Leaf distortion and curling', 'Yellowing and premature drop', 'Reduced photosynthesis'],
        'causes': ['Leveillula fungus', 'Moderate humidity (40-70%)', 'Temperature 15-27°C', 'Dense canopy', 'Poor air circulation'],
        'severity': 'Medium',
        'treatments': [
            {
                'type': 'Fungicide',
                'name': 'Sulfur powder',
                'description': 'Dust or spray 80% Sulfur WP (3g/liter) every 7-10 days',
                'dosage': '3g per liter',
                'frequency': 'Every 7-10 days'
            },
            {
                'type': 'Fungicide',
                'name': 'Hexaconazole',
                'description': 'Spray Hexaconazole 5% EC (2ml/liter) for severe infections',
                'dosage': '2ml per liter',
                'frequency': 'Every 10-12 days'
            },
            {
                'type': 'Organic',
                'name': 'Milk spray',
                'description': 'Spray diluted milk (1:10 milk:water) as organic treatment',
                'dosage': '100ml milk in 1 liter water',
                'frequency': 'Every 7 days'
            },
            {
                'type': 'Fungicide',
                'name': 'Tebuconazole',
                'description': 'Spray Tebuconazole 25% WG (0.5ml/liter)',
                'dosage': '0.5ml per liter',
                'frequency': 'Every 10 days'
            }
        ],
        'recommendations': [
            'Improve air circulation by proper spacing and pruning',
            'Reduce relative humidity through ventilation',
            'Apply sulfur dust preventively during cool weather',
            'Remove heavily infected leaves',
            'Avoid excessive nitrogen fertilization',
            'Water early morning (avoid evening watering)',
            'Apply fungicide at first sign of disease',
            'Maintain optimal temperature (25-30°C)'
        ]
    }
}

# """
# DELIVERABLE 2: DISEASE METADATA
# [KEEPING EXACTLY AS BEFORE - 6 disease classes with full details]
# Not modified in this update
# """

# DISEASE_CLASSES = {
#     0: {
#         "name": "Bacterial Spot",
#         "name_hi": "जीवाणु धब्बा",
#         "scientific_name": "Xanthomonas campestris pv. vesicatoria",
#         "scientific_name_hi": "जैंथोमोनास कैम्पेस्ट्रिस",
#         "description": "Bacterial infection causing necrotic spots on leaves and fruits. Transmitted through water, contaminated tools, and seed.",
#         "description_hi": "जीवाणु संक्रमण जो पत्तियों और फलों पर धब्बे पैदा करता है। पानी और संक्रमित बीजों से फैलता है।",
#         "symptoms": [
#             "Small water-soaked lesions (2-5mm) with greasy appearance",
#             "Brown/black spots with bright yellow halos (3-10mm)",
#             "Lesions on both sides of leaves",
#             "Leaf yellowing around lesions",
#             "Premature leaf defoliation",
#             "Fruit lesions appear raised and corky",
#             "Defoliation reduces yield by 20-40%"
#         ],
#         "symptoms_hi": [
#             "छोटे जल-भिगोए हुए घाव (2-5 मिमी)",
#             "पीले प्रभामंडल के साथ भूरे/काले धब्बे",
#             "पत्तियों की समय से पहले गिरना",
#             "फलों पर उठे हुए घाव"
#         ],
#         "causes": [
#             "Xanthomonas bacteria from contaminated seeds/soil",
#             "Warm (20-30°C) and humid conditions (>80%)",
#             "Overhead irrigation (water splash)",
#             "Poor air circulation",
#             "Contaminated pruning tools"
#         ],
#         "severity": "High (can cause 20-40% yield loss)",
#         "severity_score": 8,
#         "onset_period": "30-45 days after transplanting (during rainy season)",
#         "treatments": [
#             {
#                 "type": "Cultural",
#                 "name": "Field Sanitation",
#                 "name_hi": "खेत की सफाई",
#                 "description": "Remove infected leaves/fruits immediately. Burn or bury deep in soil. Do not compost.",
#                 "description_hi": "संक्रमित पत्तियों को तुरंत निकालें और जला दें।",
#                 "dosage": "N/A",
#                 "frequency": "Weekly scouting, remove immediately upon detection",
#                 "timeline": "Throughout growing season",
#                 "cost_estimate": "₹300-500 (labor)"
#             },
#             {
#                 "type": "Chemical",
#                 "name": "Copper Oxychloride",
#                 "name_hi": "कॉपर ऑक्सीक्लोराइड",
#                 "description": "Protectant bactericide. Spray 1% Bordeaux mixture or Copper Oxychloride 3g/liter. Apply preventively during rainy season.",
#                 "description_hi": "कॉपर ऑक्सीक्लोराइड 3 ग्राम/लीटर पानी में मिलाकर छिड़काव करें।",
#                 "dosage": "3 g/liter water (or 1% Bordeaux mixture)",
#                 "frequency": "Every 7-10 days during high humidity (>80%)",
#                 "timeline": "Start from 30 DAT, intensify during monsoon",
#                 "cost_estimate": "₹700-1,200/hectare"
#             },
#             {
#                 "type": "Antibiotic (Curative)",
#                 "name": "Streptocycline + Copper Oxychloride",
#                 "name_hi": "स्ट्रेप्टोसाइक्लिन + कॉपर ऑक्सीक्लोराइड",
#                 "description": "Use when infection detected. Streptocycline targets bacteria, copper provides broad protection. Alternate with copper to prevent resistance.",
#                 "description_hi": "संक्रमण दिखाई देने पर तुरंत स्ट्रेप्टोसाइक्लिन लगाएं।",
#                 "dosage": "Streptocycline 0.5g/liter + Copper Oxychloride 3g/liter",
#                 "frequency": "Every 10 days for 3-4 sprays",
#                 "timeline": "Apply upon first detection",
#                 "cost_estimate": "₹800-1,400/hectare"
#             },
#             {
#                 "type": "Biological",
#                 "name": "Bacillus subtilis + Pseudomonas fluorescens",
#                 "name_hi": "जैविक नियंत्रण",
#                 "description": "Bio-agents compete with bacteria and produce antibiotics. Apply as preventive sprays.",
#                 "description_hi": "जैविक कीटनाशक बैक्टीरिया से लड़ते हैं।",
#                 "dosage": "10 ml/liter water (each bioagent)",
#                 "frequency": "Every 7 days preventively, every 5-7 days if infected",
#                 "timeline": "Start from 30 DAT",
#                 "cost_estimate": "₹600-900/hectare"
#             }
#         ],
#         "recommendations": [
#             "Use disease-free certified seeds",
#             "Maintain field spacing 60×45 cm for air circulation",
#             "Use drip irrigation - NEVER overhead watering",
#             "Remove lower leaves (first 15 cm) for better air flow",
#             "Sterilize pruning tools with 1% bleach solution",
#             "Apply copper spray preventively during monsoon (June-Sept)",
#             "Crop rotation with non-host crops (2 years)",
#             "Destroy crop residue after harvest",
#             "Maintain field hygiene - remove weeds",
#             "Monitor plants weekly for early detection"
#         ],
#         "control_efficacy": "Copper oxychloride: 60-70% | Streptocycline: 65-75% | Cultural: 40-50%",
#         "economic_threshold": "5% leaf area affected - start treatment",
#         "cost_estimate": "₹700-1,400/hectare"
#     },

#     1: {
#         "name": "Chilli Leaf Curl Virus",
#         "name_hi": "मिर्च पत्ती कर्ल वायरस",
#         "scientific_name": "Begomovirus (Chilli Leaf Curl Virus - CLCV)",
#         "scientific_name_hi": "बेगोमोवायरस",
#         "description": "Viral disease transmitted by whiteflies. First reported in India in 2006. Causes significant yield reduction (30-80%).",
#         "description_hi": "वाइट फ्लाई द्वारा प्रेषित वायरस रोग। 2006 में भारत में पहली बार रिपोर्ट किया गया।",
#         "symptoms": [
#             "Upward curling of leaf margins toward midrib",
#             "Leaf distortion and severe deformation",
#             "Shortened internodes leading to stunted growth",
#             "Reduced leaf size (30-50% smaller)",
#             "Pale yellow discoloration of leaves",
#             "Flower buds drop (abscission)",
#             "Poor pollen viability - no fruit set",
#             "Plant height reduced by 50-60%",
#             "Complete crop loss in severe cases"
#         ],
#         "symptoms_hi": [
#             "पत्तियों की ऊपर की ओर कर्लिंग",
#             "पत्तियां विकृत और छोटी हो जाती हैं",
#             "पौधों की रोकथाम",
#             "पीले रंग की पत्तियां"
#         ],
#         "causes": [
#             "Begomovirus transmitted by Bemisia tabaci (whitefly)",
#             "Whitefly presence >10 insects per leaf indicates high risk",
#             "Seed transmission rate: 0-5% (some sources)",
#             "Persistent, semi-persistent virus",
#             "Warm conditions (>25°C) favor whitefly multiplication",
#             "No curative treatment available - preventive only"
#         ],
#         "severity": "Very High (can cause 50-80% crop loss)",
#         "severity_score": 9,
#         "onset_period": "2-3 weeks after whitefly infestation",
#         "treatments": [
#             {
#                 "type": "Cultural/Preventive",
#                 "name": "Whitefly Vector Control",
#                 "name_hi": "वाइट फ्लाई नियंत्रण",
#                 "description": "Eliminate whitefly vector. Install yellow sticky traps to monitor and trap adults. Use reflective mulch to confuse insects.",
#                 "description_hi": "पीले चिपचिपे ट्रैप लगाएं। चांदी की पन्नी की गीली घास का उपयोग करें।",
#                 "dosage": "1 yellow trap per 100 sq m | Silver-coated plastic mulch (45-60 micron)",
#                 "frequency": "Place traps from 15 DAT onwards, monitor bi-weekly",
#                 "timeline": "Throughout season, especially during June-October",
#                 "cost_estimate": "₹1,000-1,500/hectare"
#             },
#             {
#                 "type": "Chemical (Insecticide)",
#                 "name": "Imidacloprid (Systemic) + Diafenthiuron (Contact)",
#                 "name_hi": "इमिडाक्लोप्रिड + डायफेंथियुरॉन",
#                 "description": "Systemic insecticide penetrates plant tissues, killing nymphs inside. Diafenthiuron is contact killer for adults. Rotate to prevent resistance.",
#                 "description_hi": "प्रणालीगत कीटनाशक जो पत्तियों में प्रवेश करता है।",
#                 "dosage": "Imidacloprid 17.8% SL: 17.5 ml/10 liters | Diafenthiuron 50% WP: 1 g/liter",
#                 "frequency": "Alternate - Week 1: Imidacloprid, Week 3: Diafenthiuron, Week 5: Imidacloprid",
#                 "timeline": "Start from 15 DAT, continue every 2 weeks",
#                 "cost_estimate": "₹900-1,400/hectare"
#             },
#             {
#                 "type": "Bio-pesticide",
#                 "name": "Neem Oil Extract + Imidacloprid",
#                 "name_hi": "नीम का तेल + इमिडाक्लोप्रिड",
#                 "description": "Neem oil disrupts whitefly reproduction and feeding. Less toxic than chemical insecticide.",
#                 "description_hi": "नीम का तेल वाइट फ्लाई प्रजनन को बाधित करता है।",
#                 "dosage": "Neem oil 5%: 5 ml/liter water | Add imidacloprid for quick knockdown",
#                 "frequency": "Every 7 days from 15 DAT",
#                 "timeline": "Entire growing season",
#                 "cost_estimate": "₹700-1,000/hectare"
#             },
#             {
#                 "type": "Viral Protective Spray",
#                 "name": "Salicylic Acid-based Viricide",
#                 "name_hi": "वायरस सुरक्षा स्प्रे",
#                 "description": "Does not kill virus but triggers plant's own immunity. Recommended product: Katyayani Antivirus or similar.",
#                 "description_hi": "पौधे की अपनी रक्षा को सक्रिय करता है।",
#                 "dosage": "2 ml/liter water",
#                 "frequency": "Every 7-10 days from 20 DAT",
#                 "timeline": "Preventive only, must be applied before infection",
#                 "cost_estimate": "₹800-1,200/hectare"
#             }
#         ],
#         "recommendations": [
#             "Use disease-free, certified seeds from authorized sources",
#             "Avoid monoculture - rotate crops annually",
#             "Grow border crops (sunflower, marigold) to trap whiteflies",
#             "Plant nursery under nylon netting to prevent whitefly entry",
#             "Destroy infected plants completely (burn or deep bury)",
#             "Install yellow sticky traps from 15 DAT",
#             "Apply silver-coated mulch (reflective) to confuse whiteflies",
#             "Spray insecticides weekly during June-Oct (high whitefly season)",
#             "Maintain field hygiene - remove weeds harboring whiteflies",
#             "Avoid planting near contaminated fields",
#             "Isolate infected plants immediately",
#             "Monitor whitefly population - spray when >5 insects per leaf"
#         ],
#         "control_efficacy": "Whitefly control: 70-80% | Insecticides prevent spread: 60-70%",
#         "economic_threshold": ">5 whiteflies per leaf - immediate insecticide application",
#         "preventive_success_rate": "95% if whitefly controlled before 20 DAT",
#         "cost_estimate": "₹1,200-1,800/hectare (for prevention)"
#     },

#     2: {
#         "name": "Cercospora Leaf Spot (Frog Eye)",
#         "name_hi": "सर्कोस्पोरा पत्ती धब्बा",
#         "scientific_name": "Cercospora capsici",
#         "scientific_name_hi": "सर्कोस्पोरा कैप्सिसी",
#         "description": "Fungal disease causing circular spots resembling frog eyes. Severe in humid regions of India (NE, coastal areas).",
#         "description_hi": "कवक रोग जो गोल धब्बे बनाता है। नम क्षेत्रों में गंभीर।",
#         "symptoms": [
#             "Small circular spots (3-5mm) on leaves",
#             "Brown concentric rings with gray center (frog-eye appearance)",
#             "Yellow halo around lesions (characteristic)",
#             "Spots coalesce and merge with age",
#             "Central portion of lesion drops out ('shot-hole' appearance)",
#             "Affected leaves turn yellow and drop prematurely",
#             "Can affect stems and fruits in severe infections",
#             "Defoliation reduces photosynthesis and yield by 30-50%"
#         ],
#         "symptoms_hi": [
#             "पत्तियों पर गोल भूरे धब्बे",
#             "धब्बों के चारों ओर पीले रंग का प्रभामंडल",
#             "धब्बे बड़े होकर मिल जाते हैं",
#             "पत्तियां पीली पड़कर गिरती हैं"
#         ],
#         "causes": [
#             "High humidity (>80% RH) and warm temperature (25-28°C)",
#             "Excessive irrigation/overhead watering",
#             "Poor air circulation in dense canopy",
#             "Nitrogen deficiency increases susceptibility",
#             "Fungal spores spread through water splash",
#             "Favored during monsoon season (June-Sept)"
#         ],
#         "severity": "Medium-High (can cause 20-50% yield loss)",
#         "severity_score": 6,
#         "onset_period": "30-45 days after transplanting",
#         "treatments": [
#             {
#                 "type": "Cultural",
#                 "name": "Air Circulation & Pruning",
#                 "name_hi": "हवा का संचार",
#                 "description": "Remove lower leaves (15cm height), dense foliage. Maintain spacing 60×45cm. Switch to drip irrigation.",
#                 "description_hi": "निचली पत्तियों को निकालें। ड्रिप सिंचाई का उपयोग करें।",
#                 "dosage": "N/A",
#                 "frequency": "Continuous maintenance during growing season",
#                 "timeline": "Implement immediately after transplanting",
#                 "cost_estimate": "₹400-600/hectare"
#             },
#             {
#                 "type": "Chemical (Preventive)",
#                 "name": "Mancozeb (broad-spectrum)",
#                 "name_hi": "मैंकोजेब",
#                 "description": "Multi-site fungicide. Protects against Cercospora. Apply preventively during high humidity.",
#                 "description_hi": "व्यापक स्पेक्ट्रम कवकनाशी। उच्च आर्द्रता के दौरान निवारक रूप से लगाएं।",
#                 "dosage": "2 g/liter water (75% WP formulation)",
#                 "frequency": "Every 7-10 days during monsoon",
#                 "timeline": "Start from 30 DAT, critical June-Sept",
#                 "cost_estimate": "₹600-900/hectare"
#             },
#             {
#                 "type": "Chemical (Curative)",
#                 "name": "Azoxystrobin + Tebuconazole",
#                 "name_hi": "एज़ॉक्सीस्ट्रोबिन + टेबुकोनाज़ोल",
#                 "description": "Strobilurin + Triazole combination. Highly effective - 64.69% disease control with 1650 kg/ha yield.",
#                 "description_hi": "संयोजित कवकनाशी - अधिक प्रभावी।",
#                 "dosage": "1 ml/liter water (1.5 ml if severe)",
#                 "frequency": "Double spray (10 days apart) at first sign of infection",
#                 "timeline": "Upon detection of symptoms",
#                 "cost_estimate": "₹800-1,200/hectare"
#             },
#             {
#                 "type": "Alternative",
#                 "name": "Carbendazim + Mancozeb",
#                 "name_hi": "कार्बेंडाजिम + मैंकोजेब",
#                 "description": "Systemic + contact combination. Good results: 60-65% control.",
#                 "description_hi": "प्रणालीगत और संपर्क कवकनाशी का मिश्रण।",
#                 "dosage": "300-400 g/acre (12% + 63% WP)",
#                 "frequency": "Every 7-10 days",
#                 "timeline": "During monsoon season",
#                 "cost_estimate": "₹700-1,000/hectare"
#             }
#         ],
#         "recommendations": [
#             "Maintain field spacing 60×45 cm minimum",
#             "Use drip irrigation - avoid overhead watering",
#             "Remove lower leaves up to 15-20 cm height",
#             "Reduce nitrogen fertilizer in humid season (increases susceptibility)",
#             "Destroy infected leaves immediately",
#             "Avoid working in field when wet (spreads spores)",
#             "Alternate fungicides to prevent resistance",
#             "Apply Mancozeb preventively every 7-10 days during June-Sept",
#             "Use Azoxystrobin + Tebuconazole for severe outbreaks",
#             "Ensure good drainage and avoid water stagnation",
#             "Mulch to keep leaves dry",
#             "Monitor field weekly during high humidity"
#         ],
#         "control_efficacy": "Azoxystrobin+Tebuconazole (double spray): 64.69% | Carbendazim+Mancozeb: 60-65%",
#         "economic_threshold": "10% leaf area affected or 5% defoliation - start treatment",
#         "cost_estimate": "₹700-1,400/hectare"
#     },

#     3: {
#         "name": "Nutritional Deficiency",
#         "name_hi": "पोषण कमी",
#         "scientific_name": "Multiple nutrient deficiencies (N, P, K, Zn, B, Mg)",
#         "scientific_name_hi": "विभिन्न पोषक तत्वों की कमी",
#         "description": "Visible symptoms when soil/plant nutrient levels fall below critical thresholds. Affects growth, flowering, and fruit quality.",
#         "description_hi": "जब मिट्टी में पोषक तत्व कम हों तो पत्तियों में लक्षण दिखाई देते हैं।",
#         "symptoms": [
#             "Nitrogen deficiency: Older leaves turn light green/yellow, stunted growth",
#             "Phosphorus deficiency: Purple/pinkish leaf margins, poor branching, delayed flowering",
#             "Potassium deficiency: Marginal scorching (brown edges), reduced fruit size",
#             "Zinc deficiency: Interveinal chlorosis on young leaves (yellow between veins)",
#             "Boron deficiency: Distorted flowers, no fruit set, hollow fruits",
#             "Magnesium deficiency: Interveinal yellowing of older leaves",
#             "General: Stunted growth, poor root development, reduced yield"
#         ],
#         "symptoms_hi": [
#             "नाइट्रोजन की कमी: पुरानी पत्तियां पीली हो जाती हैं",
#             "फॉस्फोरस की कमी: बैंगनी रंग की पत्तियां",
#             "पोटेशियम की कमी: पत्तियों के किनारे भूरे हो जाते हैं",
#             "जस्ता की कमी: पत्तियों में पीलापन"
#         ],
#         "causes": [
#             "Inadequate fertilizer application",
#             "Soil pH outside optimal range (6.5-7.5) reducing nutrient availability",
#             "Poor drainage leading to nutrient leaching",
#             "Excessive rainfall/irrigation",
#             "Acidic soil (<5.5 pH) reducing availability of P, K",
#             "Alkaline soil (>7.5 pH) reducing availability of Zn, Fe, Mn",
#             "Single nutrient fertilizers (unbalanced nutrition)"
#         ],
#         "severity": "Medium (yields reduced by 20-40%)",
#         "severity_score": 5,
#         "onset_period": "Visible 30-45 days after transplanting if nutrients depleted",
#         "treatments": [
#             {
#                 "type": "Soil Correction",
#                 "name": "Soil Testing + Corrective Fertilization",
#                 "name_hi": "मिट्टी परीक्षण और सुधार",
#                 "description": "Get soil tested for NPK, pH, micronutrients. Apply targeted fertilizers based on results.",
#                 "description_hi": "मिट्टी की जांच करें। परिणाम के आधार पर खाद लगाएं।",
#                 "dosage": "Per soil test recommendations. Standard: N: 100-120 kg/ha, P: 60-80 kg/ha, K: 50-80 kg/ha",
#                 "frequency": "Once at season start based on test results",
#                 "timeline": "Before sowing/transplanting",
#                 "cost_estimate": "₹500 (soil test) + ₹2,000-3,000 (fertilizers)"
#             },
#             {
#                 "type": "Basal Dressing",
#                 "name": "Balanced Fertilizer at Planting",
#                 "name_hi": "बुवाई के समय संतुलित खाद",
#                 "description": "Apply 25 tons/ha FYM + NPK 30:60:30 kg/ha for local varieties or 30:80:80 for hybrids.",
#                 "description_hi": "रोपण के समय संतुलित खाद लगाएं।",
#                 "dosage": "FYM: 25-30 tons/ha | NPK: 30:60:30 kg/ha (local) or 30:80:80 (hybrid)",
#                 "frequency": "Once, mix with soil during final ploughing",
#                 "timeline": "Before planting",
#                 "cost_estimate": "₹3,000-5,000/hectare"
#             },
#             {
#                 "type": "Top Dressing",
#                 "name": "Urea Application in Splits",
#                 "name_hi": "यूरिया का विभाजित अनुप्रयोग",
#                 "description": "Apply nitrogen in 4 splits (sowing + 30, 60, 90 DAT) for sustained nutrition.",
#                 "description_hi": "चार भागों में यूरिया डालें (बुवाई + 30, 60, 90 दिन बाद)।",
#                 "dosage": "26 kg N at each stage = 104 kg total for hybrid (divided into urea splits)",
#                 "frequency": "At 0, 30, 60, 90 days after transplanting",
#                 "timeline": "Throughout growing season",
#                 "cost_estimate": "₹1,500-2,000/hectare"
#             },
#             {
#                 "type": "Foliar Spray",
#                 "name": "Micronutrient Complex Spray",
#                 "name_hi": "सूक्ष्म पोषक तत्व स्प्रे",
#                 "description": "Rapid absorption through leaves. For Zn, B deficiency - spray from 40 DAT onwards.",
#                 "description_hi": "पत्तियों के माध्यम से तेजी से अवशोषण। 40 दिन के बाद स्प्रे करें।",
#                 "dosage": "Zinc: 0.5-0.6 g/liter | Boron: 1 g/liter | 19:19:19 NPK: 1 g/liter",
#                 "frequency": "3 sprays with 10-day intervals starting 40 DAT",
#                 "timeline": "40-90 DAT (vegetative and flowering stages)",
#                 "cost_estimate": "₹600-900/hectare"
#             },
#             {
#                 "type": "pH Correction",
#                 "name": "Soil pH Amendment",
#                 "name_hi": "मिट्टी pH सुधार",
#                 "description": "If pH < 5.5: Apply lime (2-3 tons/ha). If pH > 7.5: Apply sulfur (500-800 kg/ha).",
#                 "description_hi": "अगर pH कम है तो चूना, अगर अधिक है तो गंधक लगाएं।",
#                 "dosage": "Per soil pH test recommendation",
#                 "frequency": "Once per season if needed",
#                 "timeline": "Before planting",
#                 "cost_estimate": "₹3,000-5,000/hectare"
#             }
#         ],
#         "recommendations": [
#             "Conduct soil testing before sowing - CRITICAL",
#             "Apply 25-30 tons/ha FYM (farm yard manure) for organic matter",
#             "Use balanced NPK fertilizers - not single nutrients",
#             "For hybrids: Apply 30:80:80 kg/ha NPK (higher P and K)",
#             "For local varieties: Apply 30:60:30 kg/ha NPK",
#             "Split nitrogen application in 4 equal parts (0, 30, 60, 90 DAT)",
#             "Monitor leaf color - early detection is key",
#             "Spray Zn (0.5 g/L) and B (1 g/L) from 40 DAT onwards",
#             "Correct soil pH to 6.5-7.5 - prevents many deficiencies",
#             "Use drip irrigation for efficient nutrient delivery",
#             "Apply bio-fertilizers (Azospirillum, Phosphobacteria) 1L + 50kg FYM",
#             "Avoid excessive nitrogen - causes vegetative growth at expense of fruiting"
#         ],
#         "control_efficacy": "Soil test guided approach: 85-95% prevention | Corrective foliar spray: 70-80%",
#         "economic_threshold": "Visible symptoms on >20% plants - start corrective action",
#         "cost_estimate": "₹2,500-4,000/hectare (preventive nutrition plan)"
#     },

#     4: {
#         "name": "White Spot Disease",
#         "name_hi": "सफेद धब्बा रोग",
#         "scientific_name": "Likely Alternaria species or Phomopsis species (secondary fungus)",
#         "scientific_name_hi": "अल्टरनेरिया या फोमोप्सिस प्रजाति",
#         "description": "Fungal disease causing white/light colored spots on leaves. Less common than Cercospora but damaging in specific conditions.",
#         "description_hi": "पत्तियों पर सफेद धब्बे पैदा करने वाला कवक रोग।",
#         "symptoms": [
#             "Small white or light cream-colored spots (2-4mm) on leaves",
#             "Spots have darker concentric rings or borders",
#             "Spotting appears on leaf surface, sometimes on stems",
#             "Spots may merge and coalesce in severe infections",
#             "Affected tissue becomes papery and may crack",
#             "In severe cases: Leaf yellowing and premature drop",
#             "Can affect fruit - white lesions with dark center",
#             "Development accelerated by overhead irrigation"
#         ],
#         "symptoms_hi": [
#             "पत्तियों पर सफेद गोल धब्बे",
#             "धब्बों के चारों ओर गहरे रंग की सीमा",
#             "गंभीर संक्रमण में पत्तियां पीली हो जाती हैं",
#             "फलों पर भी धब्बे दिख सकते हैं"
#         ],
#         "causes": [
#             "High humidity (>75%) and temperature (25-28°C)",
#             "Water-logged conditions from excessive irrigation",
#             "Overhead or flood irrigation spreading spores",
#             "Poor air circulation in dense canopy",
#             "Weak plants with low vigor susceptible",
#             "Fungal spores from soil/crop residue",
#             "More prevalent in coastal/high rainfall areas"
#         ],
#         "severity": "Low-Medium (yields reduced by 10-30%)",
#         "severity_score": 4,
#         "onset_period": "40-60 days after transplanting",
#         "treatments": [
#             {
#                 "type": "Cultural",
#                 "name": "Moisture Management",
#                 "name_hi": "नमी प्रबंधन",
#                 "description": "Switch to drip irrigation immediately. Remove lower leaves for air circulation. Avoid working in wet field.",
#                 "description_hi": "ड्रिप सिंचाई का उपयोग करें। नमी नियंत्रित करें।",
#                 "dosage": "N/A",
#                 "frequency": "Daily inspection and preventive actions",
#                 "timeline": "Throughout season",
#                 "cost_estimate": "₹300-500/hectare"
#             },
#             {
#                 "type": "Chemical (Preventive)",
#                 "name": "Mancozeb or Chlorothalonil",
#                 "name_hi": "मैंकोजेब या क्लोरोथलोनिल",
#                 "description": "Broad-spectrum contact fungicide. Use preventively during high humidity periods.",
#                 "description_hi": "व्यापक स्पेक्ट्रम कवकनाशी। उच्च आर्द्रता के दौरान लगाएं।",
#                 "dosage": "Mancozeb: 2 g/liter | Chlorothalonil: 2.5 g/liter",
#                 "frequency": "Every 7-10 days during wet season",
#                 "timeline": "June-September (monsoon)",
#                 "cost_estimate": "₹600-900/hectare"
#             },
#             {
#                 "type": "Chemical (Curative)",
#                 "name": "Carbendazim + Mancozeb",
#                 "name_hi": "कार्बेंडाजिम + मैंकोजेब",
#                 "description": "Systemic + contact combination for active infection. More effective than single product.",
#                 "description_hi": "संयोजित कवकनाशी अधिक प्रभावी है।",
#                 "dosage": "300-400 g/acre (12% + 63% WP combination)",
#                 "frequency": "Every 7 days when infection detected",
#                 "timeline": "Upon symptom appearance",
#                 "cost_estimate": "₹700-1,000/hectare"
#             },
#             {
#                 "type": "Biological",
#                 "name": "Trichoderma viride",
#                 "name_hi": "ट्राइकोडर्मा विराइड",
#                 "description": "Bioagent spray - antagonistic to fungal pathogens. Preventive application.",
#                 "description_hi": "जैविक कवकनाशी - रोग-पैदा करने वाले कवक के विरुद्ध।",
#                 "dosage": "10 ml/liter water",
#                 "frequency": "Every 7 days preventively, every 5 days if infection present",
#                 "timeline": "From 30 DAT onwards",
#                 "cost_estimate": "₹500-800/hectare"
#             }
#         ],
#         "recommendations": [
#             "Use drip irrigation - NEVER overhead irrigation",
#             "Maintain field spacing 60×45 cm for good air circulation",
#             "Remove lower leaves (15cm) weekly",
#             "Do NOT work in field when plants are wet",
#             "Spray preventive fungicide every 7-10 days during June-Sept",
#             "Keep field weed-free to improve air flow",
#             "Avoid excessive nitrogen fertilizer",
#             "Destroy infected leaves immediately",
#             "Apply mulch to keep soil moist but prevent leaf wetness",
#             "Monitor field 2-3 times per week",
#             "Use resistant varieties if available",
#             "Maintain good plant health through balanced nutrition"
#         ],
#         "control_efficacy": "Mancozeb (preventive): 60-70% | Carbendazim+Mancozeb (curative): 70-75%",
#         "economic_threshold": "15% leaf area affected - start treatment",
#         "cost_estimate": "₹600-1,000/hectare"
#     },

#     5: {
#         "name": "Healthy Leaf",
#         "name_hi": "स्वस्थ पत्ती",
#         "scientific_name": "Capsicum annuum - Normal",
#         "scientific_name_hi": "सामान्य और स्वस्थ पत्ती",
#         "description": "Plant showing no signs of disease, nutritional deficiency, or pest damage. Green, vibrant foliage indicates good health.",
#         "description_hi": "बिना किसी रोग के स्वस्थ पत्ती। हरी, जीवंत पत्ती पौधे की अच्छी स्वास्थ्य को दर्शाती है।",
#         "symptoms": [
#             "Uniform green leaf color (no yellowing)",
#             "Leaf margins intact (no browning/scorching)",
#             "Veins clearly visible and green",
#             "Leaf size appropriate for plant age",
#             "No spots, lesions, or discoloration",
#             "No visible pest damage",
#             "Plant vigor excellent",
#             "Flowers abundant with good fruit set"
#         ],
#         "symptoms_hi": [
#             "समान हरा रंग, कोई पीलापन नहीं",
#             "पत्तियों की किनारें सुरक्षित",
#             "कोई धब्बे या रंग परिवर्तन नहीं",
#             "कोई कीट क्षति नहीं"
#         ],
#         "causes": [
#             "Optimal soil health (pH 6.5-7.5)",
#             "Balanced NPK nutrition",
#             "Adequate moisture (60-70%)",
#             "Good air circulation",
#             "Proper plant spacing",
#             "Absence of diseases and pests",
#             "Suitable temperature (20-25°C)"
#         ],
#         "severity": "None - Healthy plant",
#         "severity_score": 0,
#         "onset_period": "N/A",
#         "treatments": [
#             {
#                 "type": "Maintenance",
#                 "name": "Regular Monitoring & Prevention",
#                 "name_hi": "नियमित निरीक्षण और रोकथाम",
#                 "description": "Continue with preventive practices to maintain health. Scout field weekly for early disease detection.",
#                 "description_hi": "स्वास्थ्य बनाए रखने के लिए निवारक उपाय करते रहें।",
#                 "dosage": "N/A",
#                 "frequency": "Weekly field inspection",
#                 "timeline": "Throughout growing season",
#                 "cost_estimate": "₹200/hectare (labor)"
#             },
#             {
#                 "type": "Fertilizer Management",
#                 "name": "Continue Scheduled Nutrition",
#                 "name_hi": "पोषण योजना जारी रखें",
#                 "description": "Follow original fertilizer schedule (top dressing at 30, 60, 90 DAT). Maintain balanced nutrition.",
#                 "description_hi": "निर्धारित खाद का कार्यक्रम जारी रखें।",
#                 "dosage": "Per original nutrition plan for hybrid/local varieties",
#                 "frequency": "As per predetermined schedule",
#                 "timeline": "Entire growing season",
#                 "cost_estimate": "₹2,000-3,000/hectare"
#             },
#             {
#                 "type": "Preventive Spray",
#                 "name": "Alternating Preventive Sprays",
#                 "name_hi": "निवारक स्प्रे",
#                 "description": "Apply preventive fungicide sprays during high-risk periods (monsoon June-Sept) to prevent disease outbreak.",
#                 "description_hi": "मानसून के दौरान निवारक स्प्रे लगाएं।",
#                 "dosage": "Mancozeb 2 g/L OR Neem oil 5 ml/L (alternate weekly)",
#                 "frequency": "Every 10-14 days during June-Sept",
#                 "timeline": "High-risk monsoon season",
#                 "cost_estimate": "₹400-600/hectare"
#             }
#         ],
#         "recommendations": [
#             "Maintain current cultural practices - spacing, irrigation, pruning",
#             "Continue scheduled fertilizer applications",
#             "Scout field every 7 days to detect early disease signs",
#             "Apply preventive sprays during high humidity months (June-Sept)",
#             "Ensure proper drainage to prevent waterlogging",
#             "Maintain field hygiene - remove dead leaves/plants",
#             "Keep tools sterilized (1% bleach solution)",
#             "Use drip irrigation consistently",
#             "Do not skip any scheduled tasks",
#             "Monitor weather - increase vigilance during prolonged rains",
#             "Continue insect monitoring (especially whiteflies)",
#             "Plan crop rotation for next season to break pest cycles"
#         ],
#         "control_efficacy": "Maintenance: 100% (prevention of disease)",
#         "economic_threshold": "N/A - Continue preventive practices",
#         "expected_yield": "25-30 tons/hectare (healthy crop)",
#         "cost_estimate": "₹2,500-3,500/hectare (maintenance + prevention)"
#     }
# }


def get_disease_by_class(class_id: int) -> dict:
    """Get disease info by class ID (0-5)"""
    return DISEASE_CLASSES.get(class_id, {})

def get_disease_by_name(disease_name: str) -> dict:
    """Get disease info by name"""
    for disease_info in DISEASE_CLASSES.values():
        if disease_info['name'].lower() == disease_name.lower():
            return disease_info
    return {}

def get_all_diseases() -> dict:
    """Get all disease info"""
    return DISEASE_CLASSES

def get_disease_names() -> list:
    """Get list of all disease names"""
    return [disease['name'] for disease in DISEASE_CLASSES.values()]
