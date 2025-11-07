"""
Seed script to populate Firestore with demo data for ChilliGuard
Run this ONCE to populate Firestore with sample data
"""

import sys
from datetime import datetime, timedelta
from app.core.firebase import get_firestore_client

def seed_demo_user():
    """Create demo user"""
    db = get_firestore_client()

    user_data = {
        'user_id': 'demo_user_001',
        'name': 'Demo Farmer',
        'email': 'demo@chiliguard.com',
        'phone': '+91-9876543210',
        'location': 'Karnataka, India',
        'total_fields': 1,
        'total_revenue': 0,
        'created_at': datetime.now().isoformat(),
    }

    db.collection('users').document('demo_user_001').set(user_data)
    print("✅ Demo user created")

def seed_field():
    """Create sample field"""
    db = get_firestore_client()

    field_data = {
        'field_id': 'field_123',
        'user_id': 'demo_user_001',
        'name': 'Chilli Field - North',
        'area_acres': 2.5,
        'soil_type': 'Loamy',
        'latitude': 15.2993,
        'longitude': 75.1394,
        'created_at': datetime.now().isoformat(),
    }

    db.collection('fields').document('field_123').set(field_data)
    print("✅ Demo field created")

def seed_sensor_readings():
    """Create sample sensor readings for the last 7 days"""
    db = get_firestore_client()

    # Generate readings for past 7 days
    readings = []
    base_time = datetime.now()

    for i in range(7):
        timestamp = (base_time - timedelta(days=i)).isoformat()

        reading = {
            'field_id': 'field_123',
            'ph': 6.8 + (i % 0.3),  # pH: 6.8-7.0 (ideal: 6.5-7.5)
            'nitrogen': 120 + (i * 5),  # Nitrogen: 120-150 (mg/kg)
            'phosphorus': 45 + (i * 2),  # Phosphorus: 45-55 (mg/kg)
            'potassium': 180 + (i * 3),  # Potassium: 180-200 (mg/kg)
            'moisture': 62 - (i % 5),  # Moisture: 55-65% (ideal: 60-70%)
            'temperature': 28.5 + (i % 2),  # Temperature: 28-30°C
            'ec': 0.8 + (i * 0.05),  # Electrical Conductivity (dS/m)
            'timestamp': timestamp,
        }
        readings.append(reading)

        # Add to Firestore
        doc_id = f"reading_{i}_{int(base_time.timestamp())}"
        db.collection('sensor_readings').document(doc_id).set(reading)

    print(f"✅ {len(readings)} sensor readings created (7 days of data)")

def seed_batch():
    """Create sample crop batch"""
    db = get_firestore_client()

    batch_data = {
        'batch_id': 'batch_123',
        'field_id': 'field_123',
        'user_id': 'demo_user_001',
        'crop_type': 'Chilli',
        'variety': 'Byadgi Red',
        'planting_date': (datetime.now() - timedelta(days=45)).isoformat(),
        'expected_harvest': (datetime.now() + timedelta(days=120)).isoformat(),
        'status': 'growing',
        'area_acres': 2.5,
        'expected_yield': 25,  # tons/acre
        'created_at': datetime.now().isoformat(),
    }

    db.collection('crop_batches').document('batch_123').set(batch_data)
    print("✅ Demo batch created")

def main():
    """Run all seeding functions"""
    print("\n🌱 Starting Firestore data seeding for ChilliGuard Demo...\n")

    try:
        seed_demo_user()
        seed_field()
        seed_sensor_readings()
        seed_batch()

        print("\n✅ ALL DEMO DATA SEEDED SUCCESSFULLY!\n")
        print("You can now use these IDs in your app:")
        print("  • User ID: demo_user_001")
        print("  • Field ID: field_123")
        print("  • Batch ID: batch_123")
        print("\n")

    except Exception as e:
        print(f"\n❌ ERROR during seeding: {str(e)}\n")
        sys.exit(1)

if __name__ == '__main__':
    main()
