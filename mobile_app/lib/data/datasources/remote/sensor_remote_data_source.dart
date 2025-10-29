//import '../../../core/network/api_client.dart';
import 'package:chilliguard/core/network/api_client.dart' show ApiClient;
import 'package:injectable/injectable.dart';

import '../../../core/error/exceptions.dart';
import '../../models/sensor_reading_model.dart';

abstract class SensorRemoteDataSource {
  Future<SensorReadingModel> getLatestReading(String fieldId);
  Future<List<SensorReadingModel>> getHistory(String fieldId, String duration);
}

@LazySingleton(as: SensorRemoteDataSource)
class SensorRemoteDataSourceImpl implements SensorRemoteDataSource {
  final ApiClient _apiClient;

  SensorRemoteDataSourceImpl(this._apiClient);

  @override
  Future<SensorReadingModel> getLatestReading(String fieldId) async {
    try {
      final response = await _apiClient.get(
        '/sensors/latest',
        queryParameters: {'field_id': fieldId},
      );

      if (response.statusCode == 200) {
        return SensorReadingModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch sensor reading');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<List<SensorReadingModel>> getHistory(
    String fieldId,
    String duration,
  ) async {
    try {
      final response = await _apiClient.get(
        '/sensors/history',
        queryParameters: {
          'field_id': fieldId,
          'duration': duration,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        return data.map((json) => SensorReadingModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch sensor history');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
