part of 'alert_bloc.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlerts extends AlertEvent {
  final bool unacknowledgedOnly;

  const LoadAlerts({this.unacknowledgedOnly = false});

  @override
  List<Object> get props => [unacknowledgedOnly];
}

class AcknowledgeAlert extends AlertEvent {
  final String alertId;

  const AcknowledgeAlert(this.alertId);

  @override
  List<Object> get props => [alertId];
}

class RefreshAlerts extends AlertEvent {}

class FilterAlertsBySeverity extends AlertEvent {
  final String? severity; // null = all, 'critical', 'high', 'normal'

  const FilterAlertsBySeverity(this.severity);

  @override
  List<Object?> get props => [severity];
}

class LoadAlertStatistics extends AlertEvent {}
