import 'package:injectable/injectable.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../models/fertilizer_schedule_model.dart';
import '../../models/soil_recommendation_model.dart';

/// Abstract class defining recommendation remote data source contract
///
/// Note: The backend always returns bilingual data (both 'en' and 'hi' fields).
/// The language parameter is informational only and doesn't filter the response.
abstract class RecommendationRemoteDataSource {
  /// Get soil improvement recommendations based on sensor data
  ///
  /// [language] parameter is optional and defaults to 'en'.
  /// Backend returns both English and Hindi regardless of this value.
  Future<List<SoilRecommendationModel>> getSoilImprovements({
    required String fieldId,
    required Map<String, dynamic> sensorData,
    String language = 'en',
  });

  /// Get fertilizer application schedule
  Future<FertilizerScheduleModel> getFertilizerSchedule({
    required String plantingDate,
    required double fieldArea,
    String cropType = 'chilli',
    String varietyType = 'hybrid',
  });

  /// Get soil parameter information and thresholds
  Future<Map<String, dynamic>> getSoilParametersInfo();
}

/// Implementation of RecommendationRemoteDataSource
@LazySingleton(as: RecommendationRemoteDataSource)
class RecommendationRemoteDataSourceImpl
    implements RecommendationRemoteDataSource {
  final ApiClient _apiClient;

  RecommendationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SoilRecommendationModel>> getSoilImprovements({
    required String fieldId,
    required Map<String, dynamic> sensorData,
    String language = 'en',
  }) async {
    try {
      AppLogger.info(
          'Fetching soil improvements for field: $fieldId with sensor data: $sensorData');

      final response = await _apiClient.post(
        ApiEndpoints.soilImprovements,
        data: {
          'field_id': fieldId,
          'sensor_data': sensorData,
          'language': language,
        },
      );

      AppLogger.info('Soil improvements response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == null) {
        final data = response.data is Map ? response.data : {};

        if (data['status'] == 'error') {
          final errorMessage =
              data['message'] as String? ?? 'Failed to fetch soil improvements';
          AppLogger.error('Backend error', errorMessage);
          throw ServerException(errorMessage);
        }

        final recommendations = data['recommendations'] as List<dynamic>?;

        if (recommendations == null) {
          AppLogger.warning('No recommendations in response');
          return [];
        }

        AppLogger.info(
            'Parsing ${recommendations.length} soil improvement recommendations');

        return recommendations
            .map((json) =>
                SoilRecommendationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        AppLogger.error(
          'Failed to fetch soil improvements',
          'Status: ${response.statusCode}',
        );
        throw ServerException(
            'Failed to fetch soil improvements: ${response.statusCode}');
      }
    } on ServerException catch (e) {
      AppLogger.error('ServerException in getSoilImprovements', e.toString());
      rethrow;
    } catch (e) {
      AppLogger.error('Network error in getSoilImprovements', e.toString());
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<FertilizerScheduleModel> getFertilizerSchedule({
    required String plantingDate,
    required double fieldArea,
    String cropType = 'chilli',
    String varietyType = 'hybrid',
  }) async {
    try {
      AppLogger.info(
          'Fetching fertilizer schedule for planting date: $plantingDate, area: $fieldArea ha');

      final response = await _apiClient.post(
        ApiEndpoints.fertilizerSchedule,
        data: {
          'planting_date': plantingDate,
          'field_area': fieldArea,
          'crop_type': cropType,
          'variety_type': varietyType,
        },
      );

      AppLogger.info('Fertilizer schedule response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == null) {
        final data = response.data is Map ? response.data : {};

        if (data['status'] == 'error') {
          final errorMessage = data['message'] as String? ??
              'Failed to fetch fertilizer schedule';
          AppLogger.error('Backend error', errorMessage);
          throw ServerException(errorMessage);
        }

        AppLogger.info('Parsing fertilizer schedule');

        // Create the structure expected by the model
        final scheduleData = {
          'schedule': data['schedule'] ?? [],
          'summary': data['summary'] ?? {},
        };

        return FertilizerScheduleModel.fromJson(scheduleData);
      } else {
        AppLogger.error(
          'Failed to fetch fertilizer schedule',
          'Status: ${response.statusCode}',
        );
        throw ServerException(
            'Failed to fetch fertilizer schedule: ${response.statusCode}');
      }
    } on ServerException catch (e) {
      AppLogger.error('ServerException in getFertilizerSchedule', e.toString());
      rethrow;
    } catch (e) {
      AppLogger.error('Network error in getFertilizerSchedule', e.toString());
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getSoilParametersInfo() async {
    try {
      AppLogger.info('Fetching soil parameters info');

      final response = await _apiClient.get(
        ApiEndpoints.soilParametersInfo,
      );

      AppLogger.info('Soil parameters info response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == null) {
        final data = response.data is Map ? response.data : {};

        if (data['status'] == 'error') {
          final errorMessage = data['message'] as String? ??
              'Failed to fetch soil parameters info';
          AppLogger.error('Backend error', errorMessage);
          throw ServerException(errorMessage);
        }

        AppLogger.info('Soil parameters info fetched successfully');
        return Map<String, dynamic>.from(data);
      } else {
        AppLogger.error(
          'Failed to fetch soil parameters info',
          'Status: ${response.statusCode}',
        );
        throw ServerException(
            'Failed to fetch soil parameters info: ${response.statusCode}');
      }
    } on ServerException catch (e) {
      AppLogger.error('ServerException in getSoilParametersInfo', e.toString());
      rethrow;
    } catch (e) {
      AppLogger.error('Network error in getSoilParametersInfo', e.toString());
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
