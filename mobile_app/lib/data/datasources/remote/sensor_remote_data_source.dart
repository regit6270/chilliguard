import 'package:chilliguard/core/constants/app_constants.dart'; // ⭐ ADD THIS
import 'package:chilliguard/core/network/api_client.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/utils/app_logger.dart'; // ⭐ ADD THIS for logging
import '../../models/sensor_reading_model.dart';

/// Abstract class defining sensor remote data source contract
abstract class SensorRemoteDataSource {
  /// Get latest sensor reading for a field
  Future<SensorReadingModel> getLatestReading(String fieldId);

  /// Get sensor reading history for a field
  Future<List<SensorReadingModel>> getHistory(
    String fieldId,
    String duration,
  );
}

/// Implementation of SensorRemoteDataSource
@LazySingleton(as: SensorRemoteDataSource)
class SensorRemoteDataSourceImpl implements SensorRemoteDataSource {
  final ApiClient _apiClient;

  SensorRemoteDataSourceImpl(this._apiClient);

  @override
  Future<SensorReadingModel> getLatestReading(String fieldId) async {
    try {
      AppLogger.info('Fetching latest sensor data for field: $fieldId');

      // ⭐ CHANGE #1: Use ApiEndpoints constant instead of hardcoded path
      final response = await _apiClient.get(
        ApiEndpoints.sensorsLatest, // Changed from '/sensors/latest'
        queryParameters: {'field_id': fieldId},
      );

      AppLogger.info('Latest sensor response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == null) {
        // ⭐ CHANGE #2: Handle nested 'data' field in response
        final data = response.data is Map ? response.data : {};

        // Check if response has nested 'data' field (from backend)
        final sensorData = data['data'] ?? data;

        AppLogger.info('Parsing sensor data: $sensorData');
        return SensorReadingModel.fromJson(sensorData);
      } else {
        AppLogger.error(
          'Failed to fetch sensor reading',
          'Status: ${response.statusCode}',
        );
        throw ServerException('Failed to fetch sensor reading');
      }
    } on ServerException catch (e) {
      AppLogger.error('ServerException', e.toString());
      rethrow;
    } catch (e) {
      AppLogger.error('Network error in getLatestReading', e.toString());
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<List<SensorReadingModel>> getHistory(
    String fieldId,
    String duration,
  ) async {
    try {
      AppLogger.info(
        'Fetching sensor history for field: $fieldId, duration: $duration',
      );

      // ⭐ CHANGE #3: Use ApiEndpoints constant instead of hardcoded path
      final response = await _apiClient.get(
        ApiEndpoints.sensorsHistory, // Changed from '/sensors/history'
        queryParameters: {
          'field_id': fieldId,
          'duration': duration,
        },
      );

      AppLogger.info('History sensor response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == null) {
        // ⭐ CHANGE #4: Handle nested response structure correctly
        final responseData = response.data is Map ? response.data : {};

        // Backend returns: { success: true, data: { readings: [...], count: N, duration: '7d' } }
        // OR old format: { readings: [...], count: N }
        // So we need to check for nested 'data' field first
        final dataContainer = responseData['data'] ?? responseData;
        final List<dynamic> readingsList = dataContainer['readings'] ?? [];

        AppLogger.info('Parsing ${readingsList.length} readings from history');

        return readingsList
            .map((json) =>
                SensorReadingModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        AppLogger.error(
          'Failed to fetch sensor history',
          'Status: ${response.statusCode}',
        );
        throw ServerException('Failed to fetch sensor history');
      }
    } on ServerException catch (e) {
      AppLogger.error('ServerException', e.toString());
      rethrow;
    } catch (e) {
      AppLogger.error('Network error in getHistory', e.toString());
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
