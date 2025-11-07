import 'package:equatable/equatable.dart';

class SensorReading extends Equatable {
  const SensorReading({
    required this.fieldId,
    required this.ph,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.moisture,
    required this.temperature,
    this.humidity,
    required this.timestamp,
  });

  final String fieldId;
  final double ph;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double moisture;
  final double temperature;
  final double? humidity; // ⭐ DOUBLE not String
  final DateTime timestamp;

  @override
  List get props => [
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

  factory SensorReading.fromJson(Map json) {
    return SensorReading(
      fieldId: json['field_id'] as String? ?? 'unknown',
      ph: (json['ph'] as num?)?.toDouble() ?? 0.0,
      nitrogen: (json['nitrogen'] as num?)?.toDouble() ?? 0.0,
      phosphorus: (json['phosphorus'] as num?)?.toDouble() ?? 0.0,
      potassium: (json['potassium'] as num?)?.toDouble() ?? 0.0,
      moisture: (json['moisture'] as num?)?.toDouble() ?? 0.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toDouble(), // ⭐ CONVERT to double
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
