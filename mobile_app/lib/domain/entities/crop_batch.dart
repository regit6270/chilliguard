import 'package:equatable/equatable.dart';

class CropBatch extends Equatable {
  const CropBatch({
    required this.batchId,
    required this.userId,
    required this.fieldId,
    required this.cropType,
    required this.plantingDate,
    required this.area,
    required this.status,
    required this.healthScore,
    required this.createdAt,
    this.estimatedHarvestDate,
    this.actualHarvestDate,
    this.seedVariety,
  });
  final String batchId;
  final String userId;
  final String fieldId;
  final String cropType;
  final DateTime plantingDate;
  final DateTime? estimatedHarvestDate;
  final DateTime? actualHarvestDate;
  final double area;
  final String? seedVariety;
  final String status; // active, harvested, failed
  final double healthScore;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        batchId,
        userId,
        fieldId,
        cropType,
        plantingDate,
        estimatedHarvestDate,
        actualHarvestDate,
        area,
        seedVariety,
        status,
        healthScore,
        createdAt,
      ];

  CropBatch copyWith({
    String? batchId,
    String? userId,
    String? fieldId,
    String? cropType,
    DateTime? plantingDate,
    DateTime? estimatedHarvestDate,
    DateTime? actualHarvestDate,
    double? area,
    String? seedVariety,
    String? status,
    double? healthScore,
    DateTime? createdAt,
  }) =>
      CropBatch(
        batchId: batchId ?? this.batchId,
        userId: userId ?? this.userId,
        fieldId: fieldId ?? this.fieldId,
        cropType: cropType ?? this.cropType,
        plantingDate: plantingDate ?? this.plantingDate,
        estimatedHarvestDate: estimatedHarvestDate ?? this.estimatedHarvestDate,
        actualHarvestDate: actualHarvestDate ?? this.actualHarvestDate,
        area: area ?? this.area,
        seedVariety: seedVariety ?? this.seedVariety,
        status: status ?? this.status,
        healthScore: healthScore ?? this.healthScore,
        createdAt: createdAt ?? this.createdAt,
      );
}
