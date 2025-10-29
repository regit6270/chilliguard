import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../data/repositories/batch_repository.dart';
import '../../domain/entities/crop_batch.dart';
import '../datasources/remote/batch_remote_data_source.dart';
import '../models/crop_batch_model.dart';

@LazySingleton(as: BatchRepository)
class BatchRepositoryImpl implements BatchRepository {
  final BatchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BatchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CropBatch>>> getBatches({
    String? fieldId,
    String? status,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBatches = await remoteDataSource.getBatches(
          fieldId: fieldId,
          status: status,
        );
        return Right(remoteBatches.map((b) => b.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CropBatch>> getBatch(String batchId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBatch = await remoteDataSource.getBatch(batchId);
        return Right(remoteBatch.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> createBatch(CropBatch batch) async {
    if (await networkInfo.isConnected) {
      try {
        final model = CropBatchModel.fromEntity(batch);
        final batchId = await remoteDataSource.createBatch(model);
        return Right(batchId);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateBatch(
    String batchId,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateBatch(batchId, updates);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CropBatch?>> getActiveBatch(String fieldId) async {
    final result = await getBatches(fieldId: fieldId, status: 'active');

    return result.fold(
      (failure) => Left(failure),
      (batches) {
        if (batches.isEmpty) {
          return const Right(null);
        }
        return Right(batches.first);
      },
    );
  }

  @override
  Future<Either<Failure, void>> cacheBatches(List<CropBatch> batches) async {
    // Implement local caching if needed
    return const Right(null);
  }
}
