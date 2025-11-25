"""
Disease metadata for 6 chilli disease classes
Based on model_info.json: Bacterial Spot, Cercospora, Curl Virus, Healthy, Nutrition Deficiency, White Spot
"""

DISEASE_CLASSES = {
0: {
'name': 'Bacterial Spot',
'scientific_name': 'Xanthomonas spp. (X. euvesicatoria / X. vesicatoria)',
'description': 'Bacterial disease causing necrotic leaf and fruit spots with yellow halos, reducing yield and marketability in Indian pepper. ',
'symptoms': [
'Small water-soaked lesions on leaves and fruits',
'Brown/black circular spots often with yellow halos',
'Lesions coalesce producing large necrotic areas',
'Premature leaf yellowing and defoliation',
'Fruit scabbing and reduced marketable yield'
],
'causes': [
'Xanthomonas spp. infection (seed-, transplant- and splash-borne)',
'Warm, humid weather with rain-splash dissemination'
],
'severity': 'High',
'treatments': [
{
'type': 'Chemical',
'name': 'Copper oxychloride (copper fungicide/bactericide)',
'description': 'Reduces surface inoculum and prevents new infections.',
'dosage': '2–3 g/L',
'frequency': 'Every 7–10 days during epidemic'
},
{
'type': 'Foliar Spray',
'name': 'Streptocycline + copper (where registered)',
'description': 'Bactericidal foliar spray to lower bacterial populations on foliage and fruits.',
'dosage': 'Per label (example: streptocycline 200–300 ppm where permitted)',
'frequency': 'As directed by label; usually at first symptoms and repeat 7–10 days'
},
{
'type': 'Organic',
'name': 'Bacillus subtilis / neem oil',
'description': 'Biocontrol agents and neem reduce bacterial spread and induce resistance.',
'dosage': 'B. subtilis: per product label; Neem oil: 5–10 ml/L',
'frequency': 'Apply weekly or per product instructions'
},
{
'type': 'Micronutrients',
'name': 'Zinc sulphate foliar spray',
'description': 'Corrects zinc deficiency that can exacerbate susceptibility.',
'dosage': '0.5–1 g/L',
'frequency': 'Once at early growth and repeat if deficient'
}
],
'recommendations': [
'Use certified disease-free seed/seedlings and treat seed where appropriate',
'Avoid overhead irrigation; prefer drip to reduce splash dispersal',
'Maintain plant spacing and prune for air circulation',
'Rogue and destroy severely infected plants; sanitize tools',
'Rotate with non-host crops and remove volunteer hosts'
],
'sources': [
'ICAR-Indian Agricultural Research Institute, Characterisation of Xanthomonas causing bacterial spot in India',
'TNAU / Regional Centre studies on bacterial spot management in capsicum'
]
},
1: {
    'name': 'Healthy',
    'scientific_name': 'Capsicum annuum',
    'description': 'No visible disease or stress; normal vigour and unblemished fruits and foliage.',
    'symptoms': [
        'Uniform green leaves without lesions',
        'No necrotic or chlorotic spots',
        'Normal vegetative growth and flowering',
        'Healthy, unblemished fruits',
        'No wilting or abnormal stunting'
    ],
    'causes': [
        'Balanced nutrition and proper irrigation',
        'Absence of pathogen or pest pressure'
    ],
    'severity': 'None',
    'treatments': [],
    'recommendations': [
        'Maintain regular monitoring and field hygiene',
        'Apply balanced NPK and micronutrients as per soil test',
        'Use drip irrigation and avoid overhead sprinkling',
        'Sanitize tools and avoid introduction of infected transplants',
        'Adopt integrated pest management principles'
    ],
    'sources': []
},

2: {
    'name': 'Early Blight',
    'scientific_name': 'Alternaria solani',
    'description': 'Fungal disease producing concentric “target” lesions on leaves, causing defoliation and yield loss in potato.',
    'symptoms': [
        'Brown circular lesions with concentric rings on foliage',
        'Yellowing (chlorosis) around lesions',
        'Progressive defoliation under favourable conditions',
        'Lesions on stems and sometimes tuber skin',
        'Reduced tuber yield and quality'
    ],
    'causes': [
        'Alternaria solani spores dispersed by wind and splash',
        'Warm, humid conditions with prolonged leaf wetness'
    ],
    'severity': 'High',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Mancozeb (protectant fungicide)',
            'description': 'Protectant foliar fungicide that reduces spore germination and spread.',
            'dosage': '2–2.5 g/L',
            'frequency': 'Every 7–14 days depending on pressure'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Azoxystrobin (QoI systemic fungicide)',
            'description': 'Systemic foliar application for curative/protective activity; rotate MoA to prevent resistance.',
            'dosage': 'Per label (commonly 0.5–1 ml/L formulations vary)',
            'frequency': 'As per label; typically every 10–14 days under pressure'
        },
        {
            'type': 'Organic',
            'name': 'Trichoderma harzianum / neem cake in soil',
            'description': 'Biological control and organic amendment to reduce inoculum and improve soil health.',
            'dosage': 'Trichoderma: per product label; Neem cake: 250–500 kg/ha in soil incorporation',
            'frequency': 'At transplanting/soil prep and Trichoderma as per product'
        },
        {
            'type': 'Micronutrients',
            'name': 'Balanced foliar manganese + zinc',
            'description': 'Corrects deficiencies that can predispose plants to severe blight.',
            'dosage': 'Mn 0.5 g/L + Zn 0.5 g/L or per label',
            'frequency': 'Apply once at early symptom onset and repeat if deficient'
        }
    ],
    'recommendations': [
        'Use certified seed tubers and avoid planting infected material',
        'Improve plant spacing and air flow; use drip irrigation',
        'Rotate crops and remove crop residues to reduce inoculum',
        'Follow a fungicide spray schedule and rotate modes of action',
        'Ensure balanced nutrition and manage irrigation to reduce leaf wetness'
    ],
    'sources': [
        'ICAR-Central Potato Research Institute, Management of early blight in potato (regional recommendations)',
        'Punjab Agricultural University (PAU) field trials on fungicide efficacy against Alternaria'
    ]
},

