import 'package:equatable/equatable.dart';

import '../../../domain/entities/fertilizer_schedule.dart';
import '../../../domain/entities/soil_recommendation.dart';

abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RecommendationInitial extends RecommendationState {}

/// Loading state for soil improvements
class SoilImprovementsLoading extends RecommendationState {}

/// Loaded state for soil improvements
class SoilImprovementsLoaded extends RecommendationState {
  final List<SoilRecommendation> recommendations;
  final String fieldId;
  final DateTime loadedAt;

  const SoilImprovementsLoaded({
    required this.recommendations,
    required this.fieldId,
    required this.loadedAt,
  });

  @override
  List<Object?> get props => [recommendations, fieldId, loadedAt];

  /// Get recommendations by priority
  List<SoilRecommendation> get highPriority =>
      recommendations.where((r) => r.isHighPriority).toList();

  List<SoilRecommendation> get mediumPriority =>
      recommendations.where((r) => r.isMediumPriority).toList();

  List<SoilRecommendation> get lowPriority =>
      recommendations.where((r) => r.isLowPriority).toList();

  /// Get critical recommendations
  List<SoilRecommendation> get criticalRecommendations =>
      recommendations.where((r) => r.isCritical).toList();

  /// Check if there are any recommendations
  bool get hasRecommendations => recommendations.isNotEmpty;

  /// Get count of recommendations
  int get count => recommendations.length;
}

/// Loading state for fertilizer schedule
class FertilizerScheduleLoading extends RecommendationState {}

/// Loaded state for fertilizer schedule
class FertilizerScheduleLoaded extends RecommendationState {
  final FertilizerSchedule schedule;
  final DateTime loadedAt;

  const FertilizerScheduleLoaded({
    required this.schedule,
    required this.loadedAt,
  });

  @override
  List<Object?> get props => [schedule, loadedAt];

  /// Get upcoming stages
  List<FertilizerStage> get upcomingStages =>
      schedule.getUpcomingStages(DateTime.now());

  /// Check if schedule is loaded
  bool get hasSchedule => schedule.schedule.isNotEmpty;

  /// Get total stages count
  int get totalStages => schedule.totalStages;
}

/// Loading state for soil parameters info
class SoilParametersInfoLoading extends RecommendationState {}

/// Loaded state for soil parameters info
class SoilParametersInfoLoaded extends RecommendationState {
  final Map<String, dynamic> parametersInfo;

  const SoilParametersInfoLoaded({
    required this.parametersInfo,
  });

  @override
  List<Object?> get props => [parametersInfo];
}

/// Error state
class RecommendationError extends RecommendationState {
  final String message;
  final String? errorCode;

  const RecommendationError(
    this.message, {
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];

  bool get isNetworkError =>
      message.toLowerCase().contains('network') ||
      message.toLowerCase().contains('internet') ||
      message.toLowerCase().contains('connection');

  bool get isServerError =>
      message.toLowerCase().contains('server') ||
      message.toLowerCase().contains('backend');
}

/// Empty state when no recommendations are available
class RecommendationEmpty extends RecommendationState {
  final String message;

  const RecommendationEmpty(this.message);

  @override
  List<Object?> get props => [message];
}
