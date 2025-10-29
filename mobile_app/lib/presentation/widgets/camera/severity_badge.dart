import 'package:flutter/material.dart';

class SeverityBadge extends StatelessWidget {
  final String severity;

  const SeverityBadge({
    super.key,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getSeverityConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config['color'],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config['icon'] as IconData,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            config['label'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getSeverityConfig() {
    switch (severity.toLowerCase()) {
      case 'low':
        return {
          'label': 'Low',
          'color': Colors.yellow[700],
          'icon': Icons.info_outline,
        };
      case 'medium':
        return {
          'label': 'Medium',
          'color': Colors.orange,
          'icon': Icons.warning_amber,
        };
      case 'high':
        return {
          'label': 'High',
          'color': Colors.red,
          'icon': Icons.error_outline,
        };
      default:
        return {
          'label': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };
    }
  }
}
