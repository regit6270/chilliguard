import 'package:chilliguard/l10n/app_localizations.dart'; // ignore: unused_import
import 'package:flutter/material.dart';

class FeasibilityCheckScreen extends StatefulWidget {
  const FeasibilityCheckScreen({super.key});

  @override
  State<FeasibilityCheckScreen> createState() => _FeasibilityCheckScreenState();
}

class _FeasibilityCheckScreenState extends State<FeasibilityCheckScreen> {
  bool _isChecking = false;
  Map<String, dynamic>? _result;

  // Mock sensor values - replace with actual sensor data
  final Map<String, double> _sensorValues = {
    'pH': 6.5,
    'nitrogen': 45.0,
    'phosphorus': 38.0,
    'potassium': 42.0,
    'moisture': 65.0,
    'temperature': 28.0,
  };

  void _performCheck() async {
    setState(() => _isChecking = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock feasibility calculation
    final result = _calculateFeasibility();

    setState(() {
      _isChecking = false;
      _result = result;
    });
  }

  Map<String, dynamic> _calculateFeasibility() {
    int score = 0;
    final issues = <String>[];
    final recommendations = <String>[];

    // pH Check
    final pH = _sensorValues['pH']!;
    if (pH >= 6.0 && pH <= 7.0) {
      score += 20;
    } else {
      issues.add('pH not optimal');
      recommendations.add('Adjust soil pH to 6.0-7.0 range');
    }

    // NPK Check
    final n = _sensorValues['nitrogen']!;
    final p = _sensorValues['phosphorus']!;
    final k = _sensorValues['potassium']!;

    if (n >= 40 && n <= 60) {
      score += 20;
    } else {
      issues.add('Nitrogen levels not optimal');
      recommendations.add('Apply nitrogen-rich fertilizer');
    }

    if (p >= 30 && p <= 50) {
      score += 20;
    } else {
      issues.add('Phosphorus levels need adjustment');
      recommendations.add('Add phosphate fertilizer');
    }

    if (k >= 35 && k <= 55) {
      score += 20;
    } else {
      issues.add('Potassium levels suboptimal');
      recommendations.add('Apply potash fertilizer');
    }

    // Moisture & Temperature
    if (_sensorValues['moisture']! >= 60 && _sensorValues['moisture']! <= 70) {
      score += 10;
    } else {
      issues.add('Soil moisture not ideal');
      recommendations.add('Adjust irrigation schedule');
    }

    if (_sensorValues['temperature']! >= 25 &&
        _sensorValues['temperature']! <= 30) {
      score += 10;
    }

    return {
      'score': score,
      'feasible': score >= 70,
      'issues': issues,
      'recommendations': recommendations,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'व्यवहार्यता जांच' : 'Feasibility Check'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Card(
              color: Colors.blue[50],
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isHindi
                            ? 'यह जांच मिर्च की खेती के लिए आपकी मिट्टी की उपयुक्तता का मूल्यांकन करती है'
                            : 'This check evaluates your soil\'s suitability for chilli cultivation',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Current Values Section
            Text(
              isHindi ? 'वर्तमान मान' : 'Current Values',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildParameterCard(
              label: 'pH',
              value: _sensorValues['pH']!.toStringAsFixed(1),
              optimal: '6.0 - 7.0',
              unit: '',
              icon: Icons.water_drop,
              color: Colors.blue,
            ),
            _buildParameterCard(
              label: isHindi ? 'नाइट्रोजन' : 'Nitrogen',
              value: _sensorValues['nitrogen']!.toStringAsFixed(0),
              optimal: '40 - 60',
              unit: ' ppm',
              icon: Icons.science,
              color: Colors.green,
            ),
            _buildParameterCard(
              label: isHindi ? 'फास्फोरस' : 'Phosphorus',
              value: _sensorValues['phosphorus']!.toStringAsFixed(0),
              optimal: '30 - 50',
              unit: ' ppm',
              icon: Icons.science,
              color: Colors.orange,
            ),
            _buildParameterCard(
              label: isHindi ? 'पोटैशियम' : 'Potassium',
              value: _sensorValues['potassium']!.toStringAsFixed(0),
              optimal: '35 - 55',
              unit: ' ppm',
              icon: Icons.science,
              color: Colors.purple,
            ),

            const SizedBox(height: 30),

            // Check Button
            if (_result == null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : _performCheck,
                  icon: _isChecking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    isHindi ? 'व्यवहार्यता जांचें' : 'Check Feasibility',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

            // Result Section
            if (_result != null) ...[
              _buildResultCard(_result!, isHindi),
              const SizedBox(height: 16),
              if (_result!['issues'].isNotEmpty)
                _buildIssuesSection(_result!['issues'], isHindi),
              const SizedBox(height: 16),
              if (_result!['recommendations'].isNotEmpty)
                _buildRecommendationsSection(
                    _result!['recommendations'], isHindi),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _result = null),
                  icon: const Icon(Icons.refresh),
                  label: Text(isHindi ? 'फिर से जांचें' : 'Check Again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCard({
    required String label,
    required String value,
    required String optimal,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Optimal: $optimal$unit',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$value$unit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result, bool isHindi) {
    final score = result['score'] as int;
    final feasible = result['feasible'] as bool;
    final color = feasible ? Colors.green : Colors.orange;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              feasible ? Icons.check_circle : Icons.warning,
              size: 60,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              feasible
                  ? (isHindi ? 'उपयुक्त' : 'Suitable')
                  : (isHindi ? 'सुधार की आवश्यकता' : 'Needs Improvement'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${isHindi ? 'व्यवहार्यता स्कोर' : 'Feasibility Score'}: $score/100',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesSection(List<dynamic> issues, bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              isHindi ? 'समस्याएं' : 'Issues',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: issues
                  .map((issue) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.close,
                                size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(child: Text(issue as String)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(
      List<dynamic> recommendations, bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              isHindi ? 'सिफारिशें' : 'Recommendations',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: recommendations
                  .map((rec) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check,
                                size: 16, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(child: Text(rec as String)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
