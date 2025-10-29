import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

// NEW: Type-safe enum
enum SensorStatus { optimal, acceptable, critical }

class SensorCard extends StatelessWidget {
  final String title; // Changed from 'parameter' for clarity
  final String value;
  final String unit;
  final SensorStatus status; // NEW: Enum instead of String
  final IconData icon;
  final VoidCallback? onTap;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Indicator & Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    icon,
                    size: 20,
                    color: _getStatusColor(), // NEW: Icon color matches status
                  ),
                ],
              ),

              const Spacer(),

              // Value
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralGray,
                          ),
                    ),
                    if (unit.isNotEmpty)
                      TextSpan(
                        text: ' $unit',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Parameter Name
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),
            ],
          ),
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
