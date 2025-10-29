import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Base configuration"""

    # Flask
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    DEBUG = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'

    # API
    API_VERSION = 'v1'
    ALLOWED_ORIGINS = os.getenv('ALLOWED_ORIGINS', '*').split(',')

    # Firebase
    FIREBASE_CREDENTIALS_PATH = os.getenv('FIREBASE_CREDENTIALS_PATH', 'firebase-credentials.json')
    FIREBASE_STORAGE_BUCKET = os.getenv('FIREBASE_STORAGE_BUCKET')

    # Google Cloud
    GCP_PROJECT_ID = os.getenv('GCP_PROJECT_ID')
    GCP_REGION = os.getenv('GCP_REGION', 'asia-south1')

    # Firestore
    FIRESTORE_DATABASE = os.getenv('FIRESTORE_DATABASE', '(default)')

    # Cloud Storage
    CLOUD_STORAGE_BUCKET = os.getenv('CLOUD_STORAGE_BUCKET')

    # Vertex AI
    VERTEX_AI_ENDPOINT = os.getenv('VERTEX_AI_ENDPOINT')
    VERTEX_AI_MODEL = os.getenv('VERTEX_AI_MODEL', 'chilli-disease-detection-v1')

    # MQTT / ThingsBoard
    MQTT_BROKER_HOST = os.getenv('MQTT_BROKER_HOST', 'localhost')
    MQTT_BROKER_PORT = int(os.getenv('MQTT_BROKER_PORT', '1883'))
    MQTT_USERNAME = os.getenv('MQTT_USERNAME')
    MQTT_PASSWORD = os.getenv('MQTT_PASSWORD')
    MQTT_TOPIC_PREFIX = os.getenv('MQTT_TOPIC_PREFIX', 'chilliguard/fields')

    # Redis (for Celery)
    REDIS_URL = os.getenv('REDIS_URL', 'redis://localhost:6379/0')
    CELERY_BROKER_URL = os.getenv('CELERY_BROKER_URL', REDIS_URL)
    CELERY_RESULT_BACKEND = os.getenv('CELERY_RESULT_BACKEND', REDIS_URL)

    # ML Model Settings
    TFLITE_MODEL_PATH = os.getenv('TFLITE_MODEL_PATH', 'models/disease_detection_v1.tflite')
    MODEL_CONFIDENCE_THRESHOLD = float(os.getenv('MODEL_CONFIDENCE_THRESHOLD', '0.80'))
    MAX_IMAGE_SIZE = int(os.getenv('MAX_IMAGE_SIZE', '2048'))

    # Crop Requirements (Chilli)
    CHILLI_PH_MIN = 5.5
    CHILLI_PH_MAX = 7.5
    CHILLI_N_MIN = 100.0  # kg/ha
    CHILLI_N_MAX = 150.0
    CHILLI_P_MIN = 50.0
    CHILLI_P_MAX = 75.0
    CHILLI_K_MIN = 50.0
    CHILLI_K_MAX = 100.0
    CHILLI_MOISTURE_MIN = 60.0  # % field capacity
    CHILLI_MOISTURE_MAX = 70.0
    CHILLI_TEMP_MIN = 20.0  # °C
    CHILLI_TEMP_MAX = 30.0

    # Feasibility Weights
    FEASIBILITY_WEIGHTS = {
        'ph': 0.25,
        'nitrogen': 0.15,
        'phosphorus': 0.15,
        'potassium': 0.15,
        'moisture': 0.20,
        'temperature': 0.10,
    }

    # Notification Settings
    FCM_SERVER_KEY = os.getenv('FCM_SERVER_KEY')
    MAX_CRITICAL_ALERTS_PER_DAY = int(os.getenv('MAX_CRITICAL_ALERTS_PER_DAY', '5'))

    # Sensor Settings
    SENSOR_CACHE_LIMIT = int(os.getenv('SENSOR_CACHE_LIMIT', '50'))
    SENSOR_UPDATE_INTERVAL_MINUTES = int(os.getenv('SENSOR_UPDATE_INTERVAL_MINUTES', '30'))

class DevelopmentConfig(Config):
    """Development configuration"""
    DEBUG = True

class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False

class TestingConfig(Config):
    """Testing configuration"""
    TESTING = True
    DEBUG = True

# Configuration dictionary
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}
