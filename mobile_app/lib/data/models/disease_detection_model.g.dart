// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_detection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiseaseDetectionModel _$DiseaseDetectionModelFromJson(
        Map<String, dynamic> json) =>
    DiseaseDetectionModel(
      detectionId: json['detection_id'] as String,
      userId: json['user_id'] as String,
      fieldId: json['field_id'] as String?,
      batchId: json['batch_id'] as String?,
      diseaseName: json['disease_name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      severity: json['severity'] as String,
      affectedAreaPercent: (json['affected_area_percent'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      modelType: json['model_type'] as String,
      timestamp: DiseaseDetectionModel._dateTimeFromJson(json['timestamp']),
    );

Map<String, dynamic> _$DiseaseDetectionModelToJson(
        DiseaseDetectionModel instance) =>
    <String, dynamic>{
      'detection_id': instance.detectionId,
      'user_id': instance.userId,
      'field_id': instance.fieldId,
      'batch_id': instance.batchId,
      'disease_name': instance.diseaseName,
      'confidence': instance.confidence,
      'severity': instance.severity,
      'affected_area_percent': instance.affectedAreaPercent,
      'image_url': instance.imageUrl,
      'model_type': instance.modelType,
      'timestamp': DiseaseDetectionModel._dateTimeToJson(instance.timestamp),
    };