3: {
    'name': 'Late Blight',
    'scientific_name': 'Phytophthora infestans',
    'description': 'Oomycete causing water-soaked lesions, white sporulation and rapid crop collapse under cool, humid Indian conditions.',
    'symptoms': [
        'Water-soaked dark lesions on leaves and stems',
        'White/grayish sporulation on undersides in humid weather',
        'Rapid leaf collapse and stem necrosis',
        'Blackened stolons and infected tubers',
        'Sudden extensive yield loss during epidemics'
    ],
    'causes': [
        'Phytophthora infestans sporangia/zoospores spread by wind and rain',
        'Cool, humid weather and prolonged leaf wetness'
    ],
    'severity': 'Critical',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Metalaxyl-M + Mancozeb (oomycide mixture)',
            'description': 'Systemic + protectant combination effective against P. infestans.',
            'dosage': 'Per label (example formulations 1.5–2 g/L depending on product)',
            'frequency': '7–10 days under epidemic conditions'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Preventive protective sprays (Mancozeb/chlorothalonil)',
            'description': 'Protectant foliar sprays to reduce sporangia deposition and infection.',
            'dosage': '2–2.5 g/L for Mancozeb (follow label)',
            'frequency': 'Every 7–10 days when risk is high'
        },
        {
            'type': 'Organic',
            'name': 'Phosphorus-based bio-stimulants / Trichoderma',
            'description': 'Soil/seed treatments and biologicals to improve plant resistance and reduce inoculum.',
            'dosage': 'Per product label',
            'frequency': 'At planting and as per product guidance'
        },
        {
            'type': 'Micronutrients',
            'name': 'Calcium + boron foliar application',
            'description': 'Improves cell wall strength and reduces susceptibility to infection.',
            'dosage': 'Calcium 1–2 g/L, Boron 0.2–0.5 g/L',
            'frequency': 'Apply at tuber initiation and repeat if required'
        }
    ],
    'recommendations': [
        'Use certified seed tubers and avoid planting infected material',
        'Destroy infected plants and volunteer potatoes promptly',
        'Monitor weather forecasts and apply protectant sprays before wet periods',
        'Improve field drainage and avoid waterlogging',
        'Adopt integrated fungicide program and rotate MoA'
    ],
    'sources': [
        'ICAR-Central Potato Research Institute, Late blight management advisories (India)',
        'IARI / National Phytopathology studies on Phytophthora infestans in Indian potato systems'
    ]
},

