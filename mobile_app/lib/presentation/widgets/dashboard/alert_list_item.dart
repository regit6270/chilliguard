import 'package:flutter/material.dart';

import '../../../domain/entities/alert.dart';

class AlertListItem extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onTap;

  const AlertListItem({
    super.key,
    required this.alert,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _getSeverityIcon(),
              color: _getSeverityColor(),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.parameter,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    alert.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  IconData _getSeverityIcon() {
    switch (alert.severity) {
      case 'critical':
        return Icons.error;
      case 'high':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  Color _getSeverityColor() {
    switch (alert.severity) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
