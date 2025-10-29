import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

// RENAMED to match your code
class ConnectivityStartMonitoring extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;
  const ConnectivityChanged(this.isConnected);
  @override
  List<Object?> get props => [isConnected];
}
