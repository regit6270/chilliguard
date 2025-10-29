import 'package:equatable/equatable.dart';

import '../../../domain/entities/sensor_reading.dart';

abstract class SensorState extends Equatable {
  const SensorState();

  @override
  List<Object?> get props => [];
}

class SensorInitial extends SensorState {}

class SensorLoading extends SensorState {}

class SensorLoaded extends SensorState {
  final SensorReading latestReading;
  final List<SensorReading> history;

  const SensorLoaded({
    required this.latestReading,
    this.history = const [],
  });

  @override
  List<Object?> get props => [latestReading, history];

  SensorLoaded copyWith({
    SensorReading? latestReading,
    List<SensorReading>? history,
  }) {
    return SensorLoaded(
      latestReading: latestReading ?? this.latestReading,
      history: history ?? this.history,
    );
  }
}

class SensorError extends SensorState {
  final String message;

  const SensorError(this.message);

  @override
  List<Object?> get props => [message];
}

class SensorEmpty extends SensorState {}
