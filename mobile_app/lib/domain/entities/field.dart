import 'package:equatable/equatable.dart';

class Field extends Equatable {
  const Field({
    required this.fieldId,
    required this.userId,
    required this.fieldName,
    required this.area,
    required this.createdAt,
    this.soilType,
    this.latitude,
    this.longitude,
  });
  final String fieldId;
  final String userId;
  final String fieldName;
  final double area;
  final String? soilType;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        fieldId,
        userId,
        fieldName,
        area,
        soilType,
        latitude,
        longitude,
        createdAt,
      ];
}
