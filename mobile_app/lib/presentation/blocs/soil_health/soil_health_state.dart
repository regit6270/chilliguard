part of 'soil_health_bloc.dart';

abstract class SoilHealthState extends Equatable {
  const SoilHealthState();

  @override
  List<Object?> get props => [];
}

class SoilHealthInitial extends SoilHealthState {}

class SoilHealthLoading extends SoilHealthState {}

class SoilHealthLoaded extends SoilHealthState {
  final List<SensorReading> readings;
  final String selectedParameter;
  final String selectedDuration;
  final SensorReading? latestReading;
  final Map<String, double> averages;
  final Map<String, List<double>> trends;
  final DateTime lastUpdated;

  const SoilHealthLoaded({
    required this.readings,
    required this.selectedParameter,
    required this.selectedDuration,
    this.latestReading,
    required this.averages,
    required this.trends,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        readings,
        selectedParameter,
        selectedDuration,
        latestReading,
        averages,
        trends,
        lastUpdated,
      ];

  SoilHealthLoaded copyWith({
    List<SensorReading>? readings,
    String? selectedParameter,
    String? selectedDuration,
    SensorReading? latestReading,
    Map<String, double>? averages,
    Map<String, List<double>>? trends,
    DateTime? lastUpdated,
  }) {
    return SoilHealthLoaded(
      readings: readings ?? this.readings,
      selectedParameter: selectedParameter ?? this.selectedParameter,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      latestReading: latestReading ?? this.latestReading,
      averages: averages ?? this.averages,
      trends: trends ?? this.trends,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class SoilHealthError extends SoilHealthState {
  final String message;

  const SoilHealthError(this.message);

  @override
  List<Object> get props => [message];
}
