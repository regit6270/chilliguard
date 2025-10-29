import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/alert_repository.dart';
import '../../../domain/entities/alert.dart';

part 'alert_event.dart';
part 'alert_state.dart';

@injectable
class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final AlertRepository alertRepository;

  AlertBloc({
    required this.alertRepository,
  }) : super(AlertInitial()) {
    on<LoadAlerts>(_onLoadAlerts);
    on<AcknowledgeAlert>(_onAcknowledgeAlert);
    on<RefreshAlerts>(_onRefreshAlerts);
    on<FilterAlertsBySeverity>(_onFilterAlertsBySeverity);
    on<LoadAlertStatistics>(_onLoadAlertStatistics);
  }

  Future<void> _onLoadAlerts(
    LoadAlerts event,
    Emitter<AlertState> emit,
  ) async {
    emit(AlertLoading());

    try {
      final result = await alertRepository.getAlerts(
        unacknowledgedOnly: event.unacknowledgedOnly,
      );

      result.fold(
        (failure) => emit(AlertError(failure.message)),
        (alerts) {
          final unacknowledgedCount =
              alerts.where((a) => !a.acknowledged).length;
          final criticalCount =
              alerts.where((a) => a.isCritical && !a.acknowledged).length;

          emit(AlertsLoaded(
            alerts: alerts,
            filteredAlerts: alerts,
            selectedSeverity: null,
            unacknowledgedCount: unacknowledgedCount,
            criticalCount: criticalCount,
            lastUpdated: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      emit(AlertError('Failed to load alerts: ${e.toString()}'));
    }
  }

  Future<void> _onAcknowledgeAlert(
    AcknowledgeAlert event,
    Emitter<AlertState> emit,
  ) async {
    if (state is AlertsLoaded) {
      emit(AlertAcknowledging(event.alertId));

      try {
        final result = await alertRepository.acknowledgeAlert(event.alertId);

        result.fold(
          (failure) => emit(AlertError(failure.message)),
          (_) {
            emit(AlertAcknowledged(event.alertId));
            // Reload alerts after acknowledgment
            add(const LoadAlerts());
          },
        );
      } catch (e) {
        emit(AlertError('Failed to acknowledge alert: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshAlerts(
    RefreshAlerts event,
    Emitter<AlertState> emit,
  ) async {
    add(const LoadAlerts());
  }

  Future<void> _onFilterAlertsBySeverity(
    FilterAlertsBySeverity event,
    Emitter<AlertState> emit,
  ) async {
    if (state is AlertsLoaded) {
      final currentState = state as AlertsLoaded;

      List<Alert> filteredAlerts;
      if (event.severity == null) {
        filteredAlerts = currentState.alerts;
      } else {
        filteredAlerts = currentState.alerts
            .where((alert) => alert.severity == event.severity)
            .toList();
      }

      emit(currentState.copyWith(
        filteredAlerts: filteredAlerts,
        selectedSeverity: event.severity,
      ));
    }
  }

  Future<void> _onLoadAlertStatistics(
    LoadAlertStatistics event,
    Emitter<AlertState> emit,
  ) async {
    try {
      final result = await alertRepository.getStatistics();

      result.fold(
        (failure) => emit(AlertError(failure.message)),
        (statistics) => emit(AlertStatisticsLoaded(statistics)),
      );
    } catch (e) {
      emit(AlertError('Failed to load statistics: ${e.toString()}'));
    }
  }
}
