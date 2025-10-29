import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../widgets/knowledge_base/disease_card.dart';

class DiseaseEncyclopediaScreen extends StatelessWidget {
  const DiseaseEncyclopediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with API data
    final diseases = [
      {
        'id': 'dis_001',
        'name': isHindi ? 'एन्थ्रेक्नोज' : 'Anthracnose',
        'scientificName': 'Colletotrichum capsici',
        'severity': 'high',
        'symptoms': isHindi
            ? 'फलों और पत्तियों पर धंसे हुए घाव'
            : 'Sunken lesions on fruits and leaves',
      },
      {
        'id': 'dis_002',
        'name': isHindi ? 'चूर्णिल आसिता' : 'Powdery Mildew',
        'scientificName': 'Leveillula taurica',
        'severity': 'medium',
        'symptoms': isHindi
            ? 'पत्तियों पर सफेद पाउडर जैसी परत'
            : 'White powdery coating on leaves',
      },
      {
        'id': 'dis_003',
        'name': isHindi ? 'पत्ती धब्बा' : 'Leaf Spot',
        'scientificName': 'Cercospora capsici',
        'severity': 'medium',
        'symptoms': isHindi
            ? 'पत्तियों पर गोलाकार भूरे धब्बे'
            : 'Circular brown spots on leaves',
      },
      {
        'id': 'dis_004',
        'name': isHindi ? 'जड़ सड़न' : 'Root Rot',
        'scientificName': 'Phytophthora capsici',
        'severity': 'high',
        'symptoms': isHindi
            ? 'पौधा मुरझा जाता है और मर जाता है'
            : 'Plant wilts and dies',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'रोग विश्वकोश' : 'Disease Encyclopedia'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final disease = diseases[index];
          return DiseaseCard(
            name: disease['name'] as String,
            scientificName: disease['scientificName'] as String,
            severity: disease['severity'] as String,
            symptoms: disease['symptoms'] as String,
            onTap: () {
              // TODO: Navigate to disease detail
            },
          );
        },
      ),
    );
  }
}
