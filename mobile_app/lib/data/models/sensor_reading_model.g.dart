// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_reading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorReadingModel _$SensorReadingModelFromJson(Map<String, dynamic> json) =>
    SensorReadingModel(
      readingId: json['reading_id'] as String,
      fieldId: json['field_id'] as String,
      ph: (json['ph'] as num).toDouble(),
      nitrogen: (json['nitrogen'] as num).toDouble(),
      phosphorus: (json['phosphorus'] as num).toDouble(),
      potassium: (json['potassium'] as num).toDouble(),
      moisture: (json['moisture'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      timestamp: SensorReadingModel._dateTimeFromJson(json['timestamp']),
    );

Map<String, dynamic> _$SensorReadingModelToJson(SensorReadingModel instance) =>
    <String, dynamic>{
      'reading_id': instance.readingId,
      'field_id': instance.fieldId,
      'ph': instance.ph,
      'nitrogen': instance.nitrogen,
      'phosphorus': instance.phosphorus,
      'potassium': instance.potassium,
      'moisture': instance.moisture,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'timestamp': SensorReadingModel._dateTimeToJson(instance.timestamp),
    };
