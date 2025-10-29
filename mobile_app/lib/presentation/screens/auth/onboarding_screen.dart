import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.spa,
      'title': 'Soil Health Monitoring',
      'titleHi': 'मिट्टी स्वास्थ्य निगरानी',
      'description':
          'Real-time monitoring of soil pH, NPK levels, moisture, and temperature',
      'descriptionHi':
          'मिट्टी pH, NPK स्तर, नमी और तापमान की वास्तविक समय निगरानी',
      'color': Colors.green,
    },
    {
      'icon': Icons.camera_alt,
      'title': 'AI Disease Detection',
      'titleHi': 'AI रोग पहचान',
      'description': 'Detect plant diseases instantly using your phone camera',
      'descriptionHi':
          'अपने फोन कैमरे का उपयोग करके तुरंत पौधों की बीमारियों का पता लगाएं',
      'color': Colors.orange,
    },
    {
      'icon': Icons.agriculture,
      'title': 'Crop Lifecycle Management',
      'titleHi': 'फसल जीवनचक्र प्रबंधन',
      'description': 'Track your chilli crop from sowing to harvest',
      'descriptionHi': 'बुवाई से लेकर कटाई तक अपनी मिर्च की फसल को ट्रैक करें',
      'color': Colors.red,
    },
    {
      'icon': Icons.lightbulb,
      'title': 'Smart Recommendations',
      'titleHi': 'स्मार्ट सिफारिशें',
      'description': 'Get personalized farming advice based on your field data',
      'descriptionHi':
          'अपने खेत के डेटा के आधार पर व्यक्तिगत खेती सलाह प्राप्त करें',
      'color': Colors.blue,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  isHindi ? 'छोड़ें' : 'Skip',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(
                    icon: page['icon'],
                    title: isHindi ? page['titleHi'] : page['title'],
                    description:
                        isHindi ? page['descriptionHi'] : page['description'],
                    color: page['color'],
                  );
                },
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDot(index),
              ),
            ),

            const SizedBox(height: 30),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      context.go('/login');
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? (isHindi ? 'शुरू करें' : 'Get Started')
                        : (isHindi ? 'अगला' : 'Next'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: color,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: _currentPage == index ? 30 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
