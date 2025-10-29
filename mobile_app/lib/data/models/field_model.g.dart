// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldModel _$FieldModelFromJson(Map<String, dynamic> json) => FieldModel(
      fieldId: json['field_id'] as String,
      userId: json['user_id'] as String,
      fieldName: json['field_name'] as String,
      area: (json['area'] as num).toDouble(),
      soilType: json['soil_type'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: FieldModel._dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$FieldModelToJson(FieldModel instance) =>
    <String, dynamic>{
      'field_id': instance.fieldId,
      'user_id': instance.userId,
      'field_name': instance.fieldName,
      'area': instance.area,
      'soil_type': instance.soilType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'created_at': FieldModel._dateTimeToJson(instance.createdAt),
    };
