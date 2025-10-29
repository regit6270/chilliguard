import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with API data
    final faqs = [
      {
        'question': isHindi
            ? 'मुझे पहली खाद की खुराक कब लगानी चाहिए?'
            : 'When should I apply the first fertilizer dose?',
        'answer': isHindi
            ? 'रोपण के 15-20 दिन बाद पहली खुराक लगाएं। NPK (19:19:19) का उपयोग करें।'
            : 'Apply first dose 15-20 days after transplanting. Use NPK (19:19:19).',
        'category': isHindi ? 'उर्वरक' : 'Fertilization',
      },
      {
        'question': isHindi
            ? 'मिर्च के लिए उपयुक्त मिट्टी pH क्या है?'
            : 'What is the optimal soil pH for chilli?',
        'answer': isHindi
            ? 'मिर्च 5.5 से 7.5 pH में अच्छी तरह बढ़ती है। आदर्श 6.0-6.8 है।'
            : 'Chilli grows best in pH 5.5-7.5. Ideal is 6.0-6.8.',
        'category': isHindi ? 'मिट्टी' : 'Soil',
      },
      {
        'question': isHindi
            ? 'मैं चूर्णिल आसिता को जल्दी कैसे पहचानूं?'
            : 'How do I identify powdery mildew early?',
        'answer': isHindi
            ? 'पत्ती की सतह पर सफेद पाउडर जैसे धब्बे देखें। प्रारंभिक चरण में पत्तियां मुड़ सकती हैं।'
            : 'Look for white powdery spots on leaf surfaces. Leaves may curl in early stages.',
        'category': isHindi ? 'रोग' : 'Diseases',
      },
      {
        'question': isHindi
            ? 'पौधों के बीच कितनी दूरी रखनी चाहिए?'
            : 'What spacing should I maintain between plants?',
        'answer': isHindi
            ? 'पंक्तियों के बीच 60 सेमी और पौधों के बीच 45 सेमी की दूरी रखें।'
            : 'Maintain 60cm between rows and 45cm between plants.',
        'category': isHindi ? 'रोपण' : 'Planting',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'अक्सर पूछे जाने वाले प्रश्न' : 'FAQs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                faq['question'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    faq['category'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    faq['answer'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
