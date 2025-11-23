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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with API data
    final articles = [
      {
        'id': 'art_001',
        'title': isHindi ? 'मिर्च की पत्तियों पर धब्बे रोग' : 'Chilli Leaf Spot Disease',
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
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // focus the search field
              _openSearchSheet(context, isHindi);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header + subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'फसल ज्ञान' : 'Crop Knowledge',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isHindi
                              ? 'रोग, मिट्टी और कीट नियंत्रण से संबंधित लेख'
                              : 'Articles about diseases, soil and pest control',
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Access grid (compact)
            Padding(
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
                      label: isHindi ? 'सामान्य प्रश्न' : 'FAQs',
                      color: Colors.blue,
                      onTap: () => context.push('/knowledge-base/faq'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Category chips (wrap)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildCategoryChips(isHindi),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Articles list title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    isHindi ? 'नवीनतम लेख' : 'Latest articles',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  // simple clear filter button
                  if (_selectedCategory != 'all')
                    TextButton(
                      onPressed: () => setState(() => _selectedCategory = 'all'),
                      child: Text(isHindi ? 'सभी दिखाएं' : 'Show all'),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Articles list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  // category filter applied
                  if (_selectedCategory != 'all' &&
                      (article['category'] as String) != _selectedCategory) {
                    return const SizedBox.shrink();
                  }
                  return ArticleCard(
                    title: article['title'] as String,
                    category: article['category'] as String,
                    readTime: article['readTime'] as String,
                    author: article['author'] as String,
                    imageUrl: article['imageUrl'],
                    onTap: () => context.push('/article/${article['id']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ChilliGuardBottomNavigationBar(currentIndex: 3),
    );
  }

  List<Widget> _buildCategoryChips(bool isHindi) {
    final categories = [
      {'id': 'all', 'label': isHindi ? 'सभी' : 'All'},
      {'id': 'diseases', 'label': isHindi ? 'रोग' : 'Diseases'},
      {'id': 'soil', 'label': isHindi ? 'मिट्टी' : 'Soil'},
      {'id': 'pest-control', 'label': isHindi ? 'कीट' : 'Pest Control'},
      {'id': 'fertilizers', 'label': isHindi ? 'उर्वरक' : 'Fertilizers'},
    ];

    return categories.map((category) {
      final isSelected = _selectedCategory == category['id'];
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(category['label'] as String),
          selected: isSelected,
          onSelected: (_) {
            setState(() => _selectedCategory = category['id'] as String);
          },
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.grey[100],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
    }).toList();
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _openSearchSheet(BuildContext context, bool isHindi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: isHindi ? 'खोजें...' : 'Search articles...',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  // TODO: implement live search
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
