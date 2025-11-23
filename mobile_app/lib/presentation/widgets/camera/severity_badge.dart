// lib/widgets/camera/severity_badge.dart
import 'package:flutter/material.dart';

class SeverityBadge extends StatelessWidget {
  final String severity;

  const SeverityBadge({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    final config = _getSeverityConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (config['color'] as Color).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config['icon'] as IconData, size: 14, color: config['color'] as Color),
          const SizedBox(width: 8),
          Text(
            config['label'] as String,
            style: const TextStyle(
              color: Colors.black87, // darker for readability
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getSeverityConfig() {
    switch (severity.toLowerCase()) {
      case 'low':
        return {'label': 'Low', 'color': Colors.green.shade700, 'icon': Icons.info_outline};
      case 'medium':
        return {'label': 'Medium', 'color': Colors.orange.shade700, 'icon': Icons.error_outline};
      case 'high':
        return {'label': 'High', 'color': Colors.red.shade700, 'icon': Icons.warning_amber_outlined};
      case 'critical':
        return {'label': 'Critical', 'color': Colors.red.shade900, 'icon': Icons.dangerous};
      default:
        return {'label': 'Unknown', 'color': Colors.grey.shade700, 'icon': Icons.help_outline};
    }
  }
}
