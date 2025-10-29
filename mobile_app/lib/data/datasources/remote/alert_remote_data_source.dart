//import '../../../core/network/api_client.dart';
import 'package:chilliguard/core/network/api_client.dart' show ApiClient;
import 'package:injectable/injectable.dart';

import '../../../core/error/exceptions.dart';
import '../../models/alert_model.dart';

abstract class AlertRemoteDataSource {
  Future<List<AlertModel>> getAlerts({bool unacknowledgedOnly = false});
  Future<void> acknowledgeAlert(String alertId);
  Future<Map<String, dynamic>> getStatistics();
}

@LazySingleton(as: AlertRemoteDataSource)
class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {
  final ApiClient _apiClient;

  AlertRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AlertModel>> getAlerts({bool unacknowledgedOnly = false}) async {
    try {
      final response = await _apiClient.get(
        '/alerts',
        queryParameters: {
          'unacknowledged': unacknowledgedOnly,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['alerts'] as List;
        return data.map((json) => AlertModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch alerts');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    try {
      final response = await _apiClient.post(
        '/alerts/$alertId/acknowledge',
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to acknowledge alert');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _apiClient.get('/alerts/statistics');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('Failed to fetch statistics');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
