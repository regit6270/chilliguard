// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CropBatchModel _$CropBatchModelFromJson(Map<String, dynamic> json) =>
    CropBatchModel(
      batchId: json['batch_id'] as String,
      userId: json['user_id'] as String,
      fieldId: json['field_id'] as String,
      cropType: json['crop_type'] as String,
      plantingDate: CropBatchModel._dateFromJson(json['planting_date']),
      estimatedHarvestDate:
          CropBatchModel._dateFromJsonNullable(json['estimated_harvest_date']),
      actualHarvestDate:
          CropBatchModel._dateFromJsonNullable(json['actual_harvest_date']),
      area: CropBatchModel._doubleFromJson(json['area']),
      seedVariety: json['seed_variety'] as String?,
      status: json['status'] as String,
      healthScore: CropBatchModel._healthScoreFromJson(json['health_score']),
      createdAt: CropBatchModel._dateFromJsonWithDefault(json['created_at']),
    );

Map<String, dynamic> _$CropBatchModelToJson(CropBatchModel instance) =>
    <String, dynamic>{
      'batch_id': instance.batchId,
      'user_id': instance.userId,
      'field_id': instance.fieldId,
      'crop_type': instance.cropType,
      'planting_date': CropBatchModel._dateToJson(instance.plantingDate),
      'estimated_harvest_date':
          CropBatchModel._dateToJsonNullable(instance.estimatedHarvestDate),
      'actual_harvest_date':
          CropBatchModel._dateToJsonNullable(instance.actualHarvestDate),
      'area': instance.area,
      'seed_variety': instance.seedVariety,
      'status': instance.status,
      'health_score': instance.healthScore,
      'created_at': CropBatchModel._dateToJson(instance.createdAt),
    };
