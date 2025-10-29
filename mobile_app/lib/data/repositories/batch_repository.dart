import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/crop_batch.dart';

abstract class BatchRepository {
  /// Get all batches for user
  Future<Either<Failure, List<CropBatch>>> getBatches({
    String? fieldId,
    String? status,
  });

  /// Get specific batch
  Future<Either<Failure, CropBatch>> getBatch(String batchId);

  /// Create new batch
  Future<Either<Failure, String>> createBatch(CropBatch batch);

  /// Update batch
  Future<Either<Failure, void>> updateBatch(
      String batchId, Map<String, dynamic> updates);

  /// Get active batch for field
  Future<Either<Failure, CropBatch?>> getActiveBatch(String fieldId);

  /// Cache batches locally
  Future<Either<Failure, void>> cacheBatches(List<CropBatch> batches);
}
