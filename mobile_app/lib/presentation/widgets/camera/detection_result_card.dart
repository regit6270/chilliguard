import 'package:flutter/material.dart';

import '../../../domain/entities/disease_detection.dart';

class DetectionResultCard extends StatelessWidget {
  final DiseaseDetection detection;
  final VoidCallback? onViewTreatment;

  const DetectionResultCard({
    super.key,
    required this.detection,
    this.onViewTreatment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  detection.isHealthy
                      ? Icons.check_circle
                      : Icons.warning_amber,
                  color: detection.isHealthy ? Colors.green : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    detection.diseaseName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Confidence',
                '${(detection.confidence * 100).toStringAsFixed(1)}%'),
            _buildInfoRow('Severity', detection.severity),
            _buildInfoRow('Affected Area',
                '${detection.affectedAreaPercent.toStringAsFixed(0)}%'),
            if (onViewTreatment != null && !detection.isHealthy) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onViewTreatment,
                  child: const Text('View Treatment Options'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
