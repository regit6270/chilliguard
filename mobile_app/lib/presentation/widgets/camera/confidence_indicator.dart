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
    final percentage = (confidence * 100).toStringAsFixed(1);
    final color = _getConfidenceColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getConfidenceIcon(),
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            modelType == 'cloud' ? '☁' : '📱',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor() {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  IconData _getConfidenceIcon() {
    if (confidence >= 0.8) return Icons.verified;
    if (confidence >= 0.6) return Icons.info;
    return Icons.warning;
  }
}
