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

  Future<void> _onLoadDashboardData(LoadDashboardData event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final results = await Future.wait([
        sensorRepository.getLatestReading(event.fieldId),
        batchRepository.getActiveBatch(event.fieldId),
        alertRepository.getAlerts(unacknowledgedOnly: true),
      ]);

      final sensorResult = results[0];
      final batchResult = results[1];
      final alertsResult = results[2];

      SensorReading? sensorData;
      sensorResult.fold((_) => sensorData = null, (r) => sensorData = r as SensorReading?);

      CropBatch? activeBatch;
      batchResult.fold((_) => activeBatch = null, (b) => activeBatch = b as CropBatch?);

      List<Alert> alerts = [];
      alertsResult.fold((_) => alerts = [], (a) => alerts = (a as List<Alert>?)?.toList() ?? []);

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

  Future<void> _onRefreshDashboardData(RefreshDashboardData event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      try {
        final results = await Future.wait([
          sensorRepository.getLatestReading(event.fieldId),
          batchRepository.getActiveBatch(event.fieldId),
          alertRepository.getAlerts(unacknowledgedOnly: true),
        ]);

        final sensorResult = results[0];
        final batchResult = results[1];
        final alertsResult = results[2];

        SensorReading? sensorData = current.latestSensorData;
        sensorResult.fold((_) => null, (r) => sensorData = r as SensorReading?);

        CropBatch? activeBatch = current.activeBatch;
        batchResult.fold((_) => null, (b) => activeBatch = b as CropBatch?);

        List<Alert> alerts = current.recentAlerts;
        alertsResult.fold((_) => null, (a) => alerts = (a as List<Alert>?)?.toList() ?? []);

        final feasibilityScore = _calculateFeasibilityScore(sensorData);
        final feasibilityStatus = _getFeasibilityStatus(feasibilityScore);

        emit(current.copyWith(
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

  Future<void> _onChangeSelectedField(ChangeSelectedField event, Emitter<DashboardState> emit) async {
    add(LoadDashboardData(event.fieldId));
  }

  double _calculateFeasibilityScore(SensorReading? reading) {
    if (reading == null) return 0.0;

    double score = 0.0;

    if (reading.ph >= 5.5 && reading.ph <= 7.5) {
      score += 25.0;
    } else if (reading.ph >= 5.0 && reading.ph <= 8.0) {
      score += 15.0;
    }

    if (reading.nitrogen >= 100 && reading.nitrogen <= 150) {
      score += 15.0;
    } else if (reading.nitrogen >= 80 && reading.nitrogen <= 170) {
      score += 10.0;
    }

    if (reading.phosphorus >= 50 && reading.phosphorus <= 75) {
      score += 15.0;
    } else if (reading.phosphorus >= 40 && reading.phosphorus <= 85) {
      score += 10.0;
    }

    if (reading.potassium >= 50 && reading.potassium <= 100) {
      score += 15.0;
    } else if (reading.potassium >= 40 && reading.potassium <= 110) {
      score += 10.0;
    }

    if (reading.moisture >= 60 && reading.moisture <= 70) {
      score += 20.0;
    } else if (reading.moisture >= 50 && reading.moisture <= 80) {
      score += 12.0;
    }

    if (reading.temperature >= 20 && reading.temperature <= 30) {
      score += 10.0;
    } else if (reading.temperature >= 15 && reading.temperature <= 35) {
      score += 5.0;
    }

    if (score > 100) score = 100;
    return score;
  }

  String _getFeasibilityStatus(double score) {
    if (score >= 75) return 'ready';
    if (score >= 50) return 'minor_adjustments';
    return 'needs_improvement';
  }
}
