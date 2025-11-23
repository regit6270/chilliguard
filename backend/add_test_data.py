"""
Add custom sensor data to Firebase RTDB for testing.

Usage:
    python add_test_data.py
"""
import os
import sys
from datetime import datetime

import firebase_admin
from firebase_admin import credentials, db

# Add parent directory to path for imports
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# ============================================================================
# CONFIGURATION
# ============================================================================

FIREBASE_CREDENTIALS_PATH = 'firebase-credentials.json'
RTDB_URL = 'https://soilmonitoringapp-76262-default-rtdb.firebaseio.com/'
FIELD_ID = 'field_123'

# ============================================================================
# PRESET TEST SCENARIOS
# ============================================================================

SCENARIOS = {
    '1': {
        'name': 'Optimal Conditions',
        'ph': 7.0,
        'nitrogen': 125,
        'phosphorus': 50,
        'potassium': 175,
        'moisture': 65,
        'temperature': 28,
        'humidity': 70
    },
    '2': {
        'name': 'Low Nitrogen (Needs Fertilizer)',
        'ph': 6.8,
        'nitrogen': 60,  # Low!
        'phosphorus': 45,
        'potassium': 180,
        'moisture': 62,
        'temperature': 28.5,
        'humidity': 68
    },
    '3': {
        'name': 'High pH (Alkaline Soil)',
        'ph': 8.2,  # Too high!
        'nitrogen': 120,
        'phosphorus': 45,
        'potassium': 180,
        'moisture': 62,
        'temperature': 28.5,
        'humidity': 68
    },
    '4': {
        'name': 'Low Moisture (Dry Soil)',
        'ph': 6.8,
        'nitrogen': 120,
        'phosphorus': 45,
        'potassium': 180,
        'moisture': 35,  # Too dry!
        'temperature': 32,  # Hot
        'humidity': 55
    },
    '5': {
        'name': 'Low Phosphorus',
        'ph': 7.0,
        'nitrogen': 120,
        'phosphorus': 20,  # Low!
        'potassium': 180,
        'moisture': 62,
        'temperature': 28.5,
        'humidity': 68
    },
    '6': {
        'name': 'High Temperature Stress',
        'ph': 6.8,
        'nitrogen': 120,
        'phosphorus': 45,
        'potassium': 180,
        'moisture': 50,
        'temperature': 38,  # Too hot!
        'humidity': 45
    },
    '7': {
        'name': 'Multiple Issues (Critical)',
        'ph': 5.2,  # Too acidic
        'nitrogen': 45,  # Too low
        'phosphorus': 15,  # Too low
        'potassium': 80,  # Too low
        'moisture': 30,  # Too dry
        'temperature': 35,  # Too hot
        'humidity': 40
    },
    '8': {
        'name': 'Perfect Chilli Growing Conditions',
        'ph': 6.5,
        'nitrogen': 135,
        'phosphorus': 55,
        'potassium': 185,
        'moisture': 68,
        'temperature': 27,
        'humidity': 72
    }
}


def initialize_firebase():
    """Initialize Firebase if not already initialized"""
    if not os.path.exists(FIREBASE_CREDENTIALS_PATH):
        print(f"ERROR: Credentials file not found at: {FIREBASE_CREDENTIALS_PATH}")
        print(f"   Current directory: {os.getcwd()}")
        return False

    # Initialize Firebase if not already initialized
    if not firebase_admin._apps:  # pylint: disable=protected-access
        cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
        firebase_admin.initialize_app(cred, {
            'databaseURL': RTDB_URL
        })
        print(f"✅ Firebase initialized with RTDB URL: {RTDB_URL}\n")
    else:
        print("✅ Firebase already initialized\n")
    
    return True


