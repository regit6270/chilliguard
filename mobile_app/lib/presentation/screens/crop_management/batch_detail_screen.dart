import 'package:chilliguard/l10n/app_localizations.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BatchDetailScreen extends StatelessWidget {
  final String batchId;

  const BatchDetailScreen({
    super.key,
    required this.batchId,
  });

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with BLoC data
    final batch = {
      'id': batchId,
      'name': isHindi ? 'मिर्च बैच 2024-A' : 'Chilli Batch 2024-A',
      'fieldName': isHindi ? 'मुख्य खेत' : 'Main Field',
      'variety': 'G4',
      'status': 'active',
      'startDate': '2024-01-15',
      'expectedHarvest': '2024-05-15',
      'daysElapsed': 45,
      'totalDays': 120,
      'area': 2.5,
      'plantCount': 5000,
      'healthScore': 85,
      'diseaseIncidents': 2,
      'lastWatering': '2 hours ago',
      'lastFertilizer': '3 days ago',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(batch['name'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit batch
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.download),
                  title: Text(
                      isHindi ? 'रिपोर्ट डाउनलोड करें' : 'Download Report'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    isHindi ? 'बैच हटाएं' : 'Delete Batch',
                    style: const TextStyle(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            _buildStatusBanner(context, batch['status'] as String, isHindi),

            // Progress Card
            _buildProgressCard(context, batch, isHindi),

            const SizedBox(height: 16),

            // Quick Stats
            _buildQuickStats(context, batch, isHindi),

            const SizedBox(height: 16),

            // Timeline Section
            _buildTimelineSection(context, isHindi),

            const SizedBox(height: 16),

            // Actions Section
            _buildActionsSection(context, isHindi),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, String status, bool isHindi) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'active':
        color = Colors.green;
        label = isHindi ? 'सक्रिय' : 'Active';
        icon = Icons.check_circle;
        break;
      case 'completed':
        color = Colors.blue;
        label = isHindi ? 'पूर्ण' : 'Completed';
        icon = Icons.done_all;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.info;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: color.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    Map<String, dynamic> batch,
    bool isHindi,
  ) {
    final progress =
        (batch['daysElapsed'] as int) / (batch['totalDays'] as int);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isHindi ? 'फसल प्रगति' : 'Crop Progress',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${batch['daysElapsed']} ${isHindi ? 'दिन' : 'days'}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  '${batch['totalDays']} ${isHindi ? 'दिन' : 'days'}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  '${isHindi ? 'अपेक्षित कटाई' : 'Expected harvest'}: ${batch['expectedHarvest']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    Map<String, dynamic> batch,
    bool isHindi,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHindi ? 'बैच विवरण' : 'Batch Details',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.square_foot,
                  value: '${batch['area']} ha',
                  label: isHindi ? 'क्षेत्र' : 'Area',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.spa,
                  value: '${batch['plantCount']}',
                  label: isHindi ? 'पौधे' : 'Plants',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.favorite,
                  value: '${batch['healthScore']}%',
                  label: isHindi ? 'स्वास्थ्य' : 'Health',
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.bug_report,
                  value: '${batch['diseaseIncidents']}',
                  label: isHindi ? 'रोग' : 'Diseases',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
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
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection(BuildContext context, bool isHindi) {
    final events = [
      {
        'date': '2024-03-10',
        'title': isHindi ? 'उर्वरक लगाया' : 'Fertilizer Applied',
        'description': 'NPK 19:19:19 - 50 kg',
        'icon': Icons.grass,
        'color': Colors.green,
      },
      {
        'date': '2024-03-05',
        'title': isHindi ? 'रोग पाया गया' : 'Disease Detected',
        'description':
            isHindi ? 'पत्ती धब्बा - उपचारित' : 'Leaf Spot - Treated',
        'icon': Icons.bug_report,
        'color': Colors.red,
      },
      {
        'date': '2024-02-20',
        'title': isHindi ? 'प्रथम सिंचाई' : 'First Irrigation',
        'description': isHindi ? 'ड्रिप प्रणाली' : 'Drip system',
        'icon': Icons.water_drop,
        'color': Colors.blue,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHindi ? 'समयरेखा' : 'Timeline',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...events.map((event) => _buildTimelineItem(event)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (event['color'] as Color).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              event['icon'] as IconData,
              color: event['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['description'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['date'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHindi ? 'त्वरित क्रियाएं' : 'Quick Actions',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.camera_alt,
                  label: isHindi ? 'स्कैन करें' : 'Scan',
                  color: Colors.green,
                  onTap: () => context.push('/camera'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.add_circle,
                  label: isHindi ? 'घटना जोड़ें' : 'Add Event',
                  color: Colors.blue,
                  onTap: () {
                    // TODO: Add event dialog
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
