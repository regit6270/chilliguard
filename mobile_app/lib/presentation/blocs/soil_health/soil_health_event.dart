part of 'soil_health_bloc.dart';

abstract class SoilHealthEvent extends Equatable {
  const SoilHealthEvent();

  @override
  List<Object?> get props => [];
}

class LoadSoilHealthData extends SoilHealthEvent {
  final String fieldId;
  final String duration; // 7d, 30d, 3m, 6m, 1y

  const LoadSoilHealthData({
    required this.fieldId,
    this.duration = '7d',
  });

  @override
  List<Object> get props => [fieldId, duration];
}

class ChangeDuration extends SoilHealthEvent {
  final String duration;

  const ChangeDuration(this.duration);

  @override
  List<Object> get props => [duration];
}

class RefreshSoilHealth extends SoilHealthEvent {
  final String fieldId;

  const RefreshSoilHealth(this.fieldId);

  @override
  List<Object> get props => [fieldId];
}

class ChangeParameter extends SoilHealthEvent {
  final String
      parameter; // ph, nitrogen, phosphorus, potassium, moisture, temperature

  const ChangeParameter(this.parameter);

  @override
  List<Object> get props => [parameter];
}
