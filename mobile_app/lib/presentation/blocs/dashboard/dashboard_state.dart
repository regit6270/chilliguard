part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final SensorReading? latestSensorData;
  final CropBatch? activeBatch;
  final double feasibilityScore;
  final String feasibilityStatus; // ready, minor_adjustments, needs_improvement
  final List<Alert> recentAlerts;
  final DateTime lastUpdated;

  const DashboardLoaded({
    this.latestSensorData,
    this.activeBatch,
    required this.feasibilityScore,
    required this.feasibilityStatus,
    required this.recentAlerts,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        latestSensorData,
        activeBatch,
        feasibilityScore,
        feasibilityStatus,
        recentAlerts,
        lastUpdated,
      ];

  DashboardLoaded copyWith({
    SensorReading? latestSensorData,
    CropBatch? activeBatch,
    double? feasibilityScore,
    String? feasibilityStatus,
    List<Alert>? recentAlerts,
    DateTime? lastUpdated,
  }) {
    return DashboardLoaded(
      latestSensorData: latestSensorData ?? this.latestSensorData,
      activeBatch: activeBatch ?? this.activeBatch,
      feasibilityScore: feasibilityScore ?? this.feasibilityScore,
      feasibilityStatus: feasibilityStatus ?? this.feasibilityStatus,
      recentAlerts: recentAlerts ?? this.recentAlerts,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
