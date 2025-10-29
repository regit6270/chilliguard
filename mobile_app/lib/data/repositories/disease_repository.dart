import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/disease_detection.dart';

abstract class DiseaseRepository {
  /// Detect disease using on-device model
  Future<Either<Failure, DiseaseDetection>> detectDisease({
    required File imageFile,
    required String userId,
    String? fieldId,
    String? batchId,
  });

  /// Detect disease using cloud model (higher accuracy)
  Future<Either<Failure, DiseaseDetection>> detectDiseaseCloud({
    required File imageFile,
    required String userId,
    String? fieldId,
    String? batchId,
  });

  /// Get detection history
  Future<Either<Failure, List<DiseaseDetection>>> getDetectionHistory({
    String? batchId,
    int limit = 50,
  });

  /// Get disease details
  Future<Either<Failure, Map<String, dynamic>>> getDiseaseDetails(
      String diseaseName);

  /// Cache detection locally
  Future<Either<Failure, void>> cacheDetection(DiseaseDetection detection);
}
