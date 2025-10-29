import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiseaseResultScreen extends StatelessWidget {
  final String detectionId;

  const DiseaseResultScreen({
    super.key,
    required this.detectionId,
  });

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with BLoC data
    final result = {
      'disease': isHindi ? 'पत्ती धब्बा रोग' : 'Leaf Spot Disease',
      'scientificName': 'Cercospora capsici',
      'confidence': 92.5,
      'severity': 'medium',
      'imageUrl': null, // Captured image
      'timestamp': '2024-03-15 14:30',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'निदान परिणाम' : 'Detection Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share result
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview
            _buildImagePreview(context, result),

            // Result Card
            _buildResultCard(context, result, isHindi),

            const SizedBox(height: 16),

            // Severity Indicator
            _buildSeverityIndicator(
                context, result['severity'] as String, isHindi),

            const SizedBox(height: 16),

            // Symptoms Section
            _buildSymptomsSection(context, isHindi),

            const SizedBox(height: 16),

            // Treatment Section
            _buildTreatmentSection(context, isHindi),

            const SizedBox(height: 16),

            // Prevention Section
            _buildPreventionSection(context, isHindi),

            const SizedBox(height: 16),

            // Action Buttons
            _buildActionButtons(context, isHindi),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, Map<String, dynamic> result) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: result['imageUrl'] != null
          ? Image.network(result['imageUrl'] as String, fit: BoxFit.cover)
          : const Center(
              child: Icon(Icons.image, size: 80, color: Colors.grey),
            ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    Map<String, dynamic> result,
    bool isHindi,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getSeverityColor(result['severity'] as String),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(result['severity'] as String)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bug_report,
                    color: _getSeverityColor(result['severity'] as String),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['disease'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result['scientificName'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.check_circle,
                    label: isHindi ? 'विश्वास' : 'Confidence',
                    value: '${result['confidence']}%',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.access_time,
                    label: isHindi ? 'समय' : 'Time',
                    value: result['timestamp'] as String,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityIndicator(
    BuildContext context,
    String severity,
    bool isHindi,
  ) {
    final color = _getSeverityColor(severity);
    String label;

    switch (severity) {
      case 'high':
        label = isHindi ? 'उच्च गंभीरता' : 'High Severity';
        break;
      case 'medium':
        label = isHindi ? 'मध्यम गंभीरता' : 'Medium Severity';
        break;
      case 'low':
        label = isHindi ? 'कम गंभीरता' : 'Low Severity';
        break;
      default:
        label = severity;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSection(BuildContext context, bool isHindi) {
    final symptoms = [
      isHindi ? 'पत्तियों पर गहरे भूरे धब्बे' : 'Dark brown spots on leaves',
      isHindi ? 'धब्बे समय के साथ बड़े होते हैं' : 'Spots enlarge over time',
      isHindi ? 'पत्तियां पीली पड़ सकती हैं' : 'Leaves may turn yellow',
      isHindi ? 'गंभीर मामलों में पत्ती गिरना' : 'Leaf drop in severe cases',
    ];

    return _buildSection(
      context: context,
      title: isHindi ? 'लक्षण' : 'Symptoms',
      icon: Icons.visibility,
      color: Colors.orange,
      children: symptoms.map((symptom) => _buildListItem(symptom)).toList(),
    );
  }

  Widget _buildTreatmentSection(BuildContext context, bool isHindi) {
    return _buildSection(
      context: context,
      title: isHindi ? 'उपचार' : 'Treatment',
      icon: Icons.medical_services,
      color: Colors.green,
      children: [
        _buildTreatmentCard(
          type: isHindi ? 'रासायनिक' : 'Chemical',
          treatment: isHindi
              ? 'तांबा आधारित कवकनाशी का छिड़काव करें (2 ग्राम/लीटर)'
              : 'Spray copper-based fungicide (2g/liter)',
          icon: Icons.science,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildTreatmentCard(
          type: isHindi ? 'जैविक' : 'Organic',
          treatment: isHindi
              ? 'नीम के तेल का घोल (5 मिली/लीटर पानी)'
              : 'Neem oil solution (5ml/liter water)',
          icon: Icons.eco,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildPreventionSection(BuildContext context, bool isHindi) {
    final tips = [
      isHindi
          ? 'संक्रमित पत्तियां तुरंत हटाएं'
          : 'Remove infected leaves immediately',
      isHindi
          ? 'पौधों के बीच उचित दूरी बनाए रखें'
          : 'Maintain proper plant spacing',
      isHindi ? 'अधिक सिंचाई से बचें' : 'Avoid overhead irrigation',
      isHindi ? 'खेत में स्वच्छता बनाए रखें' : 'Maintain field hygiene',
    ];

    return _buildSection(
      context: context,
      title: isHindi ? 'रोकथाम' : 'Prevention',
      icon: Icons.shield,
      color: Colors.purple,
      children: tips.map((tip) => _buildListItem(tip)).toList(),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard({
    required String type,
    required String treatment,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  treatment,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/knowledge-base/disease-encyclopedia');
              },
              icon: const Icon(Icons.book),
              label: Text(
                isHindi ? 'और जानें' : 'Learn More',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Save to history
                context.pop();
              },
              icon: const Icon(Icons.save),
              label: Text(
                isHindi ? 'इतिहास में सहेजें' : 'Save to History',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
