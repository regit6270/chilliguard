import 'package:chilliguard/l10n/app_localizations.dart'; // ignore: unused_import
import 'package:flutter/material.dart';

import '../../widgets/reports/comparison_chart.dart';

class BatchComparisonScreen extends StatefulWidget {
  final String reportId;

  const BatchComparisonScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<BatchComparisonScreen> createState() => _BatchComparisonScreenState();
}

class _BatchComparisonScreenState extends State<BatchComparisonScreen> {
  String _selectedMetric = 'yield';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with repository data
    final batches = [
      {
        'name': isHindi ? 'बैच 2024-A' : 'Batch 2024-A',
        'yield': 2.5,
        'duration': 120,
        'cost': 45000,
        'revenue': 125000,
        'diseaseCount': 3,
      },
      {
        'name': isHindi ? 'बैच 2023-C' : 'Batch 2023-C',
        'yield': 2.1,
        'duration': 115,
        'cost': 42000,
        'revenue': 105000,
        'diseaseCount': 5,
      },
      {
        'name': isHindi ? 'बैच 2023-B' : 'Batch 2023-B',
        'yield': 2.3,
        'duration': 118,
        'cost': 43000,
        'revenue': 115000,
        'diseaseCount': 4,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'बैच तुलना' : 'Batch Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show batch selector
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metric Selector
            _buildMetricSelector(isHindi),

            const SizedBox(height: 20),

            // Comparison Chart
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ComparisonChart(
                  batches: batches,
                  metric: _selectedMetric,
                  isHindi: isHindi,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Comparison Table
            _buildComparisonTable(batches, isHindi),

            const SizedBox(height: 20),

            // Insights Section
            _buildInsights(batches, isHindi),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricSelector(bool isHindi) {
    final metrics = [
      {
        'id': 'yield',
        'label': isHindi ? 'उपज' : 'Yield',
        'icon': Icons.agriculture
      },
      {
        'id': 'duration',
        'label': isHindi ? 'अवधि' : 'Duration',
        'icon': Icons.timer
      },
      {
        'id': 'revenue',
        'label': isHindi ? 'राजस्व' : 'Revenue',
        'icon': Icons.currency_rupee
      },
      {
        'id': 'disease',
        'label': isHindi ? 'रोग' : 'Diseases',
        'icon': Icons.bug_report
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: metrics.map((metric) {
          final isSelected = _selectedMetric == metric['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    metric['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  Text(metric['label'] as String),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedMetric = metric['id'] as String);
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

  Widget _buildComparisonTable(
      List<Map<String, dynamic>> batches, bool isHindi) {
    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
          columns: [
            DataColumn(
              label: Text(
                isHindi ? 'बैच' : 'Batch',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                isHindi ? 'उपज (t)' : 'Yield (t)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                isHindi ? 'दिन' : 'Days',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                isHindi ? 'लागत (₹)' : 'Cost (₹)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                isHindi ? 'राजस्व (₹)' : 'Revenue (₹)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                isHindi ? 'रोग' : 'Diseases',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: batches.map((batch) {
            return DataRow(cells: [
              DataCell(Text(batch['name'] as String)),
              DataCell(Text('${batch['yield']}')),
              DataCell(Text('${batch['duration']}')),
              DataCell(Text(_formatNumber(batch['cost'] as int))),
              DataCell(Text(_formatNumber(batch['revenue'] as int))),
              DataCell(
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDiseaseColor(batch['diseaseCount'] as int),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${batch['diseaseCount']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInsights(List<Map<String, dynamic>> batches, bool isHindi) {
    // Calculate insights
    final bestYield = batches.reduce(
        (a, b) => (a['yield'] as double) > (b['yield'] as double) ? a : b);
    final avgYield =
        batches.fold<double>(0, (sum, b) => sum + (b['yield'] as double)) /
            batches.length;

    return Card(
      elevation: 2,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  isHindi ? 'अंतर्दृष्टि' : 'Insights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              icon: Icons.emoji_events,
              text: isHindi
                  ? '${bestYield['name']} ने सर्वोत्तम उपज प्राप्त की: ${bestYield['yield']} टन'
                  : '${bestYield['name']} achieved best yield: ${bestYield['yield']} tons',
            ),
            const SizedBox(height: 8),
            _buildInsightItem(
              icon: Icons.trending_up,
              text: isHindi
                  ? 'औसत उपज: ${avgYield.toStringAsFixed(2)} टन'
                  : 'Average yield: ${avgYield.toStringAsFixed(2)} tons',
            ),
            const SizedBox(height: 8),
            _buildInsightItem(
              icon: Icons.warning,
              text: isHindi
                  ? 'रोग प्रबंधन में सुधार की आवश्यकता'
                  : 'Disease management needs improvement',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.blue[700]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[900],
            ),
          ),
        ),
      ],
    );
  }

  Color _getDiseaseColor(int count) {
    if (count <= 2) return Colors.green;
    if (count <= 4) return Colors.orange;
    return Colors.red;
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
