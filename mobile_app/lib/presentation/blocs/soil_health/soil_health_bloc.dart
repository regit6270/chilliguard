import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/sensor_repository.dart';
import '../../../domain/entities/sensor_reading.dart';

part 'soil_health_event.dart';
part 'soil_health_state.dart';

@injectable
class SoilHealthBloc extends Bloc<SoilHealthEvent, SoilHealthState> {
  final SensorRepository sensorRepository;

  SoilHealthBloc({
    required this.sensorRepository,
  }) : super(SoilHealthInitial()) {
    on<LoadSoilHealthData>(_onLoadSoilHealthData);
    on<ChangeDuration>(_onChangeDuration);
    on<RefreshSoilHealth>(_onRefreshSoilHealth);
    on<ChangeParameter>(_onChangeParameter);
  }

  String _currentFieldId = '';
  String _currentDuration = '7d';
  String _currentParameter = 'ph';

  // Future<void> _onLoadSoilHealthData(
  //   LoadSoilHealthData event,
  //   Emitter<SoilHealthState> emit,
  // ) async {
  //   emit(SoilHealthLoading());

  //   _currentFieldId = event.fieldId;
  //   _currentDuration = event.duration;

  //   try {
  //     // Fetch historical data
  //     final historyResult = await sensorRepository.getHistory(
  //       fieldId: event.fieldId,
  //       duration: event.duration,
  //     );

  //     // Fetch latest reading
  //     final latestResult =
  //         await sensorRepository.getLatestReading(event.fieldId);

  //     historyResult.fold(
  //       (failure) => emit(SoilHealthError(failure.message)),
  //       (readings) {
  //         SensorReading? latestReading;
  //         latestResult.fold(
  //           (failure) => latestReading = null,
  //           (reading) => latestReading = reading,
  //         );

  //         // Calculate statistics
  //         final averages = _calculateAverages(readings);
  //         final trends = _calculateTrends(readings);

  //         emit(SoilHealthLoaded(
  //           readings: readings,
  //           selectedParameter: _currentParameter,
  //           selectedDuration: event.duration,
  //           latestReading: latestReading,
  //           averages: averages,
  //           trends: trends,
  //           lastUpdated: DateTime.now(),
  //         ));
  //       },
  //     );
  //   } catch (e) {
  //     emit(SoilHealthError('Failed to load soil health data: ${e.toString()}'));
  //   }
  // }

  Future<void> _onLoadSoilHealthData(
    LoadSoilHealthData event,
    Emitter<SoilHealthState> emit,
  ) async {
    emit(SoilHealthLoading());
    _currentFieldId = event.fieldId;
    _currentDuration = event.duration;

    try {
      print(
          '🔍 [BLoC] Fetching data for field: ${event.fieldId}, duration: ${event.duration}');
      // Fetch data
      final historyResult = await sensorRepository.getHistory(
        fieldId: event.fieldId,
        duration: event.duration,
      );
      print('🔍 [BLoC] History result: $historyResult');
      final latestResult =
          await sensorRepository.getLatestReading(event.fieldId);

      // ⭐ CORRECT: Use fold() with PROPER syntax
      historyResult.fold(
        // Left = Error case
        (failure) {
          emit(SoilHealthError(failure.message));
        },
        // Right = Success case
        (readings) {
          // Handle latest reading result
          SensorReading? latestReading;

          latestResult.fold(
            (failure) => latestReading = null,
            (reading) => latestReading = reading,
          );

          // Emit result
          if (readings.isNotEmpty) {
            final averages = _calculateAverages(readings);
            final trends = _calculateTrends(readings);

            emit(SoilHealthLoaded(
              readings: readings,
              selectedParameter: _currentParameter,
              selectedDuration: event.duration,
              latestReading: latestReading,
              averages: averages,
              trends: trends,
              lastUpdated: DateTime.now(),
            ));
          } else {
            emit(const SoilHealthError(
                'No sensor data available for this field'));
          }
        },
      );
    } catch (e) {
      emit(SoilHealthError('Failed to load soil health data: ${e.toString()}'));
    }
  }

  Future<void> _onChangeDuration(
    ChangeDuration event,
    Emitter<SoilHealthState> emit,
  ) async {
    if (_currentFieldId.isNotEmpty) {
      add(LoadSoilHealthData(
        fieldId: _currentFieldId,
        duration: event.duration,
      ));
    }
  }

  Future<void> _onRefreshSoilHealth(
    RefreshSoilHealth event,
    Emitter<SoilHealthState> emit,
  ) async {
    add(LoadSoilHealthData(
      fieldId: event.fieldId,
      duration: _currentDuration,
    ));
  }

  Future<void> _onChangeParameter(
    ChangeParameter event,
    Emitter<SoilHealthState> emit,
  ) async {
    _currentParameter = event.parameter;

    if (state is SoilHealthLoaded) {
      final currentState = state as SoilHealthLoaded;
      emit(currentState.copyWith(selectedParameter: event.parameter));
    }
  }

  Map<String, double> _calculateAverages(List<SensorReading> readings) {
    if (readings.isEmpty) return {};

    double sumPh = 0,
        sumN = 0,
        sumP = 0,
        sumK = 0,
        sumMoisture = 0,
        sumTemp = 0;

    for (final reading in readings) {
      sumPh += reading.ph;
      sumN += reading.nitrogen;
      sumP += reading.phosphorus;
      sumK += reading.potassium;
      sumMoisture += reading.moisture;
      sumTemp += reading.temperature;
    }

    final count = readings.length;

    return {
      'ph': sumPh / count,
      'nitrogen': sumN / count,
      'phosphorus': sumP / count,
      'potassium': sumK / count,
      'moisture': sumMoisture / count,
      'temperature': sumTemp / count,
    };
  }

  Map<String, List<double>> _calculateTrends(List<SensorReading> readings) {
    if (readings.isEmpty) return {};

    final trends = <String, List<double>>{
      'ph': [],
      'nitrogen': [],
      'phosphorus': [],
      'potassium': [],
      'moisture': [],
      'temperature': [],
    };

    for (final reading in readings) {
      trends['ph']!.add(reading.ph);
      trends['nitrogen']!.add(reading.nitrogen);
      trends['phosphorus']!.add(reading.phosphorus);
      trends['potassium']!.add(reading.potassium);
      trends['moisture']!.add(reading.moisture);
      trends['temperature']!.add(reading.temperature);
    }

    return trends;
  }
}
