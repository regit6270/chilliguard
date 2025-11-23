import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/bottom_navigation_bar.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    final faqs = [
      {
        'q': isHindi ? 'कैसे रोग रिपोर्ट करें?' : 'How do I report a disease?',
        'a': isHindi
            ? 'आप कैमरे से फोटो लें और डिटेक्ट फ़ीचर का उपयोग करें।'
            : 'Take a photo and use the detect feature in the app.',
      },
      {
        'q': isHindi ? 'मैं किससे संपर्क करूं?' : 'Who should I contact?',
        'a': isHindi ? 'स्थानीय कृषि कार्यालय से संपर्क करें।' : 'Contact your local agri extension.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'सामान्य प्रश्न' : 'FAQs'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ExpansionTile(
            title: Text(faq['q'] as String),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(faq['a'] as String),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // extra: navigate to knowledge base home
                    context.push('/knowledge-base');
                  },
                  child: Text(isHindi ? 'और पढ़ें' : 'Learn more'),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const ChilliGuardBottomNavigationBar(currentIndex: 3),
    );
  }
}
