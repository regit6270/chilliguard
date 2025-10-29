import 'package:chilliguard/l10n/app_localizations.dart'; // ignore: unused_import
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleId;

  const ArticleDetailScreen({
    super.key,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with API data
    final article = {
      'title': isHindi
          ? 'मिर्च की पत्तियों पर धब्बे रोग'
          : 'Chilli Leaf Spot Disease',
      'author': 'ICAR Research',
      'publishDate': '15 Jan 2024',
      'readTime': '5 min',
      'category': isHindi ? 'रोग' : 'Diseases',
      'imageUrl': null,
      'content': isHindi
          ? '''
पत्ती धब्बा रोग मिर्च की फसलों को प्रभावित करने वाली सबसे आम बीमारियों में से एक है। यह रोग विभिन्न कवक रोगजनकों के कारण होता है।

## लक्षण

• पत्तियों पर गहरे भूरे या काले धब्बे
• समय के साथ धब्बे बड़े हो जाते हैं
• गंभीर मामलों में पत्तियां गिर जाती हैं
• फल उत्पादन में कमी

## कारण

यह रोग मुख्य रूप से Cercospora और Alternaria कवक के कारण होता है। नम और गर्म मौसम में यह रोग तेजी से फैलता है।

## रोकथाम

1. संक्रमित पौधों के हिस्से हटाएं
2. पौधों के बीच उचित दूरी रखें
3. अधिक सिंचाई से बचें
4. रोग प्रतिरोधी किस्में उगाएं

## उपचार

**रासायनिक:** तांबा आधारित कवकनाशी का छिड़काव करें

**जैविक:** नीम के तेल का प्रयोग करें (5 मिली प्रति लीटर पानी)

## अतिरिक्त सुझाव

• समय-समय पर फसल का निरीक्षण करें
• रोग के शुरुआती संकेतों पर तुरंत कार्रवाई करें
• खेत में स्वच्छता बनाए रखें
'''
          : '''
Leaf spot is one of the most common diseases affecting chilli crops. It is caused by various fungal pathogens.

## Symptoms

• Dark brown or black spots on leaves
• Spots enlarge over time
• Leaves drop in severe cases
• Reduced fruit production

## Causes

This disease is mainly caused by Cercospora and Alternaria fungi. It spreads rapidly in humid and warm weather.

## Prevention

1. Remove infected plant parts
2. Maintain proper spacing between plants
3. Avoid overhead irrigation
4. Grow disease-resistant varieties

## Treatment

**Chemical:** Spray copper-based fungicides

**Organic:** Use neem oil spray (5ml per liter of water)

## Additional Tips

• Regularly inspect your crop
• Act immediately on early signs
• Maintain field hygiene
''',
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  article['category'] as String,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              background: article['imageUrl'] != null
                  ? Image.network(
                      article['imageUrl'] as String,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.article,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article['title'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Meta info
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article['author'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${article['publishDate']} • ${article['readTime']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Content
                  Text(
                    article['content'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Bookmark article
                          },
                          icon: const Icon(Icons.bookmark_border),
                          label: Text(isHindi ? 'सहेजें' : 'Save'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Share article
                          },
                          icon: const Icon(Icons.share),
                          label: Text(isHindi ? 'साझा करें' : 'Share'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
