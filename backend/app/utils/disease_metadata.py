"""
Disease metadata for 6 chilli disease classes
Based on model_info.json: Bacterial Spot, Cercospora, Curl Virus, Healthy, Nutrition Deficiency, White Spot
"""

DISEASE_CLASSES = {
0: {
        'name': 'Bacterial Spot (Pepper)',
        'scientific_name': 'Xanthomonas spp. (X. euvesicatoria / X. vesicatoria)',
        'description': 'Bacterial disease of chilli/pepper causing necrotic leaf and fruit spots, yellow halos and defoliation; important in Indian pepper-growing regions.',
        'symptoms': [
            'Small water-soaked lesions on leaves and fruits',
            'Brown/black circular spots often with yellow halos',
            'Leaf yellowing around lesions',
            'Premature defoliation and reduced fruit marketability'
        ],
        'causes': [
            'Xanthomonas species (seed- and splash-borne)',
            'Warm, humid weather and rain-splash dissemination',
            'Overhead irrigation and contaminated seeds/seedlings',
            'Poor field sanitation and volunteer hosts'
        ],
        'severity': 'High',
        'treatments': [
            {'type': 'Chemical', 'name': 'Copper oxychloride / Bordeaux mixture',
             'description': 'Copper sprays reduce surface inoculum; apply at label rates every 7–10 days during epidemic periods.',
             'dosage': 'Follow product label (typical: 2–3 g/L for formulations)',
             'frequency': 'Every 7–10 days'},
            {'type': 'Biocontrol', 'name': 'Bacillus / Pseudomonas bioagents',
             'description': 'Seed or foliar bioagents (Bacillus subtilis, Pseudomonas spp.) shown to antagonize Xanthomonas in Indian trials.',
             'dosage': 'Per product label',
             'frequency': 'As directed'},
            {'type': 'Cultural', 'name': 'Sanitation & seed health',
             'description': 'Use certified disease-free seed, remove infected plants, avoid overhead irrigation and reduce splash.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Use certified, disease-free seed and treat seed if needed',
            'Prefer drip irrigation; avoid overhead watering',
            'Maintain spacing & airflow; rogue infected plants',
            'Rotate non-host crops and sanitize tools'
        ],
        'sources': [
            ':contentReference[oaicite:0]{index=0}',  # ICAR characterization of Xanthomonas in India
            ':contentReference[oaicite:1]{index=1}'   # IJCMAS in vitro bioagent study (India)
        ]
    },

    1: {
        'name': 'Healthy (Pepper)',
        'scientific_name': 'Capsicum annuum (Healthy)',
        'description': 'No visible disease symptoms; normal vigour.',
        'symptoms': ['Uniform green leaves', 'No necrotic spots', 'Normal plant vigour'],
        'causes': ['Optimal nutrition', 'Proper irrigation', 'No pest presence'],
        'severity': 'None',
        'treatments': [],
        'recommendations': [
            'Maintain regular monitoring',
            'Use balanced fertilizers and proper irrigation',
            'Keep field and tools clean'
        ],
        'sources': []
    },

    2: {
        'name': 'Early Blight',
        'scientific_name': 'Alternaria solani',
        'description': 'Fungal disease causing concentric ring (target) lesions on tomato and potato leaves; significant yield losses reported in India.',
        'symptoms': [
            'Brown circular lesions with concentric rings on leaves',
            'Yellowing (chlorosis) around lesions',
            'Progressive defoliation under favourable conditions'
        ],
        'causes': [
            'Alternaria solani infection (spore-borne)',
            'Warm humid conditions and prolonged leaf wetness',
            'Nutrient stress (e.g., nitrogen deficiency) can exacerbate severity'
        ],
        'severity': 'High',
        'treatments': [
            {'type': 'Fungicide', 'name': 'Mancozeb',
             'description': 'Protectant fungicide commonly used in Indian tomato/potato programs.',
             'dosage': 'Typical: ~2–2.5 g/L (follow label)',
             'frequency': 'Every 7–14 days depending on pressure'},
            {'type': 'Fungicide', 'name': 'Azoxystrobin / QoI systemic',
             'description': 'Systemic option for severe outbreaks; rotate modes of action to reduce resistance.',
             'dosage': 'Per label',
             'frequency': 'As needed under high disease pressure'},
            {'type': 'Cultural', 'name': 'Crop hygiene & nutrition',
             'description': 'Remove infected foliage, improve aeration, ensure balanced fertilization.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Use drip irrigation / avoid overhead watering',
            'Remove infected leaves promptly',
            'Maintain balanced N fertilization; adopt resistant varieties where available'
        ],
        'sources': [
            ':contentReference[oaicite:2]{index=2}',  # Alternaria review mentioning Indian isolates
            ':contentReference[oaicite:3]{index=3}'   # Indian fungicide evaluation studies
        ]
    },

    3: {
        'name': 'Late Blight',
        'scientific_name': 'Phytophthora infestans',
        'description': 'Highly destructive oomycete disease of potato and tomato causing water-soaked lesions and rapid crop collapse; recurrent and serious in many Indian states.',
        'symptoms': [
            'Water-soaked dark lesions on leaves and stems',
            'White/grayish sporulation on leaf undersides in humid conditions',
            'Rapid leaf collapse and stem death under favourable conditions'
        ],
        'causes': [
            'Phytophthora infestans infection (sporangia, zoospores)',
            'Cool, humid weather, poor air circulation, waterlogging',
            'Volunteer potatoes and infected tubers acting as inoculum sources'
        ],
        'severity': 'Critical',
        'treatments': [
            {'type': 'Fungicide/Oomycide', 'name': 'Metalaxyl + Mancozeb (or other appropriate oomycides)',
             'description': 'Use labeled oomycide mixtures effective against P. infestans; integrate cultural controls.',
             'dosage': 'Per product label (example: 1.5–2 g/L depending on formulation)',
             'frequency': '7–10 days under epidemic conditions'},
            {'type': 'Cultural', 'name': 'Sanitation & resistant clones',
             'description': 'Destroy heavily infected plants/tubers, use certified seed tubers and adopt resistant varieties where available.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Avoid waterlogging and improve drainage',
            'Use certified seed/tubers; remove infected plants',
            'Monitor weather and apply protective sprays pre-emptively when conditions favour disease'
        ],
        'sources': [
            ':contentReference[oaicite:4]{index=4}',  # Late blight emergence and impact in South India
            ':contentReference[oaicite:5]{index=5}'   # Recent studies/reviews on potato late blight (India)
        ]
    },

    4: {
        'name': 'Healthy (Potato)',
        'scientific_name': 'Solanum tuberosum (Healthy)',
        'description': 'Healthy potato foliage with no disease symptoms.',
        'symptoms': ['Uniform green canopy', 'Healthy leaf texture'],
        'causes': ['Good nutrition', 'Optimal irrigation'],
        'severity': 'None',
        'treatments': [],
        'recommendations': ['Continue standard field management'],
        'sources': []
    },

    5: {
        'name': 'Bacterial Spot (Tomato)',
        'scientific_name': 'Xanthomonas vesicatoria / X. euvesicatoria',
        'description': 'Bacterial disease producing dark lesions with yellow halos on tomato leaves and fruits; reported from multiple Indian states.',
        'symptoms': ['Black leaf and fruit spots', 'Yellow halos around lesions', 'Fruit cracking or scabby lesions'],
        'causes': ['Xanthomonas spp., seed- and splash-borne', 'Warm wet weather, overhead irrigation, contaminated tools/seed'],
        'severity': 'High',
        'treatments': [
            {'type': 'Chemical', 'name': 'Copper-based bactericides',
             'description': 'Copper sprays are primary chemical control; apply preventatively and rotate with other IPM measures.',
             'dosage': 'Per label (typical copper oxychloride rates)',
             'frequency': 'Every 7–10 days in epidemic periods'},
            {'type': 'Cultural', 'name': 'Seed health & sanitation',
             'description': 'Use certified seed, treat seed where appropriate, remove infected plants and debris.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Adopt certified disease-free seed and seed treatments',
            'Avoid overhead irrigation; improve field sanitation',
            'Rotate crops and practice tool hygiene'
        ],
        'sources': [
            ':contentReference[oaicite:6]{index=6}',  # Review on bacterial spot in Himachal Pradesh (India)
            ':contentReference[oaicite:7]{index=7}'    # Prevalence study in Karnataka
        ]
    },

    6: {
        'name': 'Early Blight (Tomato)',
        'scientific_name': 'Alternaria solani',
        'description': 'Early blight on tomato produces concentric-ring lesions and can defoliate plants under favourable conditions; widely reported in India.',
        'symptoms': ['Brown rings on leaves, yellowing around spots, progressive defoliation'],
        'causes': ['Alternaria solani spores, warm humid weather, prolonged leaf wetness, poor nutrition'],
        'severity': 'High',
        'treatments': [
            {'type': 'Fungicide', 'name': 'Mancozeb / Chlorothalonil',
             'description': 'Protectant sprays commonly used in Indian tomato production.',
             'dosage': '~2 g/L (follow product label)',
             'frequency': 'Every 7–14 days depending on disease pressure'},
            {'type': 'Cultural', 'name': 'Varietal selection & hygiene',
             'description': 'Use moderately resistant varieties if available, remove infected residues and maintain nutrition.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Implement drip irrigation and avoid splash',
            'Timely removal of infected leaves and crop residues',
            'Balanced N fertilization and timely fungicide rotations'
        ],
        'sources': [
            ':contentReference[oaicite:8]{index=8}',  # Early blight control studies
            ':contentReference[oaicite:9]{index=9}'   # Indian fungicide evaluation
        ]
    },

    7: {
        'name': 'Late Blight (Tomato/Potato)',
        'scientific_name': 'Phytophthora infestans',
        'description': 'Rapid, destructive disease of potato and tomato reported across India; causes water-soaked lesions and sporulation under humid conditions.',
        'symptoms': ['Water-soaked lesions, white sporulation on undersides, rapid leaf collapse'],
        'causes': ['P. infestans sporangia/zoospores spread by wind/rain; cool humid conditions; infected tubers/volunteers'],
        'severity': 'Critical',
        'treatments': [
            {'type': 'Oomycide', 'name': 'Metalaxyl + Mancozeb / other oomycides',
             'description': 'Use effective oomycide mixtures and apply protectively based on weather forecasts.',
             'dosage': 'Per label',
             'frequency': '7–10 days under epidemic risk'},
            {'type': 'Cultural', 'name': 'Use certified seed & destroy infected plants',
             'description': 'Reduce inoculum sources and practice good crop hygiene.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Monitor weather; time sprays before wet, cool conditions',
            'Use certified seed tubers and remove volunteers',
            'Improve drainage and avoid waterlogging'
        ],
        'sources': [
            ':contentReference[oaicite:10]{index=10}',  # Recent outbreak/studies on late blight
            ':contentReference[oaicite:11]{index=11}'    # Late blight global review with India mentions
        ]
    },

    8: {
        'name': 'Leaf Mold (Tomato)',
        'scientific_name': 'Passalora fulva (syn. Cladosporium fulvum / Fulvia fulva)',
        'description': 'Leaf mold of tomato attacking foliage (often in humid tunnels/greenhouses) producing yellow patches above and olive-green fuzzy mold beneath.',
        'symptoms': ['Yellow patches on upper leaf surface', 'Olive-green fuzzy mould on leaf undersides', 'Reduced photosynthetic area'],
        'causes': ['Passalora fulva infection favored by high humidity and poor ventilation'],
        'severity': 'Medium',
        'treatments': [
            {'type': 'Fungicide', 'name': 'Copper or sulfur sprays / registered fungicides',
             'description': 'Apply as per local label and integrate with cultural controls.',
             'dosage': 'Per label (typical: 2 g/L for some formulations)',
             'frequency': 'Every 7–10 days when disease pressure exists'},
            {'type': 'Cultural', 'name': 'Ventilation & humidity control',
             'description': 'Improve greenhouse/tunnel ventilation, reduce leaf wetness and remove heavily infected leaves.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Increase ventilation in protected cultivation',
            'Avoid prolonged leaf wetness and over-fertilization',
            'Sanitize greenhouse structures and use disease-free transplants'
        ],
        'sources': [
            ':contentReference[oaicite:12]{index=12}',  # ISHS / distribution notes including India
            ':contentReference[oaicite:13]{index=13}'   # Identification study including Indian contexts
        ]
    },

    9: {
        'name': 'Septoria Leaf Spot',
        'scientific_name': 'Septoria lycopersici',
        'description': 'Fungal leaf spot of tomato producing small dark spots and chlorotic margins; can cause severe defoliation in Indian conditions with prolonged leaf wetness.',
        'symptoms': ['Small dark circular spots on leaves', 'Yellow/chlorotic edges', 'Progressive defoliation under conducive weather'],
        'causes': ['Septoria lycopersici spores, rain-splash dispersal, prolonged leaf wetness'],
        'severity': 'High',
        'treatments': [
            {'type': 'Fungicide', 'name': 'Chlorothalonil / Mancozeb / hexaconazole (where registered)',
             'description': 'Protectant fungicides have been effective in Indian field trials; follow label instructions.',
             'dosage': 'Per label',
             'frequency': 'Every 7–10 days during epidemic periods'},
            {'type': 'Cultural', 'name': 'Leaf removal & reduced splash',
             'description': 'Stake plants, improve spacing, remove infected debris to reduce inoculum.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Avoid overhead watering; stake and prune to reduce humidity',
            'Apply protectant fungicides based on disease forecasts and follow IPM principles',
            'Practice crop rotation and remove crop residues'
        ],
        'sources': [
            ':contentReference[oaicite:14]{index=14}',  # Indian IJCMAS/field reports on Septoria (India)
            ':contentReference[oaicite:15]{index=15}'   # ICAR guidance on cultural management (India)
        ]
    },

    10: {
        'name': 'Spider Mite Infestation',
        'scientific_name': 'Tetranychus urticae',
        'description': 'Acarine pest (two-spotted spider mite) causing stippling, bronzing and webbing on leaves; important in hot, dry Indian seasons and in protected cultivation.',
        'symptoms': ['Yellow stippling on leaves', 'Fine webbing on leaf undersides', 'Leaf bronzing and premature leaf drop'],
        'causes': ['High temperature and low humidity favor population explosions; lack of natural enemies and indiscriminate acaricide use'],
        'severity': 'Medium',
        'treatments': [
            {'type': 'Miticide', 'name': 'Abamectin / propargite / dicofol (registered options vary)',
             'description': 'Use selective acaricides according to label and resistance management guidelines.',
             'dosage': 'Per label (e.g., abamectin ~0.5 ml/L as commonly reported in trials)',
             'frequency': 'As per label and monitoring thresholds'},
            {'type': 'Biological', 'name': 'Predatory mites & biopesticides',
             'description': 'Conserve/augment predators (Phytoseiidae) and use plant-extracts/biopesticides in IPM.',
             'dosage': 'Per product guidance',
             'frequency': 'As required'}
        ],
        'recommendations': [
            'Monitor regularly; use action thresholds before spraying',
            'Encourage predatory mites and avoid broad-spectrum insecticides that kill beneficials',
            'Use cultural measures (leaf washing, maintain humidity) in protected cultivation'
        ],
        'sources': [
            ':contentReference[oaicite:16]{index=16}',  # Indian study on management of two-spotted spider mite
            ':contentReference[oaicite:17]{index=17}'   # Eco-friendly management publications (India)
        ]
    },

    11: {
        'name': 'Target Spot',
        'scientific_name': 'Corynespora cassiicola',
        'description': 'Fungal disease producing large target-like leaf lesions on tomato and other crops; emerging pathogen in parts of India.',
        'symptoms': ['Target-like concentric lesions which can coalesce into large necrotic areas', 'Leaf blotching and defoliation in severe cases'],
        'causes': ['Corynespora cassiicola infection favored by high humidity and warm temperatures', 'Can infect multiple hosts and survive in residues'],
        'severity': 'Medium',
        'treatments': [
            {'type': 'Fungicide', 'name': 'Mancozeb / registered fungicides',
             'description': 'Protectant fungicides reduce sporulation and lesion spread; integrate with cultural management.',
             'dosage': 'Per label',
             'frequency': 'Weekly to 10-day intervals under pressure'},
            {'type': 'Cultural', 'name': 'Sanitation & crop rotation',
             'description': 'Remove infected residues and rotate to non-hosts to reduce inoculum.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Improve airflow and avoid prolonged leaf wetness',
            'Remove infected leaves and residues promptly',
            'Monitor fields for new/emerging outbreaks'
        ],
        'sources': [
            ':contentReference[oaicite:18]{index=18}',  # Target spot reports and Indian emergence notes
            ':contentReference[oaicite:19]{index=19}'   # Reports of Corynespora in Indian contexts
        ]
    },

    12: {
        'name': 'Leaf Curl Virus (Tomato Yellow Leaf Curl / TYLCV)',
        'scientific_name': 'Begomovirus (TYLCV and related begomoviruses)',
        'description': 'Viral disease transmitted by whitefly (Bemisia tabaci) causing leaf curling, yellowing, stunting and severe yield loss in India.',
        'symptoms': ['Leaf curling and distortion', 'Interveinal yellowing, stunting and reduced fruit set', 'Severe cases cause near-total yield loss'],
        'causes': ['Begomoviruses (TYLCV/ToLCNDV and related strains) vectored by whitefly', 'High vector populations and mixed infections increase impact'],
        'severity': 'Critical',
        'treatments': [
            {'type': 'Insecticide', 'name': 'Imidacloprid / systemic whitefly management',
             'description': 'Vector control lowers virus spread; integrate chemical control with cultural and biological measures.',
             'dosage': 'Per label (example: 0.5 ml/L is commonly cited in regional recommendations)',
             'frequency': 'Follow IPM and label directions'},
            {'type': 'Cultural', 'name': 'Resistant varieties & rogueing',
             'description': 'Use resistant/tolerant varieties where available; remove infected plants to reduce sources.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Use yellow sticky traps and manage whitefly populations',
            'Plant virus-resistant/tolerant varieties and practice rogueing of infected plants',
            'Implement crop-free windows and remove alternate weed hosts'
        ],
        'sources': [
            ':contentReference[oaicite:20]{index=20}',  # Review on tomato leaf curl disease in India
            ':contentReference[oaicite:21]{index=21}'  # TYLCV management and breeding review (India)
        ]
    },

    13: {
        'name': 'Mosaic Virus',
        'scientific_name': 'Tobamovirus / Tobravirus / Cucumovirus groups (e.g., TMV, ToMV, CMV depending on host)',
        'description': 'Group of viral diseases causing mottling, mosaic patterns, leaf distortion and yield loss; several mosaic viruses (CMV, TMV, ToMV, ToBRFV) have been reported in India.',
        'symptoms': ['Mottling and mosaic patterns on leaves', 'Leaf distortion, chlorosis, reduced vigor and yield', 'Host-specific additional signs (fruit malformation)'],
        'causes': ['Mechanical or seed transmission (tobamoviruses) and vector transmission for others (e.g., CMV via aphids)',
                 'Contaminated transplants, tools and seedlots'],
        'severity': 'High (depending on virus and cultivar)',
        'treatments': [
            {'type': 'Cultural', 'name': 'Use certified seed & sanitation',
             'description': 'Virus management relies on healthy seed, sanitation, removal of infected plants and tool disinfection.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'},
            {'type': 'Breeding', 'name': 'Resistant varieties',
             'description': 'Deploy resistant/tolerant cultivars where available; seed certification programs reduce spread.',
             'dosage': 'N/A',
             'frequency': 'Ongoing'}
        ],
        'recommendations': [
            'Implement strict seed/transplant hygiene and disinfect tools regularly',
            'Control mechanical spread and insect vectors (where applicable)',
            'Monitor and rogue infected plants early'
        ],
        'sources': [
            ':contentReference[oaicite:22]{index=22}',  # MDPI report: ToMMV first reports in India (tobamovirus)
            ':contentReference[oaicite:23]{index=23}'  # Indian Express coverage re: CMV/ToMV impacts in Maharashtra/Karnataka
        ]
    },

    14: {
        'name': 'Tomato Healthy',
        'scientific_name': 'Solanum lycopersicum (Healthy)',
        'description': 'Healthy tomato leaf with no disease or stress.',
        'symptoms': ['Uniform green leaf', 'Normal growth'],
        'causes': ['Good nutrition', 'No pathogen presence'],
        'severity': 'None',
        'treatments': [],
        'recommendations': ['Maintain balanced crop care and monitor regularly'],
        'sources': []
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
