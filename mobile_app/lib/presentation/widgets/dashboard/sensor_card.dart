import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

enum SensorStatus { optimal, acceptable, critical }

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final SensorStatus status;
  final IconData icon;
  final VoidCallback? onTap;

  const SensorCard({super.key, required this.title, required this.value, required this.unit, required this.status, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              Icon(icon, size: 20, color: statusColor),
            ]),
            const Spacer(),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.neutralGray)),
                if (unit.isNotEmpty) TextSpan(text: ' $unit', style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            const SizedBox(height: 6),
            Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            const Spacer(),
          ]),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case SensorStatus.optimal:
        return StatusColors.optimal;
      case SensorStatus.acceptable:
        return StatusColors.acceptable;
      case SensorStatus.critical:
        return StatusColors.critical;
    }
  }
}
