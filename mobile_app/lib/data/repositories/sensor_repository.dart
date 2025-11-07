import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/sensor_reading.dart';

abstract class SensorRepository {
  /// Get latest sensor reading for a field
  Future<Either<Failure, SensorReading>> getLatestReading(String fieldId);

  /// Get historical sensor readings
  Future<Either<Failure, List<SensorReading>>> getHistory({
    required String fieldId,
    String duration = '7d',
  });

  /// Cache sensor reading locally
  Future<Either<Failure, void>> cacheReading(SensorReading reading);

  /// Get cached readings (offline)
  Future<Either<Failure, List<SensorReading>>> getCachedReadings(
      String fieldId);

  // ============================================
  // ADDITIONAL METHODS FOR BLOC USAGE
  // ============================================

  /// Get latest reading (direct - throws on error)
  Future<SensorReading?> getLatestReadingDirect(String fieldId);

  /// Get readings between dates
  Future<List<SensorReading>> getReadings(
    String fieldId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get real-time sensor stream
  Stream<SensorReading> getSensorStream(String fieldId);
}
