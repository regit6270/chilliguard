import 'package:equatable/equatable.dart';

abstract class SensorEvent extends Equatable {
  const SensorEvent();

  @override
  List<Object?> get props => [];
}

class LoadLatestSensorData extends SensorEvent {
  final String fieldId;

  const LoadLatestSensorData(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}

class LoadSensorHistory extends SensorEvent {
  final String fieldId;
  final DateTime startDate;
  final DateTime endDate;

  const LoadSensorHistory({
    required this.fieldId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [fieldId, startDate, endDate];
}

class RefreshSensorData extends SensorEvent {
  final String fieldId;

  const RefreshSensorData(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}

class SubscribeToSensorUpdates extends SensorEvent {
  final String fieldId;

  const SubscribeToSensorUpdates(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}

class UnsubscribeFromSensorUpdates extends SensorEvent {}
