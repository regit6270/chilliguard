import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/field.dart';

part 'field_model.g.dart';

@JsonSerializable()
class FieldModel {
  @JsonKey(name: 'field_id')
  final String fieldId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'field_name')
  final String fieldName;

  final double area;

  @JsonKey(name: 'soil_type')
  final String? soilType;

  final double? latitude;
  final double? longitude;

  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  const FieldModel({
    required this.fieldId,
    required this.userId,
    required this.fieldName,
    required this.area,
    this.soilType,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) =>
      _$FieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$FieldModelToJson(this);

  Field toEntity() {
    return Field(
      fieldId: fieldId,
      userId: userId,
      fieldName: fieldName,
      area: area,
      soilType: soilType,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
    );
  }

  factory FieldModel.fromEntity(Field entity) {
    return FieldModel(
      fieldId: entity.fieldId,
      userId: entity.userId,
      fieldName: entity.fieldName,
      area: entity.area,
      soilType: entity.soilType,
      latitude: entity.latitude,
      longitude: entity.longitude,
      createdAt: entity.createdAt,
    );
  }

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json is String) {
      return DateTime.parse(json);
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();
}
