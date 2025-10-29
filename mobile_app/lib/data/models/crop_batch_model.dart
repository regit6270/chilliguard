import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/crop_batch.dart';

part 'crop_batch_model.g.dart';

@JsonSerializable()
class CropBatchModel {
  @JsonKey(name: 'batch_id')
  final String batchId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'field_id')
  final String fieldId;

  @JsonKey(name: 'crop_type')
  final String cropType;

  @JsonKey(name: 'planting_date', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime plantingDate;

  @JsonKey(
      name: 'estimated_harvest_date',
      fromJson: _dateFromJsonNullable,
      toJson: _dateToJsonNullable)
  final DateTime? estimatedHarvestDate;

  @JsonKey(
      name: 'actual_harvest_date',
      fromJson: _dateFromJsonNullable,
      toJson: _dateToJsonNullable)
  final DateTime? actualHarvestDate;

  final double area;

  @JsonKey(name: 'seed_variety')
  final String? seedVariety;

  final String status;

  @JsonKey(name: 'health_score')
  final double healthScore;

  @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime createdAt;

  const CropBatchModel({
    required this.batchId,
    required this.userId,
    required this.fieldId,
    required this.cropType,
    required this.plantingDate,
    this.estimatedHarvestDate,
    this.actualHarvestDate,
    required this.area,
    this.seedVariety,
    required this.status,
    required this.healthScore,
    required this.createdAt,
  });

  factory CropBatchModel.fromJson(Map<String, dynamic> json) =>
      _$CropBatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$CropBatchModelToJson(this);

  CropBatch toEntity() {
    return CropBatch(
      batchId: batchId,
      userId: userId,
      fieldId: fieldId,
      cropType: cropType,
      plantingDate: plantingDate,
      estimatedHarvestDate: estimatedHarvestDate,
      actualHarvestDate: actualHarvestDate,
      area: area,
      seedVariety: seedVariety,
      status: status,
      healthScore: healthScore,
      createdAt: createdAt,
    );
  }

  factory CropBatchModel.fromEntity(CropBatch entity) {
    return CropBatchModel(
      batchId: entity.batchId,
      userId: entity.userId,
      fieldId: entity.fieldId,
      cropType: entity.cropType,
      plantingDate: entity.plantingDate,
      estimatedHarvestDate: entity.estimatedHarvestDate,
      actualHarvestDate: entity.actualHarvestDate,
      area: entity.area,
      seedVariety: entity.seedVariety,
      status: entity.status,
      healthScore: entity.healthScore,
      createdAt: entity.createdAt,
    );
  }

  static DateTime _dateFromJson(dynamic json) {
    if (json is String) {
      return DateTime.parse(json);
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  static DateTime? _dateFromJsonNullable(dynamic json) {
    if (json == null) return null;
    return _dateFromJson(json);
  }

  static String _dateToJson(DateTime date) => date.toIso8601String();

  static String? _dateToJsonNullable(DateTime? date) {
    return date?.toIso8601String();
  }
}
