"""
Test script for disease detection API
IMPORTANT: Backend (run.py) must be running in separate terminal!

Usage:
  cd backend
  python test_disease_detection.py
"""
import requests
import json
from pathlib import Path
import time

BASE_URL = "http://localhost:5000"
API_ENDPOINT = f"{BASE_URL}/api/v1/disease/detect"

# ⚠️ CHANGE THIS to your actual test image path
TEST_IMAGE_PATH = "D:/DOWNLOADS/KJ SOMAIYA/SEM 7/FINAL YEAR Project/Perplexity Made/chilliguard/backend/test_images/images.jpg"  # Relative to backend folder

def print_header(title):
    """Print formatted header"""
    print("\n" + "="*60)
    print(f"  {title}")
    print("="*60)

def test_backend_health():
    """Test 1: Check if backend is running"""
    print_header("TEST 1: Backend Health Check")
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        if response.status_code == 200:
            print("✅ Backend is RUNNING")
            print(f"   Status: {response.json()}")
            return True
        else:
            print(f"❌ Backend returned error: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ BACKEND NOT RUNNING: {e}")
        print(f"   Make sure run.py is executing in another terminal")
        print(f"   Run: python run.py")
        return False

def test_model_loaded():
    """Test 2: Check if TFLite model is loaded"""
    print_header("TEST 2: Model Loading Check")
    try:
        response = requests.get(f"{BASE_URL}/disease/health", timeout=5)
        if response.status_code == 200:
            print("✅ TFLite Model is LOADED")
            print(f"   {response.json()}")
            return True
        else:
            print(f"❌ Model error: {response.json()}")
            return False
    except Exception as e:
        print(f"❌ Error checking model: {e}")
        return False

def test_disease_details():
    """Test 3: Get disease details (no image needed)"""
    print_header("TEST 3: Disease Details Endpoint")
    try:
        response = requests.get(
            f"{BASE_URL}/api/v1/disease/details/Curl Virus",
            timeout=5,
            headers={'Authorization': 'Bearer test-token'}
        )

        if response.status_code == 200:
            data = response.json()
            print(f"✅ Disease details retrieved")
            print(f"   Disease: {data.get('name')}")
            print(f"   Severity: {data.get('severity')}")
            return True
        else:
            print(f"❌ Error: {response.json()}")
            return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_image_upload():
    """Test 4: ACTUAL image upload and detection"""
    print_header("TEST 4: Real Image Upload & Detection")

    # Check if image exists
    image_path = Path(TEST_IMAGE_PATH)
    if not image_path.exists():
        print(f"⚠️  Test image not found: {TEST_IMAGE_PATH}")
        print(f"\n   TO FIX:")
        print(f"   1. Download a chilli leaf image from Google")
        print(f"   2. Save it as: {TEST_IMAGE_PATH}")
        print(f"   3. Place it in: {Path.cwd()}")
        print(f"\n   OR change TEST_IMAGE_PATH in this script")
        print(f"\n   SKIPPING this test...")
        return None

    try:
        print(f"📷 Uploading image: {image_path.absolute()}")

        with open(image_path, 'rb') as f:
            files = {'image': f}
            data = {'user_id': 'test_user_001'}

            response = requests.post(
                API_ENDPOINT,
                files=files,
                data=data,
                timeout=60,  # 60 seconds for inference
                headers={'Authorization': 'Bearer test-token'}
            )

        if response.status_code == 200:
            result = response.json()

            print(f"\n✅ DETECTION SUCCESSFUL!")
            print(f"\n   Disease Name: {result.get('disease_name')}")
            print(f"   Scientific Name: {result.get('scientific_name')}")
            print(f"   Confidence: {result.get('confidence'):.4f} ({result.get('confidence')*100:.1f}%)")
            print(f"   Severity: {result.get('severity')}")
            print(f"   Affected Area: {result.get('affected_area_percentage'):.1f}%")

            if result.get('symptoms'):
                print(f"\n   Symptoms:")
                for symptom in result.get('symptoms', [])[:3]:
                    print(f"      • {symptom}")

            if result.get('treatments'):
                print(f"\n   Top Treatment:")
                treatment = result.get('treatments', [{}])[0]
                print(f"      Type: {treatment.get('type')}")
                print(f"      Name: {treatment.get('name')}")

            return True

        elif response.status_code == 400:
            print(f"❌ Client error: {response.json()}")
            return False
        else:
            print(f"❌ Server error ({response.status_code}): {response.json()}")
            return False

    except requests.Timeout:
        print(f"❌ Request timeout (>60 seconds)")
        print(f"   Model inference is taking too long")
        return False
    except Exception as e:
        print(f"❌ Error uploading image: {e}")
        return False

if __name__ == "__main__":
    print("""
╔════════════════════════════════════════════════════════════════╗
║     CHILLIGUARD - DISEASE DETECTION API TEST SUITE             ║
║                                                                ║
║  Requirements: Backend (run.py) must be RUNNING               ║
║  Terminal 1: python run.py (KEEP RUNNING)                     ║
║  Terminal 2: python test_disease_detection.py (THIS SCRIPT)   ║
╚════════════════════════════════════════════════════════════════╝
    """)

    results = {}

    # Test 1: Health
    results['Health'] = test_backend_health()
    if not results['Health']:
        print("\n⛔ BACKEND NOT RUNNING - CANNOT CONTINUE")
        print("\n   Fix: Open new terminal and run: python run.py")
        exit(1)

    time.sleep(1)  # Small delay between tests

    # Test 2: Model
    results['Model'] = test_model_loaded()

    time.sleep(1)

    # Test 3: Disease Details
    results['Details'] = test_disease_details()

    time.sleep(1)

    # Test 4: Image Upload
    results['Upload'] = test_image_upload()

    # Summary
    print_header("TEST SUMMARY")
    print(f"✅ Health Check: {'PASS' if results['Health'] else 'FAIL'}")
    print(f"✅ Model Loaded: {'PASS' if results['Model'] else 'FAIL'}")
    print(f"✅ Disease Details: {'PASS' if results['Details'] else 'FAIL'}")

    if results['Upload'] is None:
        print(f"⏭️  Image Upload: SKIPPED (no test image)")
    else:
        print(f"✅ Image Upload: {'PASS' if results['Upload'] else 'FAIL'}")

    print("\n" + "="*60)
    if all([results['Health'], results['Model'], results['Details']]):
        print("🎉 ALL TESTS PASSED! Backend is working correctly!")
        if results['Upload'] is None:
            print("\n⚠️  To test image upload, provide a test image:")
            print(f"   Save image to: {TEST_IMAGE_PATH}")
    else:
        print("❌ Some tests failed. Check errors above.")
    print("="*60 + "\n")
