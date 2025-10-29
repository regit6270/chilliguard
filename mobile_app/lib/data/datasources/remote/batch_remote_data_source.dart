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
      if (fieldId != null) queryParams['field_id'] = fieldId;
      if (status != null) queryParams['status'] = status;

      final response = await _apiClient.get(
        '/batches',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['batches'] as List;
        return data.map((json) => CropBatchModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch batches');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<CropBatchModel> getBatch(String batchId) async {
    try {
      final response = await _apiClient.get('/batches/$batchId');

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
        '/batches',
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
        '/batches/$batchId',
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
