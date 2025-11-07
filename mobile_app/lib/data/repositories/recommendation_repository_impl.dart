import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/fertilizer_schedule.dart';
import '../../domain/entities/soil_recommendation.dart';
import '../datasources/remote/recommendation_remote_data_source.dart';
import 'recommendation_repository.dart';

/// Implementation of RecommendationRepository
@LazySingleton(as: RecommendationRepository)
class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RecommendationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SoilRecommendation>>> getSoilImprovements({
    required String fieldId,
    required Map<String, dynamic> sensorData,
    String language = 'en',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Note: Backend always returns both 'en' and 'hi' fields
        // The language parameter is informational only
        final recommendations = await remoteDataSource.getSoilImprovements(
          fieldId: fieldId,
          sensorData: sensorData,
          language: language,
        );

        // Convert models to entities
        final entities = recommendations.map((m) => m.toEntity()).toList();

        return Right(entities);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, FertilizerSchedule>> getFertilizerSchedule({
    required String plantingDate,
    required double fieldArea,
    String cropType = 'chilli',
    String varietyType = 'hybrid',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final scheduleModel = await remoteDataSource.getFertilizerSchedule(
          plantingDate: plantingDate,
          fieldArea: fieldArea,
          cropType: cropType,
          varietyType: varietyType,
        );

        // Convert model to entity
        final entity = scheduleModel.toEntity();

        return Right(entity);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSoilParametersInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final parametersInfo = await remoteDataSource.getSoilParametersInfo();

        return Right(parametersInfo);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
