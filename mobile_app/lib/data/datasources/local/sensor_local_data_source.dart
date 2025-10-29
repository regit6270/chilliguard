import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/error/exceptions.dart';
import '../../models/sensor_reading_model.dart';

abstract class SensorLocalDataSource {
  Future<void> cacheReading(SensorReadingModel reading);
  Future<List<SensorReadingModel>> getCachedReadings(String fieldId);
  Future<SensorReadingModel?> getLatestCached(String fieldId);
  Future<void> clearCache();
}

@LazySingleton(as: SensorLocalDataSource)
class SensorLocalDataSourceImpl implements SensorLocalDataSource {
  final DatabaseHelper _dbHelper;

  SensorLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> cacheReading(SensorReadingModel reading) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'sensor_readings',
        reading.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to cache reading: ${e.toString()}');
    }
  }

  @override
  Future<List<SensorReadingModel>> getCachedReadings(String fieldId) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'sensor_readings',
        where: 'field_id = ?',
        whereArgs: [fieldId],
        orderBy: 'timestamp DESC',
        limit: 100,
      );

      return maps.map((json) => SensorReadingModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to get cached readings: ${e.toString()}');
    }
  }

  @override
  Future<SensorReadingModel?> getLatestCached(String fieldId) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'sensor_readings',
        where: 'field_id = ?',
        whereArgs: [fieldId],
        orderBy: 'timestamp DESC',
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return SensorReadingModel.fromJson(maps.first);
    } catch (e) {
      throw CacheException('Failed to get latest cached: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('sensor_readings');
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
