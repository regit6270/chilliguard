import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final String type;
  final String date;
  final Map<String, String> metadata;
  final String status;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.metadata,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getTypeColor(type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getTypeIcon(type),
                      color: _getTypeColor(type),
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title & Type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getTypeLabel(type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getTypeColor(type),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  if (status == 'completed')
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Metadata
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMetadataChip(Icons.calendar_today, date),
                  ...metadata.entries.map((entry) {
                    return _buildMetadataChip(
                      _getMetadataIcon(entry.key),
                      entry.value,
                    );
                  }),
                ],
              ),

              const SizedBox(height: 12),

              // View Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Report'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'end_cycle':
        return Colors.blue;
      case 'comparison':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'end_cycle':
        return Icons.assessment;
      case 'comparison':
        return Icons.compare_arrows;
      default:
        return Icons.description;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'end_cycle':
        return 'End Cycle';
      case 'comparison':
        return 'Comparison';
      default:
        return 'Report';
    }
  }

  IconData _getMetadataIcon(String key) {
    switch (key) {
      case 'yield':
        return Icons.agriculture;
      case 'duration':
        return Icons.timer;
      case 'batches':
        return Icons.layers;
      default:
        return Icons.info;
    }
  }
}
