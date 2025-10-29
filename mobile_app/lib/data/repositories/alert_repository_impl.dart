import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/alert.dart';
import '../datasources/local/alert_local_data_source.dart';
import '../datasources/remote/alert_remote_data_source.dart';
import '../models/alert_model.dart';
import 'alert_repository.dart';

@LazySingleton(as: AlertRepository)
class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource remoteDataSource;
  final AlertLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AlertRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Alert>>> getAlerts({
    bool unacknowledgedOnly = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final alerts = await remoteDataSource.getAlerts(
          unacknowledgedOnly: unacknowledgedOnly,
        );

        // Cache alerts
        for (final alert in alerts) {
          await localDataSource.cacheAlert(alert);
        }

        return Right(alerts.map((a) => a.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedAlerts = await localDataSource.getCachedAlerts(
          unacknowledgedOnly: unacknowledgedOnly,
        );
        return Right(cachedAlerts.map((a) => a.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> acknowledgeAlert(String alertId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.acknowledgeAlert(alertId);

        // Update local cache
        await localDataSource.updateAlertAcknowledgement(alertId, true);

        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStatistics() async {
    if (await networkInfo.isConnected) {
      try {
        final statistics = await remoteDataSource.getStatistics();
        return Right(statistics);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheAlerts(List<Alert> alerts) async {
    try {
      for (final alert in alerts) {
        final model = AlertModel.fromEntity(alert);
        await localDataSource.cacheAlert(model);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Alert>>> getCachedAlerts() async {
    try {
      final cachedAlerts = await localDataSource.getCachedAlerts();
      return Right(cachedAlerts.map((a) => a.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
