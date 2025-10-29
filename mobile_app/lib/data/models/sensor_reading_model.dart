import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/sensor_reading.dart';

part 'sensor_reading_model.g.dart';

@JsonSerializable()
class SensorReadingModel {
  @JsonKey(name: 'reading_id')
  final String readingId;

  @JsonKey(name: 'field_id')
  final String fieldId;

  final double ph;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double moisture;
  final double temperature;
  final double humidity;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime timestamp;

  const SensorReadingModel({
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

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) =>
      _$SensorReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SensorReadingModelToJson(this);

  SensorReading toEntity() {
    return SensorReading(
      readingId: readingId,
      fieldId: fieldId,
      ph: ph,
      nitrogen: nitrogen,
      phosphorus: phosphorus,
      potassium: potassium,
      moisture: moisture,
      temperature: temperature,
      humidity: humidity,
      timestamp: timestamp,
    );
  }

  factory SensorReadingModel.fromEntity(SensorReading entity) {
    return SensorReadingModel(
      readingId: entity.readingId,
      fieldId: entity.fieldId,
      ph: entity.ph,
      nitrogen: entity.nitrogen,
      phosphorus: entity.phosphorus,
      potassium: entity.potassium,
      moisture: entity.moisture,
      temperature: entity.temperature,
      humidity: entity.humidity,
      timestamp: entity.timestamp,
    );
  }

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json is String) {
      return DateTime.parse(json);
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();
}
