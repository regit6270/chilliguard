// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreatmentModel _$TreatmentModelFromJson(Map<String, dynamic> json) =>
    TreatmentModel(
      treatmentId: json['treatment_id'] as String,
      userId: json['user_id'] as String,
      batchId: json['batch_id'] as String,
      detectionId: json['detection_id'] as String?,
      treatmentName: json['treatment_name'] as String,
      treatmentType: json['treatment_type'] as String,
      dosage: json['dosage'] as String?,
      applicationMethod: json['application_method'] as String?,
      applicationDate:
          TreatmentModel._dateFromJsonNullable(json['application_date']),
      nextApplicationDate:
          TreatmentModel._dateFromJsonNullable(json['next_application_date']),
      notes: json['notes'] as String?,
      effectivenessRating: (json['effectiveness_rating'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      createdAt: TreatmentModel._dateFromJson(json['created_at']),
    );

Map<String, dynamic> _$TreatmentModelToJson(TreatmentModel instance) =>
    <String, dynamic>{
      'treatment_id': instance.treatmentId,
      'user_id': instance.userId,
      'batch_id': instance.batchId,
      'detection_id': instance.detectionId,
      'treatment_name': instance.treatmentName,
      'treatment_type': instance.treatmentType,
      'dosage': instance.dosage,
      'application_method': instance.applicationMethod,
      'application_date':
          TreatmentModel._dateToJsonNullable(instance.applicationDate),
      'next_application_date':
          TreatmentModel._dateToJsonNullable(instance.nextApplicationDate),
      'notes': instance.notes,
      'effectiveness_rating': instance.effectivenessRating,
      'cost': instance.cost,
      'created_at': TreatmentModel._dateToJson(instance.createdAt),
    };
