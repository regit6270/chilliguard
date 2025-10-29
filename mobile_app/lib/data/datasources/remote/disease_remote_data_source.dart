import 'dart:io';

//import '../../../core/network/api_client.dart';
import 'package:chilliguard/core/network/api_client.dart' show ApiClient;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/exceptions.dart';
import '../../models/disease_detection_model.dart';

abstract class DiseaseRemoteDataSource {
  Future<DiseaseDetectionModel> detectDisease({
    required File imageFile,
    required String userId,
    String? fieldId,
    String? batchId,
    bool useCloud = false,
  });

  Future<List<DiseaseDetectionModel>> getDetectionHistory({
    String? batchId,
    int limit = 50,
  });

  Future<Map<String, dynamic>> getDiseaseDetails(String diseaseName);
}

@LazySingleton(as: DiseaseRemoteDataSource)
class DiseaseRemoteDataSourceImpl implements DiseaseRemoteDataSource {
  final ApiClient _apiClient;

  DiseaseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DiseaseDetectionModel> detectDisease({
    required File imageFile,
    required String userId,
    String? fieldId,
    String? batchId,
    bool useCloud = false,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'disease_image.jpg',
        ),
        'user_id': userId,
        if (fieldId != null) 'field_id': fieldId,
        if (batchId != null) 'batch_id': batchId,
        'use_cloud': useCloud,
      });

      final endpoint = useCloud ? '/disease/detect-cloud' : '/disease/detect';

      final response = await _apiClient.post(
        endpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        return DiseaseDetectionModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to detect disease');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<List<DiseaseDetectionModel>> getDetectionHistory({
    String? batchId,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        if (batchId != null) 'batch_id': batchId,
      };

      final response = await _apiClient.get(
        '/disease/history',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['detections'] as List;
        return data
            .map((json) => DiseaseDetectionModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to fetch detection history');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getDiseaseDetails(String diseaseName) async {
    try {
      final response = await _apiClient.get(
        '/disease/details',
        queryParameters: {'disease_name': diseaseName},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('Failed to fetch disease details');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
