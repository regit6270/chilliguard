import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/treatment.dart';

part 'treatment_model.g.dart';

@JsonSerializable()
class TreatmentModel {
  @JsonKey(name: 'treatment_id')
  final String treatmentId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'batch_id')
  final String batchId;

  @JsonKey(name: 'detection_id')
  final String? detectionId;

  @JsonKey(name: 'treatment_name')
  final String treatmentName;

  @JsonKey(name: 'treatment_type')
  final String treatmentType;

  final String? dosage;

  @JsonKey(name: 'application_method')
  final String? applicationMethod;

  @JsonKey(
      name: 'application_date',
      fromJson: _dateFromJsonNullable,
      toJson: _dateToJsonNullable)
  final DateTime? applicationDate;

  @JsonKey(
      name: 'next_application_date',
      fromJson: _dateFromJsonNullable,
      toJson: _dateToJsonNullable)
  final DateTime? nextApplicationDate;

  final String? notes;

  @JsonKey(name: 'effectiveness_rating')
  final double? effectivenessRating;

  final double? cost;

  @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime createdAt;

  const TreatmentModel({
    required this.treatmentId,
    required this.userId,
    required this.batchId,
    this.detectionId,
    required this.treatmentName,
    required this.treatmentType,
    this.dosage,
    this.applicationMethod,
    this.applicationDate,
    this.nextApplicationDate,
    this.notes,
    this.effectivenessRating,
    this.cost,
    required this.createdAt,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) =>
      _$TreatmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreatmentModelToJson(this);

  Treatment toEntity() {
    return Treatment(
      treatmentId: treatmentId,
      userId: userId,
      batchId: batchId,
      detectionId: detectionId,
      treatmentName: treatmentName,
      treatmentType: treatmentType,
      dosage: dosage,
      applicationMethod: applicationMethod,
      applicationDate: applicationDate,
      nextApplicationDate: nextApplicationDate,
      notes: notes,
      effectivenessRating: effectivenessRating,
      cost: cost,
      createdAt: createdAt,
    );
  }

  factory TreatmentModel.fromEntity(Treatment entity) {
    return TreatmentModel(
      treatmentId: entity.treatmentId,
      userId: entity.userId,
      batchId: entity.batchId,
      detectionId: entity.detectionId,
      treatmentName: entity.treatmentName,
      treatmentType: entity.treatmentType,
      dosage: entity.dosage,
      applicationMethod: entity.applicationMethod,
      applicationDate: entity.applicationDate,
      nextApplicationDate: entity.nextApplicationDate,
      notes: entity.notes,
      effectivenessRating: entity.effectivenessRating,
      cost: entity.cost,
      createdAt: entity.createdAt,
    );
  }

  static DateTime _dateFromJson(dynamic json) {
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return DateTime.now();
  }

  static DateTime? _dateFromJsonNullable(dynamic json) {
    if (json == null) return null;
    return _dateFromJson(json);
  }

  static String _dateToJson(DateTime date) => date.toIso8601String();
  static String? _dateToJsonNullable(DateTime? date) => date?.toIso8601String();
}