def add_sensor_reading(ph, nitrogen, phosphorus, potassium, moisture, temperature, humidity):
    """Add a sensor reading to Firebase RTDB"""
    
    # Get current time and ensure it's AFTER any existing data
    ref = db.reference('sensorData')
    existing_data = ref.get()
    
    # Find the latest existing timestamp
    latest_timestamp_ms = 0
    if existing_data:
        for data in existing_data.values():
            ts = data.get('timestamp', 0)
            if ts > latest_timestamp_ms:
                latest_timestamp_ms = ts
    
    # Add 1 second to ensure new data is newest
    current_timestamp_ms = int(datetime.now().timestamp() * 1000)
    timestamp_ms = max(current_timestamp_ms, latest_timestamp_ms + 1000)
    timestamp_key = str(timestamp_ms // 1000)
    
    print(f"\n⏰ Latest existing timestamp: {datetime.fromtimestamp(latest_timestamp_ms/1000).strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"⏰ New reading timestamp: {datetime.fromtimestamp(timestamp_ms/1000).strftime('%Y-%m-%d %H:%M:%S')}")
    
    reading = {
        'field_id': FIELD_ID,
        'ph': float(ph),
        'nitrogen': int(nitrogen),
        'phosphorus': int(phosphorus),
        'potassium': int(potassium),
        'moisture': float(moisture),
        'temperature': float(temperature),
        'humidity': float(humidity),
        'timestamp': timestamp_ms,
    }
    
    try:
        ref.child(timestamp_key).set(reading)
        
        print("✅ Successfully added reading:")
        print(f"   - pH: {ph}")
        print(f"   - Nitrogen: {nitrogen} ppm")
        print(f"   - Phosphorus: {phosphorus} ppm")
        print(f"   - Potassium: {potassium} ppm")
        print(f"   - Moisture: {moisture}%")
        print(f"   - Temperature: {temperature}°C")
        print(f"   - Humidity: {humidity}%")
        print(f"   - Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
        return True
        
    except Exception as e:  # pylint: disable=broad-except
        print(f"❌ Error adding reading: {e}")
        return False


def show_scenarios():
    """Display available test scenarios"""
    print("\n" + "="*70)
    print("AVAILABLE TEST SCENARIOS")
    print("="*70)
    
    for key, scenario in SCENARIOS.items():
        print(f"\n[{key}] {scenario['name']}")
        print(f"    pH: {scenario['ph']}, N: {scenario['nitrogen']}, "
              f"P: {scenario['phosphorus']}, K: {scenario['potassium']}")
        print(f"    Moisture: {scenario['moisture']}%, Temp: {scenario['temperature']}°C, "
              f"Humidity: {scenario['humidity']}%")


def main():
    """Main function"""
    print("\n" + "="*70)
    print("ADD CUSTOM SENSOR DATA TO FIREBASE RTDB")
    print("="*70)
    
    if not initialize_firebase():
        return
    
    while True:
        show_scenarios()
        
        print("\n" + "="*70)
        print("OPTIONS:")
        print("  - Enter scenario number (1-8) to add preset data")
        print("  - Enter 'c' for custom values")
        print("  - Enter 'q' to quit")
        print("="*70)
        
        choice = input("\nYour choice: ").strip().lower()
        
        if choice == 'q':
            print("\n👋 Goodbye!")
            break
        
        elif choice == 'c':
            print("\n" + "="*70)
            print("ENTER CUSTOM VALUES")
            print("="*70)
            print("Optimal ranges for chilli:")
            print("  pH: 6.0-7.5  |  N: 100-150 ppm  |  P: 40-60 ppm")
            print("  K: 150-200 ppm  |  Moisture: 60-80%  |  Temp: 25-30°C")
            print("  Humidity: 60-80%")
            print("-"*70)
            
            try:
                ph = float(input("pH (0-14): "))
                nitrogen = int(input("Nitrogen (ppm): "))
                phosphorus = int(input("Phosphorus (ppm): "))
                potassium = int(input("Potassium (ppm): "))
                moisture = float(input("Moisture (%): "))
                temperature = float(input("Temperature (°C): "))
                humidity = float(input("Humidity (%): "))
                
                print("\n📊 Adding custom reading...")
                add_sensor_reading(ph, nitrogen, phosphorus, potassium, 
                                 moisture, temperature, humidity)
                
            except ValueError:
                print("❌ Invalid input! Please enter numeric values.")
                continue
        
        elif choice in SCENARIOS:
            scenario = SCENARIOS[choice]
            print(f"\n📊 Adding scenario: {scenario['name']}")
            
            add_sensor_reading(
                scenario['ph'],
                scenario['nitrogen'],
                scenario['phosphorus'],
                scenario['potassium'],
                scenario['moisture'],
                scenario['temperature'],
                scenario['humidity']
            )
        
        else:
            print("❌ Invalid choice! Please try again.")
            continue
        
        print("\n" + "="*70)
        print("✅ Data added! Pull to refresh in your mobile app to see changes.")
        print("="*70)
        
        another = input("\nAdd another reading? (y/n): ").strip().lower()
        if another != 'y':
            print("\n👋 Done! Your data is now in Firebase RTDB.")
            break


if __name__ == '__main__':
    main()

