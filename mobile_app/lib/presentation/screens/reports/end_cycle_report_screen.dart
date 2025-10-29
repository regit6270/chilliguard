import 'package:chilliguard/l10n/app_localizations.dart'; // ignore: unused_import
import 'package:flutter/material.dart';

class EndCycleReportScreen extends StatelessWidget {
  final String reportId;

  const EndCycleReportScreen({
    super.key,
    required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with repository data
    final report = {
      'batchName': isHindi ? 'मिर्च बैच 2024-A' : 'Chilli Batch 2024-A',
      'fieldName': isHindi ? 'मुख्य खेत' : 'Main Field',
      'startDate': '2023-11-15',
      'endDate': '2024-03-15',
      'duration': 120,
      'totalYield': 2.5,
      'yieldPerHectare': 1.25,
      'diseaseIncidents': 3,
      'pestIncidents': 2,
      'totalCost': 45000,
      'revenue': 125000,
      'profit': 80000,
      'roi': 177.8,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'फसल चक्र रिपोर्ट' : 'End Cycle Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share report
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Download PDF
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report['batchName'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          report['fieldName'] as String,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.calendar_today,
                          label:
                              '${report['startDate']} to ${report['endDate']}',
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          icon: Icons.timer,
                          label:
                              '${report['duration']} ${isHindi ? 'दिन' : 'days'}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Yield Section
            _buildSectionHeader(isHindi ? 'उपज सारांश' : 'Yield Summary'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    icon: Icons.agriculture,
                    value: '${report['totalYield']} t',
                    label: isHindi ? 'कुल उपज' : 'Total Yield',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    icon: Icons.show_chart,
                    value: '${report['yieldPerHectare']} t/ha',
                    label: isHindi ? 'प्रति हेक्टेयर' : 'Per Hectare',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Health Summary
            _buildSectionHeader(
                isHindi ? 'स्वास्थ्य सारांश' : 'Health Summary'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    icon: Icons.bug_report,
                    value: '${report['diseaseIncidents']}',
                    label: isHindi ? 'रोग घटनाएं' : 'Disease Incidents',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    icon: Icons.pest_control,
                    value: '${report['pestIncidents']}',
                    label: isHindi ? 'कीट घटनाएं' : 'Pest Incidents',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Financial Summary
            _buildSectionHeader(
                isHindi ? 'वित्तीय सारांश' : 'Financial Summary'),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFinancialRow(
                      isHindi ? 'कुल लागत' : 'Total Cost',
                      '₹${_formatNumber(report['totalCost'] as int)}',
                      Colors.red,
                    ),
                    const Divider(height: 24),
                    _buildFinancialRow(
                      isHindi ? 'राजस्व' : 'Revenue',
                      '₹${_formatNumber(report['revenue'] as int)}',
                      Colors.blue,
                    ),
                    const Divider(height: 24),
                    _buildFinancialRow(
                      isHindi ? 'लाभ' : 'Profit',
                      '₹${_formatNumber(report['profit'] as int)}',
                      Colors.green,
                      isBold: true,
                    ),
                    const Divider(height: 24),
                    _buildFinancialRow(
                      isHindi ? 'ROI' : 'ROI',
                      '${report['roi']}%',
                      Colors.purple,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Export Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Export as PDF
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(
                  isHindi ? 'PDF डाउनलोड करें' : 'Download PDF',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
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
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
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

  Widget _buildFinancialRow(String label, String value, Color color,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
