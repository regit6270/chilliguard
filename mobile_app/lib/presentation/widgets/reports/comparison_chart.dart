import 'package:flutter/material.dart';

class ComparisonChart extends StatelessWidget {
  final List<Map<String, dynamic>> batches;
  final String metric;
  final bool isHindi;

  const ComparisonChart({
    super.key,
    required this.batches,
    required this.metric,
    required this.isHindi,
  });

  @override
  Widget build(BuildContext context) {
    final values = batches.map((b) => _getMetricValue(b, metric)).toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart Title
        Text(
          _getChartTitle(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Bar Chart
        ...batches.asMap().entries.map((entry) {
          final index = entry.key;
          final batch = entry.value;
          final value = values[index];
          final percentage = (value / maxValue * 100).clamp(0, 100);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Batch name
                Text(
                  batch['name'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          minHeight: 30,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getMetricColor(metric),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 60,
                      child: Text(
                        _formatValue(value, metric),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _getMetricColor(metric),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  double _getMetricValue(Map<String, dynamic> batch, String metric) {
    switch (metric) {
      case 'yield':
        return (batch['yield'] as num).toDouble();
      case 'duration':
        return (batch['duration'] as num).toDouble();
      case 'revenue':
        return (batch['revenue'] as num).toDouble() /
            1000; // Convert to thousands
      case 'disease':
        return (batch['diseaseCount'] as num).toDouble();
      default:
        return 0;
    }
  }

  String _getChartTitle() {
    switch (metric) {
      case 'yield':
        return isHindi ? 'उपज तुलना (टन)' : 'Yield Comparison (tons)';
      case 'duration':
        return isHindi ? 'अवधि तुलना (दिन)' : 'Duration Comparison (days)';
      case 'revenue':
        return isHindi ? 'राजस्व तुलना (₹000)' : 'Revenue Comparison (₹000)';
      case 'disease':
        return isHindi ? 'रोग घटनाएं' : 'Disease Incidents';
      default:
        return 'Comparison';
    }
  }

  Color _getMetricColor(String metric) {
    switch (metric) {
      case 'yield':
        return Colors.green;
      case 'duration':
        return Colors.blue;
      case 'revenue':
        return Colors.purple;
      case 'disease':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatValue(double value, String metric) {
    switch (metric) {
      case 'yield':
        return '${value.toStringAsFixed(1)} t';
      case 'duration':
        return '${value.toInt()} d';
      case 'revenue':
        return '₹${value.toInt()}k';
      case 'disease':
        return value.toInt().toString();
      default:
        return value.toString();
    }
  }
}
