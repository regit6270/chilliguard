import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

class FeasibilityCard extends StatelessWidget {
  final double score;
  final String status;
  final VoidCallback? onTap;

  const FeasibilityCard({super.key, required this.score, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: (config['gradient'] as List<Color>), begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: (config['gradient'] as List<Color>)[0].withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 8))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Feasibility Score', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            Icon(config['icon'] as IconData, color: Colors.white, size: 28),
          ]),
          const SizedBox(height: 14),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(score.toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            const Padding(padding: EdgeInsets.only(bottom: 8, left: 6), child: Text('/100', style: TextStyle(color: Colors.white70, fontSize: 20))),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
            child: Text(config['label'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          Text(_getStatusMessage(), style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 16),
          if (score < 75)
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white)),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: (config['gradient'] as List<Color>)[0]),
                  child: const Text('Improve'),
                ),
              ),
            ])
          else
            Row(children: [
              Text('View Details', style: TextStyle(color: Colors.white.withOpacity(0.95))),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white.withOpacity(0.95)),
            ]),
        ]),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig() {
    switch (status) {
      case 'ready':
        return {
          'label': '✓ Ready to Plant',
          'icon': Icons.check_circle_outline,
          'gradient': [StatusColors.optimal, StatusColors.optimal.withOpacity(0.85)]
        };
      case 'minor_adjustments':
        return {
          'label': '⚠ Minor Adjustments',
          'icon': Icons.warning_amber_outlined,
          'gradient': [StatusColors.acceptable, StatusColors.acceptable.withOpacity(0.85)]
        };
      default:
        return {
          'label': '✗ Needs Improvement',
          'icon': Icons.error_outline,
          'gradient': [StatusColors.needsAttention, StatusColors.needsAttention.withOpacity(0.85)]
        };
    }
  }

  String _getStatusMessage() {
    if (score >= 75) return 'Your soil is ready for chilli cultivation. You can start sowing!';
    if (score >= 50) return 'Minor adjustments needed. View recommendations to improve.';
    return 'Significant improvements required before sowing.';
  }
}
