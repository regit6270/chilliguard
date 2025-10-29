import 'package:equatable/equatable.dart';

class Treatment extends Equatable {
  final String treatmentId;
  final String userId;
  final String batchId;
  final String? detectionId;
  final String treatmentName;
  final String treatmentType; // chemical, organic, biological
  final String? dosage;
  final String? applicationMethod;
  final DateTime? applicationDate;
  final DateTime? nextApplicationDate;
  final String? notes;
  final double? effectivenessRating; // 0-5 stars
  final double? cost;
  final DateTime createdAt;

  const Treatment({
    required this.treatmentId,
    required this.userId,
    required this.batchId,
    this.detectionId,
    required this.treatmentName,
    required this.treatmentType,
    this.dosage,
    this.applicationMethod,
    this.applicationDate,
    this.nextApplicationDate,
    this.notes,
    this.effectivenessRating,
    this.cost,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        treatmentId,
        userId,
        batchId,
        detectionId,
        treatmentName,
        treatmentType,
        dosage,
        applicationMethod,
        applicationDate,
        nextApplicationDate,
        notes,
        effectivenessRating,
        cost,
        createdAt,
      ];
}
