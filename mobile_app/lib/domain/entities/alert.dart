import 'package:equatable/equatable.dart';

class Alert extends Equatable {
  final String alertId;
  final String fieldId;
  final String alertType; // sensor, disease, weather, etc.
  final String parameter;
  final String message;
  final String severity; // normal, high, critical
  final DateTime timestamp;
  final bool acknowledged;
  final DateTime? acknowledgedAt;

  const Alert({
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

  bool get isCritical => severity == 'critical';
  bool get isUnread => !acknowledged;

  @override
  List<Object?> get props => [
        alertId,
        fieldId,
        alertType,
        parameter,
        message,
        severity,
        timestamp,
        acknowledged,
        acknowledgedAt,
      ];

  Alert copyWith({
    bool? acknowledged,
    DateTime? acknowledgedAt,
  }) {
    return Alert(
      alertId: alertId,
      fieldId: fieldId,
      alertType: alertType,
      parameter: parameter,
      message: message,
      severity: severity,
      timestamp: timestamp,
      acknowledged: acknowledged ?? this.acknowledged,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
    );
  }
}
