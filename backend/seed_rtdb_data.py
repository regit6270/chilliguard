"""
Seed Firebase Realtime Database with realistic sensor data for ChilliGuard.

Populates 5 days of sensor readings (3 day + 3 night readings per day)
Based on Indian soil conditions for chilli cultivation
"""
import os
import random
import sys
from datetime import datetime, timedelta
from typing import Any, Dict

import firebase_admin
from firebase_admin import credentials, db

# Add parent directory to path for imports
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# ============================================================================
# CONFIGURATION
# ============================================================================

FIREBASE_CREDENTIALS_PATH = 'firebase-credentials.json'
RTDB_URL = 'https://soilmonitoringapp-76262-default-rtdb.firebaseio.com/'
FIELD_ID = 'field_123'  # Matches frontend default field ID

# ============================================================================
# REALISTIC INDIAN SOIL DATA RANGES FOR CHILLI
# Based on ICAR/TNAU research for loamy soil in India
# ============================================================================

SENSOR_RANGES = {
    'ph': {
        'optimal': (6.5, 7.5),
        'variation': 0.3,
    },
    'nitrogen': {
        'optimal': (80, 120),  # ppm - slightly below optimal to show need for fertilizer
        'variation': 5,  # Daily variation
    },
    'phosphorus': {
        'optimal': (35, 55),  # ppm - slightly below optimal
        'variation': 3,
    },
    'potassium': {
        'optimal': (110, 140),  # ppm - slightly below optimal
        'variation': 5,
    },
    'moisture': {
        'day': (55, 65),  # % - slightly dry during day
        'night': (65, 75),  # % - higher at night
        'variation': 3,
    },
    'temperature': {
        'day': (28, 34),  # °C - Indian summer conditions
        'night': (22, 26),  # °C - cooler at night
        'variation': 2,
    },
    'humidity': {
        'day': (60, 75),  # % - moderate humidity
        'night': (75, 85),  # % - higher at night
        'variation': 3,
    },
}


def generate_realistic_reading(
        base_date: datetime,
        is_daytime: bool,
        day_offset: int) -> Dict[str, Any]:
    """
    Generate realistic sensor reading with natural variations.

    Args:
        base_date: Base datetime for the reading
        is_daytime: True for day, False for night
        day_offset: Day number (0-4) for gradual changes

    Returns:
        Dictionary with sensor data matching RTDB schema
    """
    # pH - stable around 7.0 (neutral, good for chilli)
    ph_base = (7.0 + (random.random() - 0.5) *
               SENSOR_RANGES['ph']['variation'])
    ph = round(ph_base, 1)

    # Nitrogen - gradual increase (fertilizer application simulation)
    n_base = random.uniform(*SENSOR_RANGES['nitrogen']['optimal'])
    nitrogen = round(n_base + (day_offset * 3), 0)

    # Phosphorus - stable, slightly low
    p_base = random.uniform(*SENSOR_RANGES['phosphorus']['optimal'])
    phosphorus = round(p_base + (day_offset * 1.5), 0)

    # Potassium - stable
    k_base = random.uniform(*SENSOR_RANGES['potassium']['optimal'])
    potassium = round(k_base + (day_offset * 2), 0)

    # Moisture - varies between day and night
    if is_daytime:
        moisture_base = random.uniform(*SENSOR_RANGES['moisture']['day'])
    else:
        moisture_base = random.uniform(*SENSOR_RANGES['moisture']['night'])
    moisture = round(moisture_base, 1)

    # Temperature - varies between day and night
    if is_daytime:
        temp_base = random.uniform(*SENSOR_RANGES['temperature']['day'])
    else:
        temp_base = random.uniform(*SENSOR_RANGES['temperature']['night'])
    temperature = round(temp_base, 1)

    # Humidity - varies between day and night (inverse to temperature)
    if is_daytime:
        humidity_base = random.uniform(*SENSOR_RANGES['humidity']['day'])
    else:
        humidity_base = random.uniform(*SENSOR_RANGES['humidity']['night'])
    humidity = round(humidity_base, 1)

    # Create timestamp (milliseconds)
    timestamp_ms = int(base_date.timestamp() * 1000)

    return {
        'field_id': FIELD_ID,
        'ph': ph,
        'nitrogen': nitrogen,
        'phosphorus': phosphorus,
        'potassium': potassium,
        'moisture': moisture,
        'temperature': temperature,
        'humidity': humidity,
        'timestamp': timestamp_ms,
    }


