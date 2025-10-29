class AppConstants {
  static const String appName = 'ChilliGuard';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.chilliguard.com'; // Replace with actual URL
  static const String apiVersion = 'v1';
  static const int apiTimeout = 30000; // 30 seconds

  // Local Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keySelectedFieldId = 'selected_field_id';
  static const String keyLanguageCode = 'language_code';
  static const String keyIsFirstLaunch = 'is_first_launch';

  // Hive Boxes
  static const String boxSensorReadings = 'sensor_readings';
  static const String boxDiseaseDetections = 'disease_detections';
  static const String boxBatches = 'batches';
  static const String boxTreatments = 'treatments';

  // Notification Channels
  static const String channelCritical = 'critical_alerts';
  static const String channelActionable = 'actionable_alerts';
  static const String channelInformational = 'informational_alerts';

  // Sensor Parameters
  static const int sensorCacheLimit = 50;
  static const int sensorUpdateInterval = 30; // minutes

  // Disease Detection
  static const double diseaseConfidenceThreshold = 0.80;
  static const int maxImageSize = 2048; // pixels
  static const int imageQuality = 85; // compression quality

  // Chilli Crop Requirements
  static const double chilliMinPH = 5.5;
  static const double chilliMaxPH = 7.5;
  static const double chilliMinNitrogen = 100.0; // kg/ha
  static const double chilliMaxNitrogen = 150.0;
  static const double chilliMinPhosphorus = 50.0;
  static const double chilliMaxPhosphorus = 75.0;
  static const double chilliMinPotassium = 50.0;
  static const double chilliMaxPotassium = 100.0;
  static const double chilliMinMoisture = 60.0; // % field capacity
  static const double chilliMaxMoisture = 70.0;
  static const double chilliMinTemp = 20.0; // °C
  static const double chilliMaxTemp = 30.0;

  // Feasibility Thresholds
  static const double feasibilityReady = 75.0;
  static const double feasibilityAdjustments = 50.0;

  // Weights for feasibility calculation
  static const Map<String, double> feasibilityWeights = {
    'ph': 0.25,
    'nitrogen': 0.15,
    'phosphorus': 0.15,
    'potassium': 0.15,
    'moisture': 0.20,
    'temperature': 0.10,
  };
}

class ApiEndpoints {
  // Sensor APIs
  static const String sensorsLatest = '/api/v1/sensors/latest';
  static const String sensorsHistory = '/api/v1/sensors/history';
  static const String sensorsReadings = '/api/v1/sensors/readings';

  // Feasibility APIs
  static const String feasibilityCheck = '/api/v1/feasibility-check';
  static const String cropRequirements = '/api/v1/crop-requirements';
  static const String improvements = '/api/v1/improvements';

  // Disease Detection APIs
  static const String diseaseDetect = '/api/v1/disease-detect';
  static const String diseaseDetail = '/api/v1/disease';

  // Recommendations APIs
  static const String recommendTreatment = '/api/v1/recommend-treatment';

  // Batch APIs
  static const String batches = '/api/v1/batches';
  static const String batchDetail = '/api/v1/batches';
  static const String batchNotes = '/api/v1/batches';
  static const String batchTimeline = '/api/v1/batches';

  // Report APIs
  static const String generateReport = '/api/v1/reports/generate-end-cycle-report';
  static const String reportDetail = '/api/v1/reports';
  static const String batchComparison = '/api/v1/comparisons/batches';

  // Knowledge Base APIs
  static const String articles = '/api/v1/articles';
  static const String articleDetail = '/api/v1/articles';
  static const String articleSearch = '/api/v1/articles/search';

  // User APIs
  static const String userProfile = '/api/v1/users/profile';
  static const String fields = '/api/v1/fields';

  // Alerts APIs
  static const String alerts = '/api/v1/alerts';
  static const String feedback = '/api/v1/feedback';
}
