// end_cycle_report_screen.dart
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

    // space reserved at bottom so FAB doesn't overlap content
    const double bottomFabPadding = 110;

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'फसल चक्र रिपोर्ट' : 'End Cycle Report'),
        centerTitle: false,
        elevation: 0,
        
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf),
          label: Text(isHindi ? 'PDF डाउनलोड' : 'Download PDF'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(16, 12, 16, bottomFabPadding), // reserve space for FAB
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER CARD
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Accent bar
                        Container(
                          width: 8,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(colors: [
                              Theme.of(context).colorScheme.primary
                                  .withOpacity(0.95),
                              Theme.of(context).colorScheme.primary
                                  .withOpacity(0.6),
                            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title + meta — flexible to avoid overflow
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title (can wrap to 2 lines)
                              Text(
                                report['batchName'] as String,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // metadata chips - use Wrap so they flow on narrow widths
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _infoChip(
                                    context,
                                    icon: Icons.location_on,
                                    label: report['fieldName'] as String,
                                  ),
                                  _infoChip(
                                    context,
                                    icon: Icons.calendar_today,
                                    label:
                                        '${report['startDate']} • ${report['endDate']}',
                                  ),
                                  _infoChip(
                                    context,
                                    icon: Icons.timer,
                                    label:
                                        '${report['duration']} ${isHindi ? 'दिन' : 'days'}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Right-side small icon to indicate health metric or any other action
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 36,
                          child: Center(
                            child: Icon(Icons.timer, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // METRICS — use Wrap so tiles never force horizontal overflow
               LayoutBuilder(
  builder: (context, constraints) {
    final double tileWidth = (constraints.maxWidth - 12) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: tileWidth,
          child: _metricTileCompact(
            icon: Icons.agriculture,
            title: isHindi ? 'कुल उपज' : 'Total Yield',
            value: '${report['totalYield']} t',
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: tileWidth,
          child: _metricTileCompact(
            icon: Icons.show_chart,
            title: isHindi ? 'प्रति हेक्टेयर' : 'Per Hectare',
            value: '${report['yieldPerHectare']} t/ha',
            color: Colors.blue,
          ),
        ),
        SizedBox(
          width: tileWidth,
          child: _metricTileCompact(
            icon: Icons.bug_report,
            title: isHindi ? 'रोग घटनाएं' : 'Disease Incidents',
            value: '${report['diseaseIncidents']}',
            color: Colors.red,
          ),
        ),
        SizedBox(
          width: tileWidth,
          child: _metricTileCompact(
            icon: Icons.pest_control,
            title: isHindi ? 'कीट घटनाएं' : 'Pest Incidents',
            value: '${report['pestIncidents']}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  },
),
                const SizedBox(height: 20),

                // FINANCIAL SUMMARY
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        _financialRow(
                          context,
                          label: isHindi ? 'कुल लागत' : 'Total Cost',
                          value: '₹${_formatNumber(report['totalCost'] as int)}',
                          color: Colors.red,
                        ),
                        Divider(height: 24, color: Colors.grey.shade200),
                        _financialRow(
                          context,
                          label: isHindi ? 'राजस्व' : 'Revenue',
                          value: '₹${_formatNumber(report['revenue'] as int)}',
                          color: Colors.blue,
                        ),
                        Divider(height: 24, color: Colors.grey.shade200),
                        _financialRow(
                          context,
                          label: isHindi ? 'लाभ' : 'Profit',
                          value: '₹${_formatNumber(report['profit'] as int)}',
                          color: Colors.green,
                          isBold: true,
                        ),
                        Divider(height: 24, color: Colors.grey.shade200),
                        _financialRow(
                          context,
                          label: isHindi ? 'ROI' : 'ROI',
                          value: '${report['roi']}%',
                          color: Colors.purple,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ACTIONS — adapt layout to width
                if (isWide)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.print_outlined),
                          label: Text(isHindi ? 'प्रिंट करें' : 'Print'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.green.shade800,
                            side: BorderSide(color: Colors.green.shade800, width: 1.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          label: Text(isHindi ? 'साझा करें' : 'Share'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // vertically stacked for narrow screens
                  Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.print_outlined),
                        label: Text(isHindi ? 'प्रिंट करें' : 'Print'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          foregroundColor: Colors.green.shade800,
                          side: BorderSide(color: Colors.green.shade800, width: 1.6),
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        label: Text(isHindi ? 'साझा करें' : 'Share'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.green.shade700,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 28),
              ],
            ),
          );
        }),
      ),
    );
  }

  // compact metric tile — consistent width, flows with Wrap
  Widget _metricTileCompact({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width:  (160), // small fixed width so wrap works predictably
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, size: 18, color: color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(value,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context,
      {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[700]),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _financialRow(BuildContext context,
      {required String label,
      required String value,
      required Color color,
      bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: isBold ? 16 : 14,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 16 : 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
