import 'package:equatable/equatable.dart';

class DiseaseDetection extends Equatable {
  final String detectionId;
  final String userId;
  final String? fieldId;
  final String? batchId;
  final String diseaseName;
  final double confidence;
  final String severity; // mild, moderate, severe
  final double affectedAreaPercent;
  final String? imageUrl;
  final String modelType; // device or cloud
  final DateTime timestamp;

  const DiseaseDetection({
    required this.detectionId,
    required this.userId,
    this.fieldId,
    this.batchId,
    required this.diseaseName,
    required this.confidence,
    required this.severity,
    required this.affectedAreaPercent,
    this.imageUrl,
    required this.modelType,
    required this.timestamp,
  });

  bool get isHealthy => diseaseName.toLowerCase() == 'healthy';

  bool get isCritical => severity == 'severe' && confidence > 0.8;

  @override
  List<Object?> get props => [
        detectionId,
        userId,
        fieldId,
        batchId,
        diseaseName,
        confidence,
        severity,
        affectedAreaPercent,
        imageUrl,
        modelType,
        timestamp,
      ];
}
