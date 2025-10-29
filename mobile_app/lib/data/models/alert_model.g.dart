// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertModel _$AlertModelFromJson(Map<String, dynamic> json) => AlertModel(
      alertId: json['alert_id'] as String,
      fieldId: json['field_id'] as String,
      alertType: json['alert_type'] as String,
      parameter: json['parameter'] as String,
      message: json['message'] as String,
      severity: json['severity'] as String,
      timestamp: AlertModel._dateTimeFromJson(json['timestamp']),
      acknowledged: json['acknowledged'] as bool,
      acknowledgedAt:
          AlertModel._dateTimeFromJsonNullable(json['acknowledged_at']),
    );

Map<String, dynamic> _$AlertModelToJson(AlertModel instance) =>
    <String, dynamic>{
      'alert_id': instance.alertId,
      'field_id': instance.fieldId,
      'alert_type': instance.alertType,
      'parameter': instance.parameter,
      'message': instance.message,
      'severity': instance.severity,
      'timestamp': AlertModel._dateTimeToJson(instance.timestamp),
      'acknowledged': instance.acknowledged,
      'acknowledged_at':
          AlertModel._dateTimeToJsonNullable(instance.acknowledgedAt),
    };
