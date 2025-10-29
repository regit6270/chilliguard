import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/alert.dart';

part 'alert_model.g.dart';

@JsonSerializable()
class AlertModel {
  @JsonKey(name: 'alert_id')
  final String alertId;

  @JsonKey(name: 'field_id')
  final String fieldId;

  @JsonKey(name: 'alert_type')
  final String alertType;

  final String parameter;
  final String message;
  final String severity;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime timestamp;

  final bool acknowledged;

  @JsonKey(
      name: 'acknowledged_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  final DateTime? acknowledgedAt;

  const AlertModel({
    required this.alertId,
    required this.fieldId,
    required this.alertType,
    required this.parameter,
    required this.message,
    required this.severity,
    required this.timestamp,
    required this.acknowledged,
    this.acknowledgedAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlertModelToJson(this);

  Alert toEntity() {
    return Alert(
      alertId: alertId,
      fieldId: fieldId,
      alertType: alertType,
      parameter: parameter,
      message: message,
      severity: severity,
      timestamp: timestamp,
      acknowledged: acknowledged,
      acknowledgedAt: acknowledgedAt,
    );
  }

  factory AlertModel.fromEntity(Alert entity) {
    return AlertModel(
      alertId: entity.alertId,
      fieldId: entity.fieldId,
      alertType: entity.alertType,
      parameter: entity.parameter,
      message: entity.message,
      severity: entity.severity,
      timestamp: entity.timestamp,
      acknowledged: entity.acknowledged,
      acknowledgedAt: entity.acknowledgedAt,
    );
  }

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return DateTime.now();
  }

  static DateTime? _dateTimeFromJsonNullable(dynamic json) {
    if (json == null) return null;
    return _dateTimeFromJson(json);
  }

  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();
  static String? _dateTimeToJsonNullable(DateTime? dateTime) =>
      dateTime?.toIso8601String();
}
