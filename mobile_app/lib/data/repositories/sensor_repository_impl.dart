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

  /// Get latest reading (returns null on error, doesn't throw)
  @override
  Future<SensorReading?> getLatestReadingDirect(String fieldId) async {
    final result = await getLatestReading(fieldId);
    return result.fold(
      (failure) => null,
      (reading) => reading,
    );
  }

  /// Get readings between dates (returns empty list on error)
  @override
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
      (failure) => <SensorReading>[],
      (readings) => readings,
    );
  }

  /// Get real-time sensor stream
  @override
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

// import 'package:dartz/dartz.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:injectable/injectable.dart';

// import '../../core/error/failures.dart';
// import '../../core/utils/app_logger.dart';
// import '../../domain/entities/sensor_reading.dart';
// import 'sensor_repository.dart';

// @LazySingleton(as: SensorRepository)
// class SensorRepositoryImpl implements SensorRepository {
//   final FirebaseDatabase _database;

//   SensorRepositoryImpl(this._database);

//   @override
//   Future<Either<Failure, SensorReading?>> getLatestReading(
//       String fieldId) async {
//     try {
//       AppLogger.info('📡 Fetching latest sensor reading for field: $fieldId');

//       // Fetch all sensor data
//       final snapshot = await _database.ref('sensorData').get();

//       if (!snapshot.exists) {
//         AppLogger.warning('⚠️ No sensor data found in Firebase');
//         return const Right(null);
//       }

//       // Parse all readings and find latest for this field
//       final data = snapshot.value as Map<dynamic, dynamic>;
//       SensorReading? latestReading;
//       DateTime? latestTimestamp;

//       data.forEach((key, value) {
//         final readingData = Map<String, dynamic>.from(value as Map);

//         // Check if reading belongs to this field
//         if (readingData['field_id'] == fieldId) {
//           final reading = _parseSensorReading(key.toString(), readingData);

//           if (latestTimestamp == null ||
//               reading.timestamp.isAfter(latestTimestamp!)) {
//             latestReading = reading;
//             latestTimestamp = reading.timestamp;
//           }
//         }
//       });

//       if (latestReading == null) {
//         AppLogger.warning('⚠️ No readings found for field: $fieldId');
//         return const Right(null);
//       }

//       AppLogger.info('✅ Latest reading fetched: ${latestReading!.timestamp}');
//       return Right(latestReading);
//     } catch (e, stackTrace) {
//       AppLogger.error('Error fetching latest reading', e, stackTrace);
//       return Left(
//           ServerFailure('Failed to fetch sensor data: ${e.toString()}'));
//     }
//   }

//   @override
//   Future<Either<Failure, List<SensorReading>>> getHistory({
//     required String fieldId,
//     String duration = '7d',
//   }) async {
//     try {
//       AppLogger.info(
//           '📊 Fetching sensor history for field: $fieldId (duration: $duration)');

//       // Parse duration (e.g., '7d' -> 7 days)
//       final days = int.parse(duration.replaceAll('d', ''));
//       final cutoffDate = DateTime.now().subtract(Duration(days: days));

//       // Fetch all sensor data
//       final snapshot = await _database.ref('sensorData').get();

//       if (!snapshot.exists) {
//         AppLogger.warning('⚠️ No sensor data found in Firebase');
//         return const Right([]);
//       }

//       // Parse readings for this field within timeframe
//       final data = snapshot.value as Map<dynamic, dynamic>;
//       final List<SensorReading> readings = [];

//       data.forEach((key, value) {
//         final readingData = Map<String, dynamic>.from(value as Map);

//         // Check if reading belongs to this field
//         if (readingData['field_id'] == fieldId) {
//           final reading = _parseSensorReading(key.toString(), readingData);

//           // Filter by date
//           if (reading.timestamp.isAfter(cutoffDate)) {
//             readings.add(reading);
//           }
//         }
//       });

//       // Sort by timestamp (oldest first)
//       readings.sort((a, b) => a.timestamp.compareTo(b.timestamp));

//       AppLogger.info('✅ Fetched ${readings.length} historical readings');
//       return Right(readings);
//     } catch (e, stackTrace) {
//       AppLogger.error('Error fetching sensor history', e, stackTrace);
//       return Left(
//           ServerFailure('Failed to fetch sensor history: ${e.toString()}'));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> cacheReading(SensorReading reading) async {
//     // TODO: Implement local caching with Hive
//     return const Right(null);
//   }

//   @override
//   Future<Either<Failure, List<SensorReading>>> getCachedReadings(
//       String fieldId) async {
//     // TODO: Implement offline reading retrieval
//     return const Right([]);
//   }

//   /// Parse Firebase data into SensorReading entity
//   SensorReading _parseSensorReading(
//       String readingId, Map<String, dynamic> data) {
//     return SensorReading(
//       readingId: readingId,
//       fieldId: data['field_id'] as String,
//       ph: (data['ph'] as num).toDouble(),
//       nitrogen: (data['nitrogen'] as num).toDouble(),
//       phosphorus: (data['phosphorus'] as num).toDouble(),
//       potassium: (data['potassium'] as num).toDouble(),
//       moisture: (data['moisture'] as num).toDouble(),
//       temperature: (data['temperature'] as num).toDouble(),
//       humidity: (data['humidity'] as num).toDouble(),
//       timestamp: DateTime.fromMillisecondsSinceEpoch(
//         data['timestamp'] as int,
//       ),
//     );
//   }
// }
