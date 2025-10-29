import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/bottom_navigation_bar.dart';
import '../../widgets/knowledge_base/article_card.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with API data
    final articles = [
      {
        'id': 'art_001',
        'title': isHindi
            ? 'मिर्च की पत्तियों पर धब्बे रोग'
            : 'Chilli Leaf Spot Disease',
        'category': 'diseases',
        'readTime': '5 min',
        'author': 'ICAR Research',
        'imageUrl': null,
      },
      {
        'id': 'art_002',
        'title': isHindi ? 'उपयुक्त मृदा pH' : 'Optimal Soil pH',
        'category': 'soil',
        'readTime': '4 min',
        'author': 'Agri Extension',
        'imageUrl': null,
      },
      {
        'id': 'art_003',
        'title': isHindi ? 'जैविक कीट नियंत्रण' : 'Organic Pest Control',
        'category': 'pest-control',
        'readTime': '7 min',
        'author': 'Organic Council',
        'imageUrl': null,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'ज्ञान केंद्र' : 'Knowledge Base'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          _buildCategoryTabs(isHindi),

          // Quick Access Cards
          _buildQuickAccess(context, isHindi),

          const SizedBox(height: 10),

          // Articles List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleCard(
                  title: article['title'] as String,
                  category: article['category'] as String,
                  readTime: article['readTime'] as String,
                  author: article['author'] as String,
                  imageUrl: article['imageUrl'],
                  onTap: () =>
                      context.push('/knowledge-base/article/${article['id']}'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const ChilliGuardBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildCategoryTabs(bool isHindi) {
    final categories = [
      {'id': 'all', 'label': isHindi ? 'सभी' : 'All'},
      {'id': 'diseases', 'label': isHindi ? 'रोग' : 'Diseases'},
      {'id': 'soil', 'label': isHindi ? 'मिट्टी' : 'Soil'},
      {
        'id': 'pest-control',
        'label': isHindi ? 'कीट नियंत्रण' : 'Pest Control'
      },
      {'id': 'fertilizers', 'label': isHindi ? 'उर्वरक' : 'Fertilizers'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category['id'] as String);
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAccessCard(
              context,
              icon: Icons.book,
              label: isHindi ? 'रोग विश्वकोश' : 'Disease Encyclopedia',
              color: Colors.red,
              onTap: () => context.push('/knowledge-base/disease-encyclopedia'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAccessCard(
              context,
              icon: Icons.help_outline,
              label: isHindi ? 'FAQ' : 'FAQs',
              color: Colors.blue,
              onTap: () => context.push('/knowledge-base/faq'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
