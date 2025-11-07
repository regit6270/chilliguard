import 'package:equatable/equatable.dart';

abstract class RecommendationEvent extends Equatable {
  const RecommendationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load soil improvement recommendations based on sensor data
class LoadSoilImprovements extends RecommendationEvent {
  final String fieldId;
  final Map<String, dynamic> sensorData;
  final String language;

  const LoadSoilImprovements({
    required this.fieldId,
    required this.sensorData,
    this.language = 'en',
  });

  @override
  List<Object?> get props => [fieldId, sensorData, language];
}

/// Event to load fertilizer application schedule
class LoadFertilizerSchedule extends RecommendationEvent {
  final String plantingDate;
  final double fieldArea;
  final String cropType;
  final String varietyType;

  const LoadFertilizerSchedule({
    required this.plantingDate,
    required this.fieldArea,
    this.cropType = 'chilli',
    this.varietyType = 'hybrid',
  });

  @override
  List<Object?> get props => [plantingDate, fieldArea, cropType, varietyType];
}

/// Event to refresh soil improvement recommendations
class RefreshSoilImprovements extends RecommendationEvent {
  final String fieldId;
  final Map<String, dynamic> sensorData;
  final String language;

  const RefreshSoilImprovements({
    required this.fieldId,
    required this.sensorData,
    this.language = 'en',
  });

  @override
  List<Object?> get props => [fieldId, sensorData, language];
}

/// Event to refresh fertilizer schedule
class RefreshFertilizerSchedule extends RecommendationEvent {
  final String plantingDate;
  final double fieldArea;
  final String cropType;
  final String varietyType;

  const RefreshFertilizerSchedule({
    required this.plantingDate,
    required this.fieldArea,
    this.cropType = 'chilli',
    this.varietyType = 'hybrid',
  });

  @override
  List<Object?> get props => [plantingDate, fieldArea, cropType, varietyType];
}

/// Event to load soil parameter information
class LoadSoilParametersInfo extends RecommendationEvent {}

/// Event to clear recommendation data
class ClearRecommendations extends RecommendationEvent {}