4: {
    'name': 'Healthy',
    'scientific_name': 'Solanum tuberosum (Healthy)',
    'description': 'Healthy potato plants with no visible disease or stress symptoms.',
    'symptoms': [
        'Uniform green canopy without necrotic lesions',
        'Normal tuber set and development',
        'No abnormal wilting or chlorosis',
        'Intact stems and foliage',
        'Normal growth rate for cultivar and season'
    ],
    'causes': [
        'Appropriate nutrition and irrigation',
        'Absence of pathogen or pest pressure'
    ],
    'severity': 'None',
    'treatments': [],
    'recommendations': [
        'Use certified seed tubers and rotate crops',
        'Perform regular scouting and sanitation',
        'Maintain balanced fertilization and timely irrigation',
        'Follow recommended agronomic practices for cultivar'
    ],
    'sources': []
},

5: {
    'name': 'Bacterial Spot',
    'scientific_name': 'Xanthomonas vesicatoria / X. euvesicatoria',
    'description': 'Bacterial disease causing black spots with yellow halos on tomato leaves and fruit; reduces yield and quality in India.',
    'symptoms': [
        'Black leaf and fruit spots with yellow halos',
        'Water-soaked lesions initially',
        'Cracking or scabby lesions on fruits',
        'Premature leaf yellowing and drop',
        'Reduced fruit marketability'
    ],
    'causes': [
        'Xanthomonas infection (seed- and splash-borne)',
        'Warm, humid weather with overhead irrigation'
    ],
    'severity': 'High',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Copper oxychloride + mancozeb tank mix',
            'description': 'Combines protectant with copper to lower bacterial and secondary fungal pressure.',
            'dosage': 'Copper 2–3 g/L; Mancozeb 2 g/L (follow product labels)',
            'frequency': 'Every 7–10 days during epidemics'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Bactericidal foliar sprays (permitted antibiotics where legal)',
            'description': 'Targeted foliar applications to reduce bacterial load on foliage/fruit.',
            'dosage': 'Per local label and regulation',
            'frequency': 'As per extension recommendations'
        },
        {
            'type': 'Organic',
            'name': 'Bacillus subtilis formulations / neem oil',
            'description': 'Biocontrol and botanical sprays to reduce inoculum and hinder disease progression.',
            'dosage': 'B. subtilis: per label; Neem oil: 5–10 ml/L',
            'frequency': 'Weekly or as per product'
        },
        {
            'type': 'Micronutrients',
            'name': 'Foliar zinc + manganese',
            'description': 'Corrects micronutrient deficiencies and improves plant resilience.',
            'dosage': 'Zn 0.5 g/L + Mn 0.5 g/L',
            'frequency': 'Apply at early symptoms and repeat if deficient'
        }
    ],
    'recommendations': [
        'Use disease-free seed/seedlings and treat transplants',
        'Avoid overhead irrigation; adopt drip where possible',
        'Sanitize tools and remove infected plants promptly',
        'Rotate crops and manage weeds that act as reservoirs',
        'Follow IPM and avoid unnecessary broad-spectrum antibiotics'
    ],
    'sources': [
        'IARI publications on bacterial diseases of tomato in India',
        'Regional agricultural university (KAU/TNAU) field reports on Xanthomonas management'
    ]
},

