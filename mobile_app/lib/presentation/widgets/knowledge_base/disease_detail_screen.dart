import 'package:flutter/material.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final String diseaseId;

  const DiseaseDetailScreen({super.key, required this.diseaseId});

  @override
  Widget build(BuildContext context) {
    // TODO: fetch detail by diseaseId from API / local DB
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // placeholder content
    final name = isHindi ? 'पत्ती धब्बा' : 'Leaf Spot';
    final scientific = 'Cercospora capsici';
    final symptoms = isHindi
        ? 'पत्तियों पर गोलाकार भूरे धब्बे, पत्तियाँ झड़ना'
        : 'Circular brown spots on leaves, leaf drop';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              scientific,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Text(
              isHindi ? 'लक्षण' : 'Symptoms',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(symptoms),
            const SizedBox(height: 12),
            Text(
              isHindi ? 'रोकथाम और उपचार' : 'Prevention & Treatment',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text('• Remove infected parts\n• Improve spacing\n• Use recommended fungicide'),
          ],
        ),
      ),
    );
  }
}
