import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/app_logger.dart';
import '../../../data/repositories/sensor_repository.dart';
import 'sensor_event.dart';
import 'sensor_state.dart';

@injectable
class SensorBloc extends Bloc<SensorEvent, SensorState> {
  // ⭐ CHANGE #1: Add proper type annotations to class
  final SensorRepository _sensorRepository;
  StreamSubscription<dynamic>? _sensorSubscription;

  SensorBloc(this._sensorRepository) : super(SensorInitial()) {
    on<LoadLatestSensorData>(_onLoadLatestSensorData);
    on<LoadSensorHistory>(_onLoadSensorHistory);
    on<RefreshSensorData>(_onRefreshSensorData);
    on<SubscribeToSensorUpdates>(_onSubscribeToSensorUpdates);
    on<UnsubscribeFromSensorUpdates>(_onUnsubscribeFromSensorUpdates);
  }

  /// Load latest sensor data for a field
  Future<void> _onLoadLatestSensorData(
    LoadLatestSensorData event,
    Emitter<SensorState> emit,
  ) async {
    emit(SensorLoading());
    try {
      AppLogger.info('Loading latest sensor data for field: ${event.fieldId}');

      final reading = await _sensorRepository
          .getLatestReadingDirect(event.fieldId); // FIXED

      if (reading != null) {
        AppLogger.info(
          '✅ Sensor data loaded: pH=${reading.ph}, temp=${reading.temperature}',
        );
        emit(SensorLoaded(latestReading: reading));
      } else {
        AppLogger.warning(
            'No sensor data available for field: ${event.fieldId}');
        emit(const SensorError('No sensor data available'));
      }
    } on Exception catch (e, stackTrace) {
      AppLogger.error('Failed to load sensor data', e, stackTrace);
      emit(const SensorError('Failed to load sensor data'));
    }
  }

  /// Load sensor history for a date range
  Future<void> _onLoadSensorHistory(
    // ⭐ CHANGE #5: Add proper type annotations
    LoadSensorHistory event,
    Emitter<SensorState> emit,
  ) async {
    try {
      AppLogger.info(
        'Loading sensor history for field: ${event.fieldId}, '
        'from ${event.startDate} to ${event.endDate}',
      );

      // ⭐ CHANGE #6: Fetch history from repository
      final history = await _sensorRepository.getReadings(
        event.fieldId,
        event.startDate,
        event.endDate,
      );

      if (state is SensorLoaded) {
        final currentState = state as SensorLoaded;
        AppLogger.info('✅ ${history.length} historical readings loaded');
        emit(currentState.copyWith(history: history));
      } else {
        AppLogger.warning(
            'Cannot update history - SensorLoaded state not present');
      }
    } on Exception catch (e, stackTrace) {
      // ⭐ CHANGE #7: Proper exception handling
      AppLogger.error(
        'Failed to load sensor history',
        e.toString(),
        stackTrace,
      );

      if (state is SensorLoaded) {
        final currentState = state as SensorLoaded;
        emit(currentState.copyWith(history: const []));
      }
    }
  }

  /// Refresh latest sensor data
  Future<void> _onRefreshSensorData(
    // ⭐ CHANGE #8: Add proper type annotations
    RefreshSensorData event,
    Emitter<SensorState> emit,
  ) async {
    try {
      AppLogger.info('Refreshing sensor data for field: ${event.fieldId}');

      final reading = await _sensorRepository.getLatestReadingDirect(
        event.fieldId,
      );

      if (reading != null) {
        if (state is SensorLoaded) {
          final currentState = state as SensorLoaded;
          AppLogger.info('✅ Sensor data refreshed');
          emit(currentState.copyWith(latestReading: reading));
        } else {
          emit(SensorLoaded(latestReading: reading));
        }
      } else {
        AppLogger.warning('No new data available for refresh');
      }
    } on Exception catch (e, stackTrace) {
      // ⭐ CHANGE #9: Proper exception handling
      AppLogger.error(
        'Failed to refresh sensor data',
        e.toString(),
        stackTrace,
      );
    }
  }