6: {
    'name': 'Early Blight',
    'scientific_name': 'Alternaria solani',
    'description': 'Fungal disease producing concentric ringed lesions on tomato leaves, causing defoliation and yield decline in Indian conditions.',
    'symptoms': [
        'Brown concentric ring lesions on leaflets',
        'Yellowing around lesions',
        'Progressive defoliation and canopy thinning',
        'Lesions on stems and sometimes fruit surface',
        'Reduced fruit yield and size'
    ],
    'causes': [
        'Alternaria solani spores dispersed by wind and rain',
        'Warm, humid weather and prolonged leaf wetness'
    ],
    'severity': 'High',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Mancozeb / Chlorothalonil (protectants)',
            'description': 'Protectant fungicides to prevent spore germination and infection.',
            'dosage': '2 g/L (follow label)',
            'frequency': 'Every 7–14 days depending on pressure'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Azoxystrobin (systemic foliar fungicide)',
            'description': 'Systemic foliar application for curative and protective control; rotate to prevent resistance.',
            'dosage': 'Per label',
            'frequency': 'As needed under high disease pressure'
        },
        {
            'type': 'Organic',
            'name': 'Trichoderma harzianum soil amendment & neem oil foliar',
            'description': 'Biological control and botanical foliar protection to reduce disease incidence.',
            'dosage': 'Trichoderma: per product label; Neem oil: 5–10 ml/L',
            'frequency': 'At planting for Trichoderma; neem weekly if required'
        },
        {
            'type': 'Micronutrients',
            'name': 'Balanced foliar potassium and manganese',
            'description': 'Supports plant health and reduces lesion expansion.',
            'dosage': 'K foliar 1–2 g/L; Mn 0.5 g/L',
            'frequency': 'Apply during early disease development as needed'
        }
    ],
    'recommendations': [
        'Improve spacing and canopy ventilation; avoid splash irrigation',
        'Remove and destroy infected foliage and residues',
        'Rotate fungicide MoA and follow label rates',
        'Use resistant/less susceptible varieties where available',
        'Maintain balanced fertilization to avoid excess N'
    ],
    'sources': [
        'ICAR / IARI studies on Alternaria management in tomato (India)',
        'TNAU extension bulletin: Early blight control measures for tomato'
    ]
},

7: {
    'name': 'Late Blight',
    'scientific_name': 'Phytophthora infestans',
    'description': 'Rapidly destructive oomycete causing water-soaked lesions and white sporulation; can cause catastrophic losses in tomato.',
    'symptoms': [
        'Water-soaked dark lesions on leaf and stem',
        'White/gray sporulation on leaf undersides',
        'Rapid foliar collapse and stem dieback',
        'Fruit rot and secondary infections',
        'Sudden widespread crop failure under conducive weather'
    ],
    'causes': [
        'Phytophthora infestans sporangia/zoospores spread by rain and wind',
        'Cool, humid conditions with prolonged leaf wetness'
    ],
    'severity': 'Critical',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Metalaxyl-M (mefenoxam) + Mancozeb mixtures',
            'description': 'Oomycide systemic blended with protectant for effective control.',
            'dosage': 'Per label (follow resistance management guidelines)',
            'frequency': '7–10 days during high risk'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Protectant sprays (Mancozeb / Chlorothalonil)',
            'description': 'Reduce inoculum deposition and protect new foliage.',
            'dosage': '2–2.5 g/L (follow label)',
            'frequency': 'Weekly when conditions favour disease'
        },
        {
            'type': 'Organic',
            'name': 'Bio-stimulants and Trichoderma seed/tuber treatment',
            'description': 'Improve host resistance and reduce soil inoculum.',
            'dosage': 'Per product label',
            'frequency': 'At planting/seed treatment and as per product'
        },
        {
            'type': 'Micronutrients',
            'name': 'Calcium foliar sprays',
            'description': 'Strengthens cell walls and reduces disease severity.',
            'dosage': '1–2 g/L',
            'frequency': 'At fruit set and repeat if required'
        }
    ],
    'recommendations': [
        'Use certified healthy transplants and avoid infected material',
        'Monitor weather and apply protectants before wet periods',
        'Improve drainage and avoid waterlogging',
        'Remove and destroy infected plants; sanitize equipment',
        'Rotate fungicides and follow IPM guidelines'
    ],
    'sources': [
        'ICAR-NRC on Phytophthora studies and late blight advisories (India)',
        'State agricultural university outbreak reports on tomato late blight (regional)'
    ]
},

