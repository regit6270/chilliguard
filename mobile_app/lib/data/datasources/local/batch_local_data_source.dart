// Add if needed,skipped for now
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/error/exceptions.dart';
import '../../models/crop_batch_model.dart';

abstract class BatchLocalDataSource {
  Future<void> cacheBatch(CropBatchModel batch);
  Future<List<CropBatchModel>> getCachedBatches(
      {String? fieldId, String? status});
  Future<CropBatchModel?> getCachedBatch(String batchId);
  Future<void> clearCache();
}

@LazySingleton(as: BatchLocalDataSource)
class BatchLocalDataSourceImpl implements BatchLocalDataSource {
  final DatabaseHelper _dbHelper;

  BatchLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> cacheBatch(CropBatchModel batch) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'crop_batches',
        batch.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to cache batch: ${e.toString()}');
    }
  }

  @override
  Future<List<CropBatchModel>> getCachedBatches({
    String? fieldId,
    String? status,
  }) async {
    try {
      final db = await _dbHelper.database;

      String? whereClause;
      List<dynamic>? whereArgs;

      if (fieldId != null && status != null) {
        whereClause = 'field_id = ? AND status = ?';
        whereArgs = [fieldId, status];
      } else if (fieldId != null) {
        whereClause = 'field_id = ?';
        whereArgs = [fieldId];
      } else if (status != null) {
        whereClause = 'status = ?';
        whereArgs = [status];
      }

      final List<Map<String, dynamic>> maps = await db.query(
        'crop_batches',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'planting_date DESC',
        limit: 100,
      );

      return maps.map((json) => CropBatchModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to get cached batches: ${e.toString()}');
    }
  }

  @override
  Future<CropBatchModel?> getCachedBatch(String batchId) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'crop_batches',
        where: 'batch_id = ?',
        whereArgs: [batchId],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return CropBatchModel.fromJson(maps.first);
    } catch (e) {
      throw CacheException('Failed to get cached batch: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('crop_batches');
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
