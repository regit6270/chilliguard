import firebase_admin
from firebase_admin import db
import os
from datetime import datetime

class RealtimeDBService:
    """Service to interact with Firebase Realtime Database for sensor data"""

    def __init__(self):
        # RTDB URL from your Firebase Console
        self.db_url = os.getenv('FIREBASE_RTDB_URL',
                                'https://soilmonitoringapp-76262-default-rtdb.firebaseio.com/')
        self.ref = db.reference('/', url=self.db_url)

    def get_latest_sensor_reading(self, field_id):
        """
        Get the latest sensor reading for a given field from RTDB
        Uses field_id directly as stored in RTDB
        """
        # Use field_id as-is (no mapping needed)
        rtdb_field_id = field_id

        try:
            # Query sensorData collection
            sensor_ref = self.ref.child('sensorData')

            # Get all readings without query (Firebase query requires index)
            all_data = sensor_ref.get()

            if not all_data:
                return None

            # Filter by field_id in Python
            matching_readings = [
                reading for reading in all_data.values()
                if reading.get('field_id') == rtdb_field_id
            ]

            if not matching_readings:
                return None

            # Get the most recent reading (highest timestamp)
            latest_reading = max(matching_readings, key=lambda x: x.get('timestamp', 0))

            # Normalize the data to match your backend schema
            normalized_data = self._normalize_sensor_data(latest_reading, field_id)

            return normalized_data

        except Exception as e:
            print(f"Error fetching from RTDB: {e}")
            return None

    def get_sensor_history(self, field_id, duration_days=7):
        """
        Get historical sensor readings from RTDB
        """
        # Use field_id as-is (no mapping needed)
        rtdb_field_id = field_id

        try:
            sensor_ref = self.ref.child('sensorData')

            # Calculate timestamp threshold (7 days ago)
            from datetime import timedelta
            threshold_timestamp = int((datetime.now() - timedelta(days=duration_days)).timestamp() * 1000)

            # Get all readings without query (Firebase query requires index)
            all_data = sensor_ref.get()

            if not all_data:
                return []

            # Filter by field_id AND timestamp in Python
            historical_data = []
            for reading in all_data.values():
                if (reading.get('field_id') == rtdb_field_id and
                    reading.get('timestamp', 0) >= threshold_timestamp):
                    normalized = self._normalize_sensor_data(reading, field_id)
                    historical_data.append(normalized)

            # Sort by timestamp descending
            historical_data.sort(key=lambda x: x['timestamp'], reverse=True)

            return historical_data

        except Exception as e:
            print(f"Error fetching history from RTDB: {e}")
            return []

    def _normalize_sensor_data(self, rtdb_data, app_field_id):
        """
        Convert RTDB sensor data format to your backend schema format
        """
        # Convert Unix milliseconds to ISO string
        timestamp_ms = rtdb_data.get('timestamp', 0)
        timestamp_dt = datetime.fromtimestamp(timestamp_ms / 1000.0)
        iso_timestamp = timestamp_dt.isoformat()

        return {
            'field_id': app_field_id,  # Use your app's field_id
            'device_id': rtdb_data.get('field_id', 'unknown'),  # RTDB's field_id becomes device_id
            'timestamp': iso_timestamp,
            'ph': float(rtdb_data.get('ph', 0)),
            'nitrogen': int(rtdb_data.get('nitrogen', 0)),
            'phosphorus': int(rtdb_data.get('phosphorus', 0)),
            'potassium': int(rtdb_data.get('potassium', 0)),
            'moisture': float(rtdb_data.get('moisture', 0)),
            'temperature': float(rtdb_data.get('temperature', 0)),
            'humidity': float(rtdb_data.get('humidity', 0)),
            'ec': 0.0,  # Not available in RTDB, use default

            # Add status indicators based on values
            'status': self._calculate_status(rtdb_data)
        }

    def _calculate_status(self, data):
        """
        Calculate good/okay/bad status for each parameter
        Based on chilli crop optimal ranges
        """
        status = {}

        # pH: optimal 5.5-7.5, acceptable 5.0-8.0
        ph = float(data.get('ph', 0))
        if 5.5 <= ph <= 7.5:
            status['ph'] = 'optimal'
        elif 5.0 <= ph <= 8.0:
            status['ph'] = 'needs_attention'
        else:
            status['ph'] = 'critical'

        # Nitrogen: optimal 100-150 ppm
        nitrogen = int(data.get('nitrogen', 0))
        if 100 <= nitrogen <= 150:
            status['nitrogen'] = 'optimal'
        elif 80 <= nitrogen <= 180:
            status['nitrogen'] = 'needs_attention'
        else:
            status['nitrogen'] = 'critical'

        # Phosphorus: optimal 40-60 ppm
        phosphorus = int(data.get('phosphorus', 0))
        if 40 <= phosphorus <= 60:
            status['phosphorus'] = 'optimal'
        elif 30 <= phosphorus <= 80:
            status['phosphorus'] = 'needs_attention'
        else:
            status['phosphorus'] = 'critical'

        # Potassium: optimal 150-200 ppm
        potassium = int(data.get('potassium', 0))
        if 150 <= potassium <= 200:
            status['potassium'] = 'optimal'
        elif 100 <= potassium <= 250:
            status['potassium'] = 'needs_attention'
        else:
            status['potassium'] = 'critical'

        # Moisture: optimal 60-80%
        moisture = float(data.get('moisture', 0))
        if 60 <= moisture <= 80:
            status['moisture'] = 'optimal'
        elif 50 <= moisture <= 90:
            status['moisture'] = 'needs_attention'
        else:
            status['moisture'] = 'critical'

        # Temperature: optimal 25-30°C
        temperature = float(data.get('temperature', 0))
        if 25 <= temperature <= 30:
            status['temperature'] = 'optimal'
        elif 20 <= temperature <= 35:
            status['temperature'] = 'needs_attention'
        else:
            status['temperature'] = 'critical'

        return status


# Lazy singleton instance
_rtdb_service = None


def get_rtdb_service():
    """Get or create the RTDB service singleton instance"""
    global _rtdb_service
    if _rtdb_service is None:
        _rtdb_service = RealtimeDBService()
    return _rtdb_service
