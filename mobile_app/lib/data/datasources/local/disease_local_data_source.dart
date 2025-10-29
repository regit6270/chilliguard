import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/error/exceptions.dart';
import '../../models/disease_detection_model.dart';

abstract class DiseaseLocalDataSource {
  Future<void> cacheDetection(DiseaseDetectionModel detection);
  Future<List<DiseaseDetectionModel>> getCachedDetections(
      {String? batchId, int limit = 50});
  Future<void> clearCache();
}

@LazySingleton(as: DiseaseLocalDataSource)
class DiseaseLocalDataSourceImpl implements DiseaseLocalDataSource {
  final DatabaseHelper _dbHelper;

  DiseaseLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> cacheDetection(DiseaseDetectionModel detection) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'disease_detections',
        detection.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to cache detection: ${e.toString()}');
    }
  }

  @override
  Future<List<DiseaseDetectionModel>> getCachedDetections({
    String? batchId,
    int limit = 50,
  }) async {
    try {
      final db = await _dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'disease_detections',
        where: batchId != null ? 'batch_id = ?' : null,
        whereArgs: batchId != null ? [batchId] : null,
        orderBy: 'timestamp DESC',
        limit: limit,
      );

      return maps.map((json) => DiseaseDetectionModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to get cached detections: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('disease_detections');
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