def seed_rtdb_sensor_data() -> None:
    """Seed RTDB with 5 days of sensor readings (30 total readings)."""
    print("\n" + "="*70)
    print("FIREBASE REALTIME DATABASE SEEDING SCRIPT")
    print("="*70)

    try:
        # ========================================================================
        # 1. INITIALIZE FIREBASE
        # ========================================================================
        print("\n[1/4] Initializing Firebase...")

        if not os.path.exists(FIREBASE_CREDENTIALS_PATH):
            print("ERROR: Credentials file not found at: "
                  f"{FIREBASE_CREDENTIALS_PATH}")
            print(f"   Current directory: {os.getcwd()}")
            return

        # Initialize Firebase if not already initialized
        if not firebase_admin._apps:  # pylint: disable=protected-access
            cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
            firebase_admin.initialize_app(cred, {
                'databaseURL': RTDB_URL
            })
            print(f"Firebase initialized with RTDB URL: {RTDB_URL}")
        else:
            print("Firebase already initialized")

        # ====================================================================
        # 2. GENERATE SENSOR READINGS
        # ====================================================================
        print("\n[2/4] Generating sensor readings...")

        readings = []

        # Generate data for past 5 days
        for day_offset in range(5):
            # Calculate base date (5 days ago + day_offset)
            base_date = datetime.now() - timedelta(days=(4 - day_offset))

            print(f"\n   Day {day_offset + 1}/5: "
                  f"{base_date.strftime('%Y-%m-%d')}")

            # Day readings (3 readings: 8AM, 12PM, 4PM)
            day_times = [
                base_date.replace(hour=8, minute=0, second=0),
                base_date.replace(hour=12, minute=0, second=0),
                base_date.replace(hour=16, minute=0, second=0),
            ]

            for time in day_times:
                reading = generate_realistic_reading(
                    time, is_daytime=True, day_offset=day_offset)
                readings.append(reading)
                time_str = time.strftime('%I:%M %p')
                print(f"      Day  {time_str} - pH: {reading['ph']}, "
                      f"N: {reading['nitrogen']}, "
                      f"Temp: {reading['temperature']}C")

            # Night readings (3 readings: 8PM, 12AM, 4AM)
            night_times = [
                base_date.replace(hour=20, minute=0, second=0),
                base_date.replace(hour=23, minute=59, second=0),
                (base_date + timedelta(days=1)).replace(
                    hour=4, minute=0, second=0),
            ]

            for time in night_times:
                reading = generate_realistic_reading(
                    time, is_daytime=False, day_offset=day_offset)
                readings.append(reading)
                time_str = time.strftime('%I:%M %p')
                print(f"      Night {time_str} - pH: {reading['ph']}, "
                      f"N: {reading['nitrogen']}, "
                      f"Temp: {reading['temperature']}C")

        print(f"\nGenerated {len(readings)} sensor readings")

        # ====================================================================
        # 3. UPLOAD TO FIREBASE RTDB
        # ====================================================================
        print("\n[3/4] Uploading to Firebase RTDB...")

        ref = db.reference('sensorData')

        uploaded_count = 0
        failed_count = 0

        for reading in readings:
            try:
                # Use timestamp (seconds) as key (matching your schema)
                timestamp_key = str(reading['timestamp'] // 1000)

                # Upload to RTDB: sensorData/{timestamp_seconds}/{data}
                ref.child(timestamp_key).set(reading)
                uploaded_count += 1

                if uploaded_count % 6 == 0:  # Progress every day
                    print(f"   Uploaded {uploaded_count}/"
                          f"{len(readings)} readings...")

            except Exception as e:  # pylint: disable=broad-except
                print(f"   Failed to upload reading: {e}")
                failed_count += 1

        print("\nUpload complete!")
        print(f"   - Successfully uploaded: {uploaded_count} readings")
        if failed_count > 0:
            print(f"   - Failed: {failed_count} readings")

        # ====================================================================
        # 4. VERIFY DATA
        # ====================================================================
        print("\n[4/4] Verifying data in RTDB...")

        all_data = ref.get()

        if all_data:
            total_readings = len(all_data)
            print(f"RTDB contains {total_readings} sensor readings")

            # Show sample of latest reading
            latest_key = max(all_data.keys())
            latest_reading = all_data[latest_key]

            print(f"\nLatest Reading (Key: {latest_key}):")
            print(f"   - Field ID: {latest_reading.get('field_id')}")
            print(f"   - pH: {latest_reading.get('ph')}")
            print(f"   - Nitrogen: {latest_reading.get('nitrogen')} ppm")
            print(f"   - Phosphorus: "
                  f"{latest_reading.get('phosphorus')} ppm")
            print(f"   - Potassium: {latest_reading.get('potassium')} ppm")
            print(f"   - Moisture: {latest_reading.get('moisture')}%")
            print(f"   - Temperature: "
                  f"{latest_reading.get('temperature')}C")
            print(f"   - Humidity: {latest_reading.get('humidity')}%")
            print(f"   - Timestamp: {latest_reading.get('timestamp')}")

        else:
            print("ERROR: No data found in RTDB!")

        # ====================================================================
        # SUCCESS
        # ====================================================================
        print("\n" + "="*70)
        print("SEEDING COMPLETE!")
        print("="*70)
        print(f"\nRTDB URL: {RTDB_URL}")
        print("Path: sensorData/")
        print(f"Total readings: {uploaded_count}")
        start_date = (datetime.now() - timedelta(days=4))
        end_date = datetime.now()
        print(f"Date range: {start_date.strftime('%Y-%m-%d')} to "
              f"{end_date.strftime('%Y-%m-%d')}")
        print("\nNext Steps:")
        print("   1. Start backend: python run.py")
        print(f"   2. Test API: http://localhost:5000/api/v1/sensors/"
              f"latest?field_id={FIELD_ID}")
        print("   3. Run Flutter app: flutter run")
        print("   4. Navigate to Soil Health screen to see charts!")
        print("\n")

    except FileNotFoundError as e:
        print(f"\nERROR: File not found - {e}")
        print("   Make sure you're in the backend directory")

    except Exception as e:  # pylint: disable=broad-except
        print(f"\nERROR: {type(e).__name__}: {e}")
        import traceback
        traceback.print_exc()


if __name__ == '__main__':
    print("\nStarting RTDB seeding process...")
    seed_rtdb_sensor_data()