8: {
    'name': 'Leaf Mold',
    'scientific_name': 'Passalora fulva (syn. Cladosporium fulvum / Fulvia fulva)',
    'description': 'Fungal leaf mold causing yellow patches above and olive-green mold beneath, common in humid protected and open fields.',
    'symptoms': [
        'Yellow patches on upper leaf surface',
        'Olive-green fuzzy mould on lower leaf surface',
        'Reduced photosynthetic area and vigor',
        'Premature leaf drop under severe infection',
        'Thinning canopy and reduced yield'
    ],
    'causes': [
        'Passalora fulva infection favoured by high humidity and poor ventilation',
        'Prolonged leaf wetness in protected cultivation'
    ],
    'severity': 'Medium',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Copper hydroxide / registered fungicides',
            'description': 'Foliar protectant to reduce sporulation and infection.',
            'dosage': '2 g/L (per product label)',
            'frequency': 'Every 7–10 days under pressure'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Sulphur or registered systemic fungicide (where permitted)',
            'description': 'Foliar sprays to control sporulation and lesion expansion.',
            'dosage': 'Per label',
            'frequency': 'Weekly to 10 days depending on severity'
        },
        {
            'type': 'Organic',
            'name': 'Improve ventilation & neem oil',
            'description': 'Reduce humidity and use botanical sprays to lower surface inoculum.',
            'dosage': 'Neem oil 5–10 ml/L',
            'frequency': 'Weekly or when humidity persists'
        },
        {
            'type': 'Micronutrients',
            'name': 'Foliar magnesium + iron (if deficient)',
            'description': 'Supports chlorophyll production and recovery of foliage.',
            'dosage': 'Mg 1 g/L; Fe 0.2–0.5 g/L',
            'frequency': 'Apply once and repeat if deficiency persists'
        }
    ],
    'recommendations': [
        'Improve ventilation in protected structures and avoid overcrowding',
        'Reduce leaf wetness by timing irrigation and pruning',
        'Sanitize greenhouse surfaces and use disease-free transplants',
        'Remove heavily infected leaves and debris promptly',
        'Use integrated foliar spray schedules when necessary'
    ],
    'sources': [
        'TNAU greenhouse disease management notes: Leaf mold in tomato',
        'Regional studies on Passalora fulva incidence in India (State agricultural universities)'
    ]
},

