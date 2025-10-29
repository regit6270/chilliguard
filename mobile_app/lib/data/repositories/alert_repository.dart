import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/alert.dart';

abstract class AlertRepository {
  /// Get all alerts for user
  Future<Either<Failure, List<Alert>>> getAlerts({
    bool unacknowledgedOnly = false,
  });

  /// Acknowledge alert
  Future<Either<Failure, void>> acknowledgeAlert(String alertId);

  /// Get alert statistics
  Future<Either<Failure, Map<String, dynamic>>> getStatistics();

  /// Cache alerts locally
  Future<Either<Failure, void>> cacheAlerts(List<Alert> alerts);

  /// Get cached alerts (offline)
  Future<Either<Failure, List<Alert>>> getCachedAlerts();
}
