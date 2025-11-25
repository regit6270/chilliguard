import 'package:flutter/material.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final String diseaseId;

  const DiseaseDetailScreen({super.key, required this.diseaseId});

  @override
  Widget build(BuildContext context) {
    // TODO: fetch detail by diseaseId from API / local DB
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // placeholder content - in production, fetch from API
    final name = isHindi ? 'पत्ती धब्बा' : 'Leaf Spot';
    const scientific = 'Cercospora capsici';
    final description = isHindi
        ? 'कवक रोग जो गोलाकार धब्बे बनाता है।'
        : 'Fungal disease causing circular lesions on leaves.';
    final symptoms = [
      isHindi ? 'पत्तियों पर गोलाकार भूरे धब्बे' : 'Circular brown spots on leaves',
      isHindi ? 'पत्तियाँ झड़ना' : 'Leaf drop',
      isHindi ? 'पीले रंग का प्रभामंडल' : 'Yellow halos around spots',
    ];
    final causes = [
      isHindi ? 'उच्च आर्द्रता (>80%)' : 'High humidity (>80%)',
      isHindi ? 'खराब वायु संचार' : 'Poor air circulation',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disease Name Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scientific,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            if (description.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Causes Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.coronavirus_outlined, color: Colors.red.shade700, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          isHindi ? 'कारण' : 'Causes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...causes.map((cause) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                cause,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red.shade900,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Symptoms Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.visibility_outlined, color: Colors.orange.shade700, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          isHindi ? 'लक्षण' : 'Symptoms',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...symptoms.map((symptom) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade700,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                symptom,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange.shade900,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Prevention & Treatment Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.purple.shade700, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          isHindi ? 'रोकथाम और उपचार' : 'Prevention & Treatment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.purple.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...['Remove infected parts', 'Improve spacing', 'Use recommended fungicide'].map((rec) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade700,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                rec,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.purple.shade900,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