  /// Subscribe to real-time sensor updates
  Future<void> _onSubscribeToSensorUpdates(
    // ⭐ CHANGE #10: Add proper type annotations
    SubscribeToSensorUpdates event,
    Emitter<SensorState> emit,
  ) async {
    try {
      AppLogger.info(
          'Subscribing to sensor updates for field: ${event.fieldId}');

      // Cancel previous subscription
      await _sensorSubscription?.cancel();

      // ⭐ CHANGE #11: Listen to sensor stream with proper error handling
      _sensorSubscription =
          _sensorRepository.getSensorStream(event.fieldId).listen(
        (reading) {
          AppLogger.info('📡 Real-time update: pH=${reading.ph}');

          if (state is SensorLoaded) {
            final currentState = state as SensorLoaded;
            emit(currentState.copyWith(latestReading: reading));
          } else {
            emit(SensorLoaded(latestReading: reading));
          }
        },
        onError: (error, stackTrace) {
          // ⭐ CHANGE #12: Handle stream errors
          AppLogger.error(
            'Sensor stream error',
            error.toString(),
            stackTrace,
          );
          emit(const SensorError('Real-time update failed'));
        },
      );
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to subscribe to sensor updates',
        e.toString(),
        stackTrace,
      );
      emit(const SensorError('Failed to subscribe to updates'));
    }
  }

  /// Unsubscribe from real-time updates
  Future<void> _onUnsubscribeFromSensorUpdates(
    // ⭐ CHANGE #13: Add proper type annotations
    UnsubscribeFromSensorUpdates event,
    Emitter<SensorState> emit,
  ) async {
    try {
      AppLogger.info('Unsubscribing from sensor updates');
      await _sensorSubscription?.cancel();
      _sensorSubscription = null;
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to unsubscribe',
        e.toString(),
        stackTrace,
      );
    }
  }

  /// Clean up resources when BLoC is closed
  @override
  Future<void> close() {
    // ⭐ CHANGE #14: Properly clean up subscription
    AppLogger.info('Closing SensorBloc - cleaning up subscriptions');
    _sensorSubscription?.cancel();
    return super.close();
  }
}
//   Future<void> _onLoadSensorHistory(
//     LoadSensorHistory event,
//     Emitter<SensorState> emit,
//   ) async {
//     if (state is SensorLoaded) {
//       final currentState = state as SensorLoaded;

//       try {
//         final history = await _sensorRepository.getReadings(
//           event.fieldId,
//           event.startDate,
//           event.endDate,
//         );

//         emit(currentState.copyWith(history: history));
//       } catch (e, stackTrace) {
//         AppLogger.error('Failed to load sensor history', e, stackTrace);
//       }
//     }
//   }

//   Future<void> _onRefreshSensorData(
//     RefreshSensorData event,
//     Emitter<SensorState> emit,
//   ) async {
//     try {
//       final reading = await _sensorRepository
//           .getLatestReadingDirect(event.fieldId); // FIXED

//       if (reading != null) {
//         if (state is SensorLoaded) {
//           final currentState = state as SensorLoaded;
//           emit(currentState.copyWith(latestReading: reading));
//         } else {
//           emit(SensorLoaded(latestReading: reading));
//         }
//       }
//     } catch (e, stackTrace) {
//       AppLogger.error('Failed to refresh sensor data', e, stackTrace);
//     }
//   }

//   Future<void> _onSubscribeToSensorUpdates(
//     SubscribeToSensorUpdates event,
//     Emitter<SensorState> emit,
//   ) async {
//     await _sensorSubscription?.cancel();

//     _sensorSubscription =
//         _sensorRepository.getSensorStream(event.fieldId).listen((reading) {
//       if (state is SensorLoaded) {
//         final currentState = state as SensorLoaded;
//         emit(currentState.copyWith(latestReading: reading));
//       } else {
//         emit(SensorLoaded(latestReading: reading));
//       }
//     });
//   }

//   Future<void> _onUnsubscribeFromSensorUpdates(
//     UnsubscribeFromSensorUpdates event,
//     Emitter<SensorState> emit,
//   ) async {
//     await _sensorSubscription?.cancel();
//     _sensorSubscription = null;
//   }

//   @override
//   Future<void> close() {
//     _sensorSubscription?.cancel();
//     return super.close();
//   }
// }
