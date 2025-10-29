import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/alert_repository.dart';
import '../../../data/repositories/batch_repository.dart';
import '../../../data/repositories/sensor_repository.dart';
import '../../../domain/entities/alert.dart';
import '../../../domain/entities/crop_batch.dart';
import '../../../domain/entities/sensor_reading.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SensorRepository sensorRepository;
  final BatchRepository batchRepository;
  final AlertRepository alertRepository;

  DashboardBloc({
    required this.sensorRepository,
    required this.batchRepository,
    required this.alertRepository,
  }) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
    on<ChangeSelectedField>(_onChangeSelectedField);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      // Fetch all dashboard data in parallel
      final results = await Future.wait([
        sensorRepository.getLatestReading(event.fieldId),
        batchRepository.getActiveBatch(event.fieldId),
        alertRepository.getAlerts(unacknowledgedOnly: true),
      ]);

      // Extract results
      final sensorResult = results[0];
      final batchResult = results[1];
      final alertsResult = results[2];

      // Get sensor data
      SensorReading? sensorData;
      sensorResult.fold(
        (failure) => sensorData = null,
        (reading) => sensorData = reading as SensorReading?,
      );

      // Get active batch
      CropBatch? activeBatch;
      batchResult.fold(
        (failure) => activeBatch = null,
        (batch) => activeBatch = batch as CropBatch?,
      );

      // Get alerts
      List<Alert> alerts = [];
      alertsResult.fold(
        (failure) => alerts = [],
        (alertList) =>
            alerts = (alertList as List<Alert>?)?.take(5).toList() ?? [],
      );

      // Calculate feasibility score from sensor data
      final feasibilityScore = _calculateFeasibilityScore(sensorData);
      final feasibilityStatus = _getFeasibilityStatus(feasibilityScore);

      emit(DashboardLoaded(
        latestSensorData: sensorData,
        activeBatch: activeBatch,
        feasibilityScore: feasibilityScore,
        feasibilityStatus: feasibilityStatus,
        recentAlerts: alerts,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    // Keep current state while refreshing
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;

      try {
        // Fetch updated data
        final results = await Future.wait([
          sensorRepository.getLatestReading(event.fieldId),
          batchRepository.getActiveBatch(event.fieldId),
          alertRepository.getAlerts(unacknowledgedOnly: true),
        ]);

        final sensorResult = results[0];
        final batchResult = results[1];
        final alertsResult = results[2];

        SensorReading? sensorData = currentState.latestSensorData;
        sensorResult.fold(
          (failure) => null,
          (reading) => sensorData = reading as SensorReading?,
        );

        CropBatch? activeBatch = currentState.activeBatch;
        batchResult.fold(
          (failure) => null,
          (batch) => activeBatch = batch as CropBatch?,
        );

        List<Alert> alerts = currentState.recentAlerts;
        alertsResult.fold(
          (failure) => null,
          (alertList) =>
              alerts = (alertList as List<Alert>?)?.take(5).toList() ?? [],
        );

        final feasibilityScore = _calculateFeasibilityScore(sensorData);
        final feasibilityStatus = _getFeasibilityStatus(feasibilityScore);

        emit(currentState.copyWith(
          latestSensorData: sensorData,
          activeBatch: activeBatch,
          feasibilityScore: feasibilityScore,
          feasibilityStatus: feasibilityStatus,
          recentAlerts: alerts,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(DashboardError('Failed to refresh dashboard: ${e.toString()}'));
      }
    } else {
      add(LoadDashboardData(event.fieldId));
    }
  }

  Future<void> _onChangeSelectedField(
    ChangeSelectedField event,
    Emitter<DashboardState> emit,
  ) async {
    add(LoadDashboardData(event.fieldId));
  }

  // Calculate feasibility score based on chilli requirements (PRD Section 4.1.2)
  double _calculateFeasibilityScore(SensorReading? reading) {
    if (reading == null) return 0.0;

    double score = 0.0;
    int totalParameters = 6; // ignore: unused_local_variable

    // pH: Ideal 5.5-7.5 (Weight: 25%)
    if (reading.ph >= 5.5 && reading.ph <= 7.5) {
      score += 25.0;
    } else if (reading.ph >= 5.0 && reading.ph <= 8.0) {
      score += 15.0;
    }

    // Nitrogen: 100-150 kg/ha (Weight: 15%)
    if (reading.nitrogen >= 100 && reading.nitrogen <= 150) {
      score += 15.0;
    } else if (reading.nitrogen >= 80 && reading.nitrogen <= 170) {
      score += 10.0;
    }

    // Phosphorus: 50-75 kg/ha (Weight: 15%)
    if (reading.phosphorus >= 50 && reading.phosphorus <= 75) {
      score += 15.0;
    } else if (reading.phosphorus >= 40 && reading.phosphorus <= 85) {
      score += 10.0;
    }

    // Potassium: 50-100 kg/ha (Weight: 15%)
    if (reading.potassium >= 50 && reading.potassium <= 100) {
      score += 15.0;
    } else if (reading.potassium >= 40 && reading.potassium <= 110) {
      score += 10.0;
    }

    // Moisture: 60-70% field capacity (Weight: 20%)
    if (reading.moisture >= 60 && reading.moisture <= 70) {
      score += 20.0;
    } else if (reading.moisture >= 50 && reading.moisture <= 80) {
      score += 12.0;
    }

    // Temperature: 20-30°C optimal (Weight: 10%)
    if (reading.temperature >= 20 && reading.temperature <= 30) {
      score += 10.0;
    } else if (reading.temperature >= 15 && reading.temperature <= 35) {
      score += 5.0;
    }

    return score;
  }

  String _getFeasibilityStatus(double score) {
    if (score >= 75) return 'ready';
    if (score >= 50) return 'minor_adjustments';
    return 'needs_improvement';
  }
}
