// lib/widgets/camera/confidence_indicator.dart
import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double confidence;
  final String modelType;

  const ConfidenceIndicator({
    super.key,
    required this.confidence,
    required this.modelType,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (confidence * 100).toStringAsFixed(0);
    final color = _getConfidenceColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Stack(alignment: Alignment.center, children: [
          SizedBox(width: 36, height: 36, child: CircularProgressIndicator(value: confidence.clamp(0.0, 1.0), strokeWidth: 3, valueColor: const AlwaysStoppedAnimation(Colors.white))),
          Text('$percentage%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ]),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(confidence >= 0.8 ? 'High confidence' : (confidence >= 0.6 ? 'Medium confidence' : 'Low confidence'),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          Text(modelType.toLowerCase() == 'cloud' ? 'Cloud model' : 'On-device', style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ]),
      ]),
    );
  }

  Color _getConfidenceColor() {
    if (confidence >= 0.8) return Colors.green.shade700;
    if (confidence >= 0.6) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}
