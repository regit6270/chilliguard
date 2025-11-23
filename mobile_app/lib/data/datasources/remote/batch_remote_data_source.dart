//import '../../../core/network/api_client.dart';
import 'package:chilliguard/core/network/api_client.dart' show ApiClient;
import 'package:injectable/injectable.dart';

import '../../../core/error/exceptions.dart';
import '../../models/crop_batch_model.dart';

abstract class BatchRemoteDataSource {
  Future<List<CropBatchModel>> getBatches({String? fieldId, String? status});
  Future<CropBatchModel> getBatch(String batchId);
  Future<String> createBatch(CropBatchModel batch);
  Future<void> updateBatch(String batchId, Map<String, dynamic> updates);
}

@LazySingleton(as: BatchRemoteDataSource)
class BatchRemoteDataSourceImpl implements BatchRemoteDataSource {
  final ApiClient _apiClient;

  BatchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CropBatchModel>> getBatches({
    String? fieldId,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      // field_id is required by backend, so always include it
      queryParams['field_id'] = fieldId ?? 'field_123';
      if (status != null) queryParams['status'] = status;

      final response = await _apiClient.get(
        '/api/v1/batches',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Handle both response formats
        final data = response.data;
        List<dynamic> batchesList;
        
        if (data is Map && data.containsKey('batches')) {
          batchesList = data['batches'] as List;
        } else if (data is List) {
          batchesList = data;
        } else {
          throw ServerException('Invalid response format from server');
        }
        
        if (batchesList.isEmpty) {
          return [];
        }
        
        return batchesList.map((json) => CropBatchModel.fromJson(json)).toList();
      } else {
        final errorMessage = response.data is Map && response.data.containsKey('error')
            ? response.data['error'] as String
            : 'Failed to fetch batches (Status: ${response.statusCode})';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch batches: ${e.toString()}');
    }
  }

  @override
  Future<CropBatchModel> getBatch(String batchId) async {
    try {
      // field_id is required by backend security decorator
      final response = await _apiClient.get(
        '/api/v1/batches/$batchId',
        queryParameters: {'field_id': 'field_123'}, // Default field_id
      );

      if (response.statusCode == 200) {
        return CropBatchModel.fromJson(response.data['batch']);
      } else {
        throw ServerException('Failed to fetch batch');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<String> createBatch(CropBatchModel batch) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/batches',
        data: batch.toJson(),
      );

      if (response.statusCode == 201) {
        return response.data['batch_id'] as String;
      } else {
        throw ServerException('Failed to create batch');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> updateBatch(String batchId, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.put(
        '/api/v1/batches/$batchId',
        data: updates,
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to update batch');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
