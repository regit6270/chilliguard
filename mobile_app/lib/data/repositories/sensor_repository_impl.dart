import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/sensor_reading.dart';
import '../datasources/local/sensor_local_data_source.dart';
import '../datasources/remote/sensor_remote_data_source.dart';
import '../models/sensor_reading_model.dart';
import '../repositories/sensor_repository.dart';

@LazySingleton(as: SensorRepository)
class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDataSource remoteDataSource;
  final SensorLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SensorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // ============================================
  // ORIGINAL REPOSITORY INTERFACE METHODS
  // ============================================

  @override
  Future<Either<Failure, SensorReading>> getLatestReading(
      String fieldId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReading = await remoteDataSource.getLatestReading(fieldId);
        await localDataSource.cacheReading(remoteReading);
        return Right(remoteReading.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final cachedReading = await localDataSource.getLatestCached(fieldId);
        if (cachedReading != null) {
          return Right(cachedReading.toEntity());
        } else {
          return const Left(CacheFailure('No cached data available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<SensorReading>>> getHistory({
    required String fieldId,
    String duration = '7d',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReadings =
            await remoteDataSource.getHistory(fieldId, duration);

        // Cache all readings
        for (final reading in remoteReadings) {
          await localDataSource.cacheReading(reading);
        }

        return Right(remoteReadings.map((r) => r.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedReadings = await localDataSource.getCachedReadings(fieldId);
        return Right(cachedReadings.map((r) => r.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> cacheReading(SensorReading reading) async {
    try {
      final model = SensorReadingModel.fromEntity(reading);
      await localDataSource.cacheReading(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SensorReading>>> getCachedReadings(
      String fieldId) async {
    try {
      final cachedReadings = await localDataSource.getCachedReadings(fieldId);
      return Right(cachedReadings.map((r) => r.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  // ============================================
  // BLOC-FRIENDLY METHODS (unwrapped results)
  // ============================================

  /// Get latest reading (throws on error)
  Future<SensorReading?> getLatestReadingDirect(String fieldId) async {
    final result = await getLatestReading(fieldId);
    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (reading) => reading,
    );
  }

  /// Get readings between dates
  Future<List<SensorReading>> getReadings(
    String fieldId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Calculate duration from dates
    final duration = DateTime.now().difference(startDate).inDays;
    final durationStr = '${duration}d';

    final result = await getHistory(fieldId: fieldId, duration: durationStr);
    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (readings) => readings,
    );
  }

  /// Get real-time sensor stream
  Stream<SensorReading> getSensorStream(String fieldId) async* {
    // Poll every 30 seconds for new data
    while (true) {
      await Future.delayed(const Duration(seconds: 30));

      try {
        final result = await getLatestReading(fieldId);
        final reading = result.fold(
          (failure) => null,
          (reading) => reading,
        );

        if (reading != null) {
          yield reading;
        }
      } catch (e) {
        // Continue polling even on errors
        continue;
      }
    }
  }
}
