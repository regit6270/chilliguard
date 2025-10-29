import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/disease_detection.dart';
import '../datasources/local/disease_local_data_source.dart';
import '../datasources/remote/disease_remote_data_source.dart';
import '../models/disease_detection_model.dart';
import 'disease_repository.dart';

@LazySingleton(as: DiseaseRepository)
class DiseaseRepositoryImpl implements DiseaseRepository {
  final DiseaseRemoteDataSource remoteDataSource;
  final DiseaseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DiseaseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DiseaseDetection>> detectDisease({
    required File imageFile,
    required String userId,
    String? fieldId,
    String? batchId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final detection = await remoteDataSource.detectDisease(
          imageFile: imageFile,
          userId: userId,
          fieldId: fieldId,
          batchId: batchId,
          useCloud: false,
        );

        // Cache detection
        await localDataSource.cacheDetection(detection);

        return Right(detection.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ModelException catch (e) {
        return Left(ModelFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, DiseaseDetection>> detectDiseaseCloud({
    required File imageFile,
    required String userId,
    String? fieldId,
    String? batchId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final detection = await remoteDataSource.detectDisease(
          imageFile: imageFile,
          userId: userId,
          fieldId: fieldId,
          batchId: batchId,
          useCloud: true,
        );

        // Cache detection
        await localDataSource.cacheDetection(detection);

        return Right(detection.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ModelException catch (e) {
        return Left(ModelFailure(e.message));
      }
    } else {
      return const Left(
          NetworkFailure('No internet connection for cloud detection'));
    }
  }

  @override
  Future<Either<Failure, List<DiseaseDetection>>> getDetectionHistory({
    String? batchId,
    int limit = 50,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final detections = await remoteDataSource.getDetectionHistory(
          batchId: batchId,
          limit: limit,
        );

        // Cache all detections
        for (final detection in detections) {
          await localDataSource.cacheDetection(detection);
        }

        return Right(detections.map((d) => d.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedDetections = await localDataSource.getCachedDetections(
          batchId: batchId,
          limit: limit,
        );
        return Right(cachedDetections.map((d) => d.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDiseaseDetails(
    String diseaseName,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final details = await remoteDataSource.getDiseaseDetails(diseaseName);
        return Right(details);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheDetection(
      DiseaseDetection detection) async {
    try {
      final model = DiseaseDetectionModel.fromEntity(detection);
      await localDataSource.cacheDetection(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
