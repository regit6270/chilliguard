// lib/widgets/camera/detection_result_card.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/disease_detection.dart';

class DetectionResultCard extends StatelessWidget {
  final DiseaseDetection detection;
  final VoidCallback? onViewTreatment;

  const DetectionResultCard({super.key, required this.detection, this.onViewTreatment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: detection.isHealthy ? Colors.green.shade50 : Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
              child: Icon(detection.isHealthy ? Icons.check_circle : Icons.warning_amber_rounded, color: detection.isHealthy ? Colors.green : Colors.orange, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(detection.diseaseName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _infoColumn('Confidence', '${(detection.confidence * 100).toStringAsFixed(1)}%'),
            _infoColumn('Severity', detection.severity),
            _infoColumn('Affected', '${detection.affectedAreaPercent.toStringAsFixed(0)}%'),
          ]),
          if (onViewTreatment != null && !detection.isHealthy) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: onViewTreatment, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('View Treatment Options')),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    ]);
  }
}
