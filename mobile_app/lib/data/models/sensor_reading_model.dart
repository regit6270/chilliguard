import '../../domain/entities/sensor_reading.dart';

class SensorReadingModel {
  final String fieldId;

  final double ph;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double moisture;
  final double temperature;
  final double humidity;

  final DateTime timestamp;

  const SensorReadingModel({
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

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    // Parse humidity - handle null values from backend
    double humidityValue = 0.0;
    final humidityRaw = json['humidity'];
    if (humidityRaw != null) {
      if (humidityRaw is num) {
        humidityValue = humidityRaw.toDouble();
      } else if (humidityRaw is String) {
        humidityValue = double.tryParse(humidityRaw) ?? 0.0;
      }
    }

    return SensorReadingModel(
      fieldId: json['field_id'] as String? ?? 'unknown',
      ph: (json['ph'] as num?)?.toDouble() ?? 0.0,
      nitrogen: (json['nitrogen'] as num?)?.toDouble() ?? 0.0,
      phosphorus: (json['phosphorus'] as num?)?.toDouble() ?? 0.0,
      potassium: (json['potassium'] as num?)?.toDouble() ?? 0.0,
      moisture: (json['moisture'] as num?)?.toDouble() ?? 0.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: humidityValue,
      timestamp: _dateTimeFromJson(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'field_id': fieldId,
        'ph': ph,
        'nitrogen': nitrogen,
        'phosphorus': phosphorus,
        'potassium': potassium,
        'moisture': moisture,
        'temperature': temperature,
        'humidity': humidity,
        'timestamp': _dateTimeToJson(timestamp),
      };

  SensorReading toEntity() {
    return SensorReading(
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
      fieldId: entity.fieldId,
      ph: entity.ph,
      nitrogen: entity.nitrogen,
      phosphorus: entity.phosphorus,
      potassium: entity.potassium,
      moisture: entity.moisture,
      temperature: entity.temperature,
      humidity: entity.humidity ?? 0.0, // ⭐ DOUBLE not String
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
