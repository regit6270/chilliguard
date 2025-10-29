import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/disease_detection.dart';

part 'disease_detection_model.g.dart';

@JsonSerializable()
class DiseaseDetectionModel {
  @JsonKey(name: 'detection_id')
  final String detectionId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'field_id')
  final String? fieldId;

  @JsonKey(name: 'batch_id')
  final String? batchId;

  @JsonKey(name: 'disease_name')
  final String diseaseName;

  final double confidence;
  final String severity;

  @JsonKey(name: 'affected_area_percent')
  final double affectedAreaPercent;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'model_type')
  final String modelType;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime timestamp;

  const DiseaseDetectionModel({
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

  factory DiseaseDetectionModel.fromJson(Map<String, dynamic> json) =>
      _$DiseaseDetectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiseaseDetectionModelToJson(this);

  DiseaseDetection toEntity() {
    return DiseaseDetection(
      detectionId: detectionId,
      userId: userId,
      fieldId: fieldId,
      batchId: batchId,
      diseaseName: diseaseName,
      confidence: confidence,
      severity: severity,
      affectedAreaPercent: affectedAreaPercent,
      imageUrl: imageUrl,
      modelType: modelType,
      timestamp: timestamp,
    );
  }

  factory DiseaseDetectionModel.fromEntity(DiseaseDetection entity) {
    return DiseaseDetectionModel(
      detectionId: entity.detectionId,
      userId: entity.userId,
      fieldId: entity.fieldId,
      batchId: entity.batchId,
      diseaseName: entity.diseaseName,
      confidence: entity.confidence,
      severity: entity.severity,
      affectedAreaPercent: entity.affectedAreaPercent,
      imageUrl: entity.imageUrl,
      modelType: entity.modelType,
      timestamp: entity.timestamp,
    );
  }

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();
}
