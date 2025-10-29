part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  final String fieldId;

  const LoadDashboardData(this.fieldId);

  @override
  List<Object> get props => [fieldId];
}

class RefreshDashboardData extends DashboardEvent {
  final String fieldId;

  const RefreshDashboardData(this.fieldId);

  @override
  List<Object> get props => [fieldId];
}

class ChangeSelectedField extends DashboardEvent {
  final String fieldId;

  const ChangeSelectedField(this.fieldId);

  @override
  List<Object> get props => [fieldId];
}
