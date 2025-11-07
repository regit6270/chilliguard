import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/app_logger.dart';
import '../../../data/repositories/recommendation_repository.dart';
import 'recommendation_event.dart';
import 'recommendation_state.dart';

@injectable
class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final RecommendationRepository _recommendationRepository;

  RecommendationBloc(this._recommendationRepository)
      : super(RecommendationInitial()) {
    on<LoadSoilImprovements>(_onLoadSoilImprovements);
    on<LoadFertilizerSchedule>(_onLoadFertilizerSchedule);
    on<RefreshSoilImprovements>(_onRefreshSoilImprovements);
    on<RefreshFertilizerSchedule>(_onRefreshFertilizerSchedule);
    on<LoadSoilParametersInfo>(_onLoadSoilParametersInfo);
    on<ClearRecommendations>(_onClearRecommendations);
  }

  /// Load soil improvement recommendations based on sensor data
  Future<void> _onLoadSoilImprovements(
    LoadSoilImprovements event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(SoilImprovementsLoading());

    try {
      AppLogger.info(
          'Loading soil improvements for field: ${event.fieldId} with sensor data: ${event.sensorData}');

      final result = await _recommendationRepository.getSoilImprovements(
        fieldId: event.fieldId,
        sensorData: event.sensorData,
        language: event.language,
      );

      result.fold(
        (failure) {
          AppLogger.error('Failed to load soil improvements', failure.message);
          emit(RecommendationError(failure.message));
        },
        (recommendations) {
          if (recommendations.isEmpty) {
            AppLogger.info(
                'No soil improvements needed - all parameters optimal');
            emit(const RecommendationEmpty(
                'All soil parameters are optimal! No improvements needed.'));
          } else {
            AppLogger.info(
                '✅ Loaded ${recommendations.length} soil improvement recommendations');
            emit(SoilImprovementsLoaded(
              recommendations: recommendations,
              fieldId: event.fieldId,
              loadedAt: DateTime.now(),
            ));
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'Unexpected error loading soil improvements', e, stackTrace);
      emit(
          RecommendationError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Load fertilizer application schedule
  Future<void> _onLoadFertilizerSchedule(
    LoadFertilizerSchedule event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(FertilizerScheduleLoading());

    try {
      AppLogger.info(
          'Loading fertilizer schedule for planting date: ${event.plantingDate}, area: ${event.fieldArea} ha');

      final result = await _recommendationRepository.getFertilizerSchedule(
        plantingDate: event.plantingDate,
        fieldArea: event.fieldArea,
        cropType: event.cropType,
        varietyType: event.varietyType,
      );

      result.fold(
        (failure) {
          AppLogger.error(
              'Failed to load fertilizer schedule', failure.message);
          emit(RecommendationError(failure.message));
        },
        (schedule) {
          AppLogger.info(
              '✅ Loaded fertilizer schedule with ${schedule.totalStages} stages');
          emit(FertilizerScheduleLoaded(
            schedule: schedule,
            loadedAt: DateTime.now(),
          ));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'Unexpected error loading fertilizer schedule', e, stackTrace);
      emit(
          RecommendationError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Refresh soil improvement recommendations
  Future<void> _onRefreshSoilImprovements(
    RefreshSoilImprovements event,
    Emitter<RecommendationState> emit,
  ) async {
    try {
      AppLogger.info(
          'Refreshing soil improvements for field: ${event.fieldId}');

      final result = await _recommendationRepository.getSoilImprovements(
        fieldId: event.fieldId,
        sensorData: event.sensorData,
        language: event.language,
      );

      result.fold(
        (failure) {
          AppLogger.error(
              'Failed to refresh soil improvements', failure.message);
          emit(RecommendationError(failure.message));
        },
        (recommendations) {
          if (recommendations.isEmpty) {
            emit(const RecommendationEmpty(
                'All soil parameters are optimal! No improvements needed.'));
          } else {
            AppLogger.info('✅ Refreshed soil improvement recommendations');
            emit(SoilImprovementsLoaded(
              recommendations: recommendations,
              fieldId: event.fieldId,
              loadedAt: DateTime.now(),
            ));
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'Unexpected error refreshing soil improvements', e, stackTrace);
      emit(
          RecommendationError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Refresh fertilizer schedule
  Future<void> _onRefreshFertilizerSchedule(
    RefreshFertilizerSchedule event,
    Emitter<RecommendationState> emit,
  ) async {
    try {
      AppLogger.info('Refreshing fertilizer schedule');

      final result = await _recommendationRepository.getFertilizerSchedule(
        plantingDate: event.plantingDate,
        fieldArea: event.fieldArea,
        cropType: event.cropType,
        varietyType: event.varietyType,
      );

      result.fold(
        (failure) {
          AppLogger.error(
              'Failed to refresh fertilizer schedule', failure.message);
          emit(RecommendationError(failure.message));
        },
        (schedule) {
          AppLogger.info('✅ Refreshed fertilizer schedule');
          emit(FertilizerScheduleLoaded(
            schedule: schedule,
            loadedAt: DateTime.now(),
          ));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'Unexpected error refreshing fertilizer schedule', e, stackTrace);
      emit(
          RecommendationError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Load soil parameter information and thresholds
  Future<void> _onLoadSoilParametersInfo(
    LoadSoilParametersInfo event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(SoilParametersInfoLoading());

    try {
      AppLogger.info('Loading soil parameters info');

      final result = await _recommendationRepository.getSoilParametersInfo();

      result.fold(
        (failure) {
          AppLogger.error(
              'Failed to load soil parameters info', failure.message);
          emit(RecommendationError(failure.message));
        },
        (parametersInfo) {
          AppLogger.info('✅ Loaded soil parameters info');
          emit(SoilParametersInfoLoaded(parametersInfo: parametersInfo));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
          'Unexpected error loading soil parameters info', e, stackTrace);
      emit(
          RecommendationError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Clear all recommendation data
  Future<void> _onClearRecommendations(
    ClearRecommendations event,
    Emitter<RecommendationState> emit,
  ) async {
    AppLogger.info('Clearing recommendations');
    emit(RecommendationInitial());
  }
}