9: {
    'name': 'Septoria Leaf Spot',
    'scientific_name': 'Septoria lycopersici',
    'description': 'Fungal leaf spot producing small dark spots with chlorotic margins, leading to defoliation under Indian wet conditions.',
    'symptoms': [
        'Small dark circular spots on leaves',
        'Yellow/chlorotic edges surrounding spots',
        'Progressive defoliation with heavy infection',
        'Reduced canopy and fruit yield',
        'Lower photosynthetic capacity'
    ],
    'causes': [
        'Septoria lycopersici spores dispersed by rain-splash',
        'Prolonged leaf wetness and poor aeration'
    ],
    'severity': 'High',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Chlorothalonil / Mancozeb protectant sprays',
            'description': 'Protectant foliar fungicides to prevent new infections.',
            'dosage': '2 g/L (follow product label)',
            'frequency': 'Every 7–10 days during epidemics'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Hexaconazole / registered systemic fungicide',
            'description': 'Systemic foliar application to arrest lesion development.',
            'dosage': 'Per label',
            'frequency': 'As per local recommendations'
        },
        {
            'type': 'Organic',
            'name': 'Crop sanitation & Trichoderma soil amendment',
            'description': 'Reduce inoculum in soil and on residues through biological amendments.',
            'dosage': 'Trichoderma per product label; sanitation continuous',
            'frequency': 'At land preparation and ongoing sanitation'
        },
        {
            'type': 'Micronutrients',
            'name': 'Foliar boron + zinc',
            'description': 'Support leaf health and reduce severity of spots.',
            'dosage': 'B 0.2–0.5 g/L; Zn 0.5 g/L',
            'frequency': 'Apply at early onset and repeat if deficient'
        }
    ],
    'recommendations': [
        'Avoid overhead watering and reduce splash; use drip irrigation',
        'Stake/prune plants to improve airflow',
        'Remove infected debris and practice crop rotation',
        'Apply protectant fungicides based on disease forecasts',
        'Maintain balanced nutrition to avoid predisposition'
    ],
    'sources': [
        'ICAR extension bulletin on Septoria management in tomato (India)',
        'State agricultural university fungicide trials against Septoria (regional reports)'
    ]
},

10: {
    'name': 'Spider Mites (Two-spotted)',
    'scientific_name': 'Tetranychus urticae',
    'description': 'Acarine pest causing stippling, bronzing and webbing on leaves; thrives in hot, dry Indian seasons and protected cultivation.',
    'symptoms': [
        'Fine yellow stippling on leaf blades',
        'Leaf bronzing and progressive chlorosis',
        'Fine webbing on leaf undersides and between leaves',
        'Premature leaf drop and reduced vigor',
        'Localized patches of heavy infestation'
    ],
    'causes': [
        'Tetranychus urticae population build-up in hot, dry conditions',
        'Lack of natural predators and indiscriminate insecticide use'
    ],
    'severity': 'Medium',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Abamectin (registered acaricide)',
            'description': 'Selective acaricide effective against two-spotted spider mite.',
            'dosage': '0.5 ml/L (typical; follow product label)',
            'frequency': 'Apply as per label and thresholds'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Propargite / Dicofol (where registered)',
            'description': 'Foliar acaricidal sprays to reduce mite populations and webbing.',
            'dosage': 'Per label',
            'frequency': 'As per integrated pest management schedule'
        },
        {
            'type': 'Organic',
            'name': 'Release of predatory mites (Phytoseiulus) / neem oil',
            'description': 'Biological control and botanical sprays to conserve natural enemies and suppress mites.',
            'dosage': 'Predators: per supplier; Neem oil: 5–10 ml/L',
            'frequency': 'Augment predators as needed; neem weekly if required'
        },
        {
            'type': 'Micronutrients',
            'name': 'Foliar potassium and magnesium',
            'description': 'Supports overall plant health and resilience against mite damage.',
            'dosage': 'K 1–2 g/L; Mg 1 g/L',
            'frequency': 'Apply during stress periods or after heavy infestation'
        }
    ],
    'recommendations': [
        'Monitor regularly and spray only above economic thresholds',
        'Conserve and augment natural enemies; avoid broad-spectrum insecticides',
        'Maintain humidity in protected cultivation to reduce mite outbreaks',
        'Use selective acaricides and rotate modes of action to prevent resistance',
        'Remove heavily infested plants and wash foliage where feasible'
    ],
    'sources': [
        'ICAR-National Bureau of Agricultural Insect Resources: Management of two-spotted spider mite',
        'Regional SAU publications on acaricide trials and biological control (India)'
    ]
},

