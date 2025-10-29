import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart'; // ADD THIS

import '../../../core/utils/app_logger.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

@injectable // ADD THIS
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<ConnectivityStartMonitoring>(_onConnectivityStartMonitoring);
    on<ConnectivityChanged>(_onConnectivityChanged);

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = result != ConnectivityResult.none;
      add(ConnectivityChanged(isConnected));
    });
  }

  Future<void> _onConnectivityStartMonitoring(
    ConnectivityStartMonitoring event,
    Emitter<ConnectivityState> emit,
  ) async {
    try {
      final result = await _connectivity.checkConnectivity();
      final isConnected = result != (ConnectivityResult.none);

      if (isConnected) {
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    } catch (e) {
      AppLogger.error('Connectivity check error', e);
      emit(ConnectivityOffline());
    }
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    if (event.isConnected) {
      AppLogger.info('Network: Online');
      emit(ConnectivityOnline());
    } else {
      AppLogger.info('Network: Offline');
      emit(ConnectivityOffline());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
