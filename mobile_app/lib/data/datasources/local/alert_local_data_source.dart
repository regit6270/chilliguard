import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/error/exceptions.dart';
import '../../models/alert_model.dart';

abstract class AlertLocalDataSource {
  Future<void> cacheAlert(AlertModel alert);
  Future<List<AlertModel>> getCachedAlerts({bool unacknowledgedOnly = false});
  Future<void> updateAlertAcknowledgement(String alertId, bool acknowledged);
  Future<void> clearCache();
}

@LazySingleton(as: AlertLocalDataSource)
class AlertLocalDataSourceImpl implements AlertLocalDataSource {
  final DatabaseHelper _dbHelper;

  AlertLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> cacheAlert(AlertModel alert) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'alerts',
        alert.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to cache alert: ${e.toString()}');
    }
  }

  @override
  Future<List<AlertModel>> getCachedAlerts(
      {bool unacknowledgedOnly = false}) async {
    try {
      final db = await _dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'alerts',
        where: unacknowledgedOnly ? 'acknowledged = ?' : null,
        whereArgs: unacknowledgedOnly ? [0] : null,
        orderBy: 'timestamp DESC',
        limit: 100,
      );

      return maps.map((json) => AlertModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to get cached alerts: ${e.toString()}');
    }
  }

  @override
  Future<void> updateAlertAcknowledgement(
      String alertId, bool acknowledged) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'alerts',
        {
          'acknowledged': acknowledged ? 1 : 0,
          'acknowledged_at':
              acknowledged ? DateTime.now().toIso8601String() : null,
        },
        where: 'alert_id = ?',
        whereArgs: [alertId],
      );
    } catch (e) {
      throw CacheException('Failed to update alert: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('alerts');
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