11: {
    'name': 'Target Spot',
    'scientific_name': 'Corynespora cassiicola',
    'description': 'Fungal disease producing target-like concentric lesions that can coalesce and cause defoliation in tomato and other hosts.',
    'symptoms': [
        'Target-like concentric lesions on leaves',
        'Lesions may coalesce into large necrotic patches',
        'Leaf blotching leading to defoliation',
        'Stem lesions in severe cases',
        'Reduced canopy and fruit yield'
    ],
    'causes': [
        'Corynespora cassiicola infection favoured by warm, humid conditions',
        'Survival on residues and multiple host range increasing inoculum'
    ],
    'severity': 'Medium',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Mancozeb / registered protectant fungicides',
            'description': 'Protectant sprays to minimise sporulation and new infections.',
            'dosage': '2 g/L (follow label)',
            'frequency': 'Weekly to 10-day intervals under pressure'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Systemic fungicides (triazoles where registered)',
            'description': 'Foliar systemic applications to reduce lesion expansion.',
            'dosage': 'Per label',
            'frequency': 'As recommended locally'
        },
        {
            'type': 'Organic',
            'name': 'Crop residue management & Trichoderma',
            'description': 'Sanitation and biologicals to reduce inoculum carryover.',
            'dosage': 'Trichoderma per product label',
            'frequency': 'At land preparation and ongoing sanitation'
        },
        {
            'type': 'Micronutrients',
            'name': 'Balanced foliar nutrition (K and Mn)',
            'description': 'Supports recovery and reduces lesion spread.',
            'dosage': 'K 1–2 g/L; Mn 0.5 g/L',
            'frequency': 'Apply at early symptom stages'
        }
    ],
    'recommendations': [
        'Remove infected leaves and residues promptly',
        'Improve airflow and avoid prolonged leaf wetness',
        'Rotate to non-host crops and practice good sanitation',
        'Monitor fields for early lesions and apply protectant sprays'
    ],
    'sources': [
        'ICAR / Regional SAU reports on Corynespora outbreaks in India',
        'Journal of Mycology & Plant Pathology publications on target spot in Indian contexts'
    ]
},

12: {
    'name': 'Leaf Curl Virus',
    'scientific_name': 'Begomovirus complex (Tomato yellow leaf curl virus and related begomoviruses)',
    'description': 'Whitefly-transmitted begomovirus causing leaf curling, yellowing, stunting and severe yield loss in Indian tomato crops.',
    'symptoms': [
        'Severe upward leaf curling and distortion',
        'Interveinal yellowing and chlorosis',
        'Stunted plant growth and reduced canopy',
        'Poor fruit set and deformed fruits',
        'High incidence under heavy whitefly populations'
    ],
    'causes': [
        'Begomoviruses (TYLCV/ToLCNDV and related strains) vectored by Bemisia tabaci',
        'High whitefly populations and presence of alternate weed hosts'
    ],
    'severity': 'Critical',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Imidacloprid / systemic neonicotinoid (vector control)',
            'description': 'Systemic insecticide to reduce whitefly populations and virus spread.',
            'dosage': 'Per label (example seedling drench or foliar rates vary)',
            'frequency': 'Follow IPM and label recommendations'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Foliar pyrethroids or oxadiazines (as per resistance and registration)',
            'description': 'Foliar sprays to reduce adult whitefly numbers on foliage.',
            'dosage': 'Per label',
            'frequency': 'As needed following monitoring thresholds'
        },
        {
            'type': 'Organic',
            'name': 'Yellow sticky traps + neem formulations',
            'description': 'Trap cropping and botanical insecticides to reduce vector incidence organically.',
            'dosage': 'Neem oil 5–10 ml/L; traps per hectare density as recommended',
            'frequency': 'Install before transplanting and renew traps as needed'
        },
        {
            'type': 'Micronutrients',
            'name': 'Foliar potassium + calcium',
            'description': 'Improve plant vigor and reduce symptom severity.',
            'dosage': 'K 1–2 g/L; Ca 1–2 g/L',
            'frequency': 'Apply at early growth and repeat during fruiting'
        }
    ],
    'recommendations': [
        'Use resistant/tolerant varieties and certified transplants where available',
        'Implement strict whitefly monitoring and threshold-based sprays',
        'Remove and destroy infected plants promptly (rogueing)',
        'Use reflective mulches and yellow sticky traps to reduce vectors',
        'Maintain field sanitation and remove alternate weed hosts'
    ],
    'sources': [
        'ICAR-IARI review on begomovirus diseases and TYLCV management in India',
        'National Research Centre/SAU publications on whitefly-vectored virus management'
    ]
},

