import 'package:flutter/material.dart';

import '../../../domain/entities/alert.dart';

class AlertListItem extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onTap;

  const AlertListItem({super.key, required this.alert, this.onTap});

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor();
    final severityIcon = _getSeverityIcon();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: severityColor.withOpacity(0.85), shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(alert.parameter, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            const SizedBox(width: 10),
            Icon(severityIcon, color: severityColor.withOpacity(0.9), size: 20),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  IconData _getSeverityIcon() {
    switch (alert.severity.toLowerCase()) {
      case 'critical':
        return Icons.error;
      case 'high':
        return Icons.report_problem;
      default:
        return Icons.info;
    }
  }

  Color _getSeverityColor() {
    switch (alert.severity.toLowerCase()) {
      case 'critical':
        return Colors.red.shade700;
      case 'high':
        return Colors.orange.shade700;
      default:
        return Colors.blue.shade600;
    }
  }
}
