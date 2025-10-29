import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/app_logger.dart';
import '../../../data/repositories/sensor_repository_impl.dart';
import 'sensor_event.dart';
import 'sensor_state.dart';

@injectable
class SensorBloc extends Bloc<SensorEvent, SensorState> {
  final SensorRepositoryImpl _sensorRepository;
  StreamSubscription? _sensorSubscription;

  SensorBloc(this._sensorRepository) : super(SensorInitial()) {
    on<LoadLatestSensorData>(_onLoadLatestSensorData);
    on<LoadSensorHistory>(_onLoadSensorHistory);
    on<RefreshSensorData>(_onRefreshSensorData);
    on<SubscribeToSensorUpdates>(_onSubscribeToSensorUpdates);
    on<UnsubscribeFromSensorUpdates>(_onUnsubscribeFromSensorUpdates);
  }

  Future<void> _onLoadLatestSensorData(
    LoadLatestSensorData event,
    Emitter<SensorState> emit,
  ) async {
    emit(SensorLoading());
    try {
      final reading = await _sensorRepository
          .getLatestReadingDirect(event.fieldId); // FIXED

      if (reading != null) {
        emit(SensorLoaded(latestReading: reading));
      } else {
        emit(const SensorError('No sensor data available'));
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load sensor data', e, stackTrace);
      emit(const SensorError('Failed to load sensor data'));
    }
  }

  Future<void> _onLoadSensorHistory(
    LoadSensorHistory event,
    Emitter<SensorState> emit,
  ) async {
    if (state is SensorLoaded) {
      final currentState = state as SensorLoaded;

      try {
        final history = await _sensorRepository.getReadings(
          event.fieldId,
          event.startDate,
          event.endDate,
        );

        emit(currentState.copyWith(history: history));
      } catch (e, stackTrace) {
        AppLogger.error('Failed to load sensor history', e, stackTrace);
      }
    }
  }

  Future<void> _onRefreshSensorData(
    RefreshSensorData event,
    Emitter<SensorState> emit,
  ) async {
    try {
      final reading = await _sensorRepository
          .getLatestReadingDirect(event.fieldId); // FIXED

      if (reading != null) {
        if (state is SensorLoaded) {
          final currentState = state as SensorLoaded;
          emit(currentState.copyWith(latestReading: reading));
        } else {
          emit(SensorLoaded(latestReading: reading));
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to refresh sensor data', e, stackTrace);
    }
  }

  Future<void> _onSubscribeToSensorUpdates(
    SubscribeToSensorUpdates event,
    Emitter<SensorState> emit,
  ) async {
    await _sensorSubscription?.cancel();

    _sensorSubscription =
        _sensorRepository.getSensorStream(event.fieldId).listen((reading) {
      if (state is SensorLoaded) {
        final currentState = state as SensorLoaded;
        emit(currentState.copyWith(latestReading: reading));
      } else {
        emit(SensorLoaded(latestReading: reading));
      }
    });
  }

  Future<void> _onUnsubscribeFromSensorUpdates(
    UnsubscribeFromSensorUpdates event,
    Emitter<SensorState> emit,
  ) async {
    await _sensorSubscription?.cancel();
    _sensorSubscription = null;
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    return super.close();
  }
}
