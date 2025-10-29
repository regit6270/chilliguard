import 'package:equatable/equatable.dart';

class SensorReading extends Equatable {
  const SensorReading({
    required this.readingId,
    required this.fieldId,
    required this.ph,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.moisture,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });
  final String readingId;
  final String fieldId;
  final double ph;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double moisture;
  final double temperature;
  final double humidity;
  final DateTime timestamp;

  @override
  List<Object?> get props => [
        readingId,
        fieldId,
        ph,
        nitrogen,
        phosphorus,
        potassium,
        moisture,
        temperature,
        humidity,
        timestamp,
      ];
}
