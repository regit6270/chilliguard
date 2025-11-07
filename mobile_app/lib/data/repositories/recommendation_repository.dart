import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/fertilizer_schedule.dart';
import '../../domain/entities/soil_recommendation.dart';

/// Repository interface for recommendations
abstract class RecommendationRepository {
  /// Get soil improvement recommendations based on sensor data
  Future<Either<Failure, List<SoilRecommendation>>> getSoilImprovements({
    required String fieldId,
    required Map<String, dynamic> sensorData,
    String language = 'en',
  });

  /// Get fertilizer application schedule
  Future<Either<Failure, FertilizerSchedule>> getFertilizerSchedule({
    required String plantingDate,
    required double fieldArea,
    String cropType = 'chilli',
    String varietyType = 'hybrid',
  });

  /// Get soil parameter information and thresholds
  Future<Either<Failure, Map<String, dynamic>>> getSoilParametersInfo();
}
