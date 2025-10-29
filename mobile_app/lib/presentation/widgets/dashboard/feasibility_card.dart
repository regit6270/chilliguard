import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

class FeasibilityCard extends StatelessWidget {
  final double score;
  final String status;
  final VoidCallback? onTap; // NEW: Single tap handler

  const FeasibilityCard({
    super.key,
    required this.score,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = _getStatusConfig();

    // NEW: Modern gradient card design (Zepto-style)
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: config['gradient'] as List<Color>,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (config['gradient'] as List<Color>)[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.feasibilityScore ?? 'Feasibility Score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  config['icon'] as IconData,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // NEW: Large score display
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  score.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 4),
                  child: Text(
                    '/100',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                config['label'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // EXISTING: Status Message
            Text(
              _getStatusMessage(context),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 16),

            // EXISTING: Action buttons (conditional)
            if (score < 75)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: Text(l10n.viewDetails ?? 'View Details'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: (config['gradient'] as List<Color>)[0],
                      ),
                      child: Text(l10n.improve ?? 'Improve'),
                    ),
                  ),
                ],
              )
            else
              // NEW: Arrow link for ready state
              Row(
                children: [
                  Text(
                    l10n.viewDetails ?? 'View Details',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white.withOpacity(0.9),
                    size: 16,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig() {
    switch (status) {
      case 'ready':
        return {
          'label': '✓ Ready to Plant',
          'icon': Icons.check_circle,
          'gradient': [
            StatusColors.optimal,
            StatusColors.optimal.withOpacity(0.8)
          ],
        };
      case 'minor_adjustments':
        return {
          'label': '⚠ Minor Adjustments',
          'icon': Icons.warning_amber,
          'gradient': [
            StatusColors.acceptable,
            StatusColors.acceptable.withOpacity(0.8)
          ],
        };
      default:
        return {
          'label': '✗ Needs Improvement',
          'icon': Icons.error,
          'gradient': [
            StatusColors.needsAttention,
            StatusColors.needsAttention.withOpacity(0.8)
          ],
        };
    }
  }

  String _getStatusMessage(BuildContext context) {
    if (score >= 75) {
      return 'Your soil is ready for chilli cultivation. You can start sowing!';
    } else if (score >= 50) {
      return 'Minor adjustments needed. View recommendations to improve.';
    } else {
      return 'Significant improvements required before sowing.';
    }
  }
}
