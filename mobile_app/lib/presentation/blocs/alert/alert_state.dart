part of 'alert_bloc.dart';

abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertsLoaded extends AlertState {
  final List<Alert> alerts;
  final List<Alert> filteredAlerts;
  final String? selectedSeverity;
  final int unacknowledgedCount;
  final int criticalCount;
  final DateTime lastUpdated;

  const AlertsLoaded({
    required this.alerts,
    required this.filteredAlerts,
    this.selectedSeverity,
    required this.unacknowledgedCount,
    required this.criticalCount,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        alerts,
        filteredAlerts,
        selectedSeverity,
        unacknowledgedCount,
        criticalCount,
        lastUpdated,
      ];

  AlertsLoaded copyWith({
    List<Alert>? alerts,
    List<Alert>? filteredAlerts,
    String? selectedSeverity,
    int? unacknowledgedCount,
    int? criticalCount,
    DateTime? lastUpdated,
  }) {
    return AlertsLoaded(
      alerts: alerts ?? this.alerts,
      filteredAlerts: filteredAlerts ?? this.filteredAlerts,
      selectedSeverity: selectedSeverity ?? this.selectedSeverity,
      unacknowledgedCount: unacknowledgedCount ?? this.unacknowledgedCount,
      criticalCount: criticalCount ?? this.criticalCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class AlertStatisticsLoaded extends AlertState {
  final Map<String, dynamic> statistics;

  const AlertStatisticsLoaded(this.statistics);

  @override
  List<Object> get props => [statistics];
}

class AlertAcknowledging extends AlertState {
  final String alertId;

  const AlertAcknowledging(this.alertId);

  @override
  List<Object> get props => [alertId];
}

class AlertAcknowledged extends AlertState {
  final String alertId;

  const AlertAcknowledged(this.alertId);

  @override
  List<Object> get props => [alertId];
}

class AlertError extends AlertState {
  final String message;

  const AlertError(this.message);

  @override
  List<Object> get props => [message];
}