13: {
    'name': 'Mosaic Virus',
    'scientific_name': 'Tobamovirus / Cucumovirus group (e.g., TMV, ToMV, CMV depending on host)',
    'description': 'Group of mosaic viruses causing mottling, distortion and yield loss; spread by seed, mechanical means or vectors in India.',
    'symptoms': [
        'Mottling and mosaic patterns on leaves',
        'Leaf distortion and curling',
        'Chlorosis and reduced vigor',
        'Fruit malformation or mottled fruits',
        'Stunted growth in severe infections'
    ],
    'causes': [
        'Mechanical or seed transmission (tobamoviruses) and vector transmission (e.g., aphids for CMV)',
        'Contaminated transplants, tools and seedlots'
    ],
    'severity': 'High',
    'treatments': [
        {
            'type': 'Chemical',
            'name': 'Not applicable for viruses (vector control chemicals where relevant)',
            'description': 'Use insecticides to control vectors (aphids/whitefly) to limit spread.',
            'dosage': 'Per label for specific vector control products',
            'frequency': 'Follow IPM thresholds'
        },
        {
            'type': 'Foliar Spray',
            'name': 'Insecticidal foliar sprays targeting vectors (where applicable)',
            'description': 'Reduce vector populations to limit virus transmission.',
            'dosage': 'Per label',
            'frequency': 'As per monitoring and IPM'
        },
        {
            'type': 'Organic',
            'name': 'Sanitation, certified virus-free seed and biocontrol',
            'description': 'Primary management via seed health, tool disinfection and rogueing infected plants.',
            'dosage': 'N/A for sanitation; biocontrol per product label',
            'frequency': 'Ongoing; seed health at planting'
        },
        {
            'type': 'Micronutrients',
            'name': 'Balanced foliar nutrition (K, Ca, Zn)',
            'description': 'Support plant recovery and reduce symptom severity.',
            'dosage': 'K 1–2 g/L; Ca 1–2 g/L; Zn 0.5 g/L',
            'frequency': 'Apply during vegetative growth and repeat if needed'
        }
    ],
    'recommendations': [
        'Use certified virus-free seed and transplants',
        'Disinfect tools and avoid mechanical transmission during cultivation',
        'Rogue infected plants immediately and control vectors',
        'Implement crop-free windows and remove alternate hosts',
        'Adopt resistant varieties where available'
    ],
    'sources': [
        'IARI research notes on mosaic viruses in tomato and management (India)',
        'ICAR/SAU publications on seed certification and virus control'
    ]
},

14: {
    'name': 'Healthy',
    'scientific_name': 'Solanum lycopersicum (Healthy)',
    'description': 'No visible disease or stress; healthy tomato foliage and fruit development.',
    'symptoms': [
        'Uniform green leaves without lesions',
        'Normal flowering and fruit set',
        'No mosaicing or chlorotic patches',
        'Healthy fruit size and shape',
        'No wilting or abnormal stunting'
    ],
    'causes': [
        'Appropriate nutrition and irrigation management',
        'Absence of pathogen and effective pest control'
    ],
    'severity': 'None',
    'treatments': [],
    'recommendations': [
        'Maintain seed/transplant health and regular scouting',
        'Apply balanced fertilization based on soil test',
        'Use drip irrigation and proper spacing',
        'Sanitize tools and avoid introduction of infected material',
        'Follow IPM and timely nutrient supplements'
    ],
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
