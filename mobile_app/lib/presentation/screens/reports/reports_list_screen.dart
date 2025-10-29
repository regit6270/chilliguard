import 'package:chilliguard/l10n/app_localizations.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/reports/report_card.dart';

class ReportsListScreen extends StatelessWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with repository data
    final reports = [
      {
        'id': 'report_001',
        'title': isHindi ? 'मिर्च बैच 2024-A' : 'Chilli Batch 2024-A',
        'type': 'end_cycle',
        'date': '2024-03-15',
        'yield': '2.5 tons',
        'duration': '120 days',
        'status': 'completed',
      },
      {
        'id': 'report_002',
        'title': isHindi ? 'मिर्च बैच 2023-C' : 'Chilli Batch 2023-C',
        'type': 'end_cycle',
        'date': '2023-12-20',
        'yield': '2.1 tons',
        'duration': '115 days',
        'status': 'completed',
      },
      {
        'id': 'report_003',
        'title': isHindi
            ? 'बैच तुलना: 2023 vs 2024'
            : 'Batch Comparison: 2023 vs 2024',
        'type': 'comparison',
        'date': '2024-03-20',
        'batches': '5 batches',
        'status': 'available',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'रिपोर्ट' : 'Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(context, isHindi),

          const SizedBox(height: 16),

          // Reports List
          Expanded(
            child: reports.isEmpty
                ? _buildEmptyState(context, isHindi)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return ReportCard(
                        title: report['title'] as String,
                        type: report['type'] as String,
                        date: report['date'] as String,
                        metadata: _getMetadata(report),
                        status: report['status'] as String,
                        onTap: () {
                          if (report['type'] == 'end_cycle') {
                            context.push('/reports/end-cycle/${report['id']}');
                          } else if (report['type'] == 'comparison') {
                            context.push('/reports/comparison/${report['id']}');
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              context,
              icon: Icons.assessment,
              value: '12',
              label: isHindi ? 'कुल रिपोर्ट' : 'Total Reports',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context,
              icon: Icons.trending_up,
              value: '+18%',
              label: isHindi ? 'उपज वृद्धि' : 'Yield Growth',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isHindi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              isHindi ? 'कोई रिपोर्ट नहीं' : 'No Reports',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isHindi
                  ? 'फसल चक्र पूरा होने पर रिपोर्ट यहां दिखाई देगी'
                  : 'Reports will appear here when crop cycles complete',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getMetadata(Map<String, dynamic> report) {
    if (report['type'] == 'end_cycle') {
      return {
        'yield': report['yield'] as String,
        'duration': report['duration'] as String,
      };
    } else {
      return {
        'batches': report['batches'] as String,
      };
    }
  }
}
