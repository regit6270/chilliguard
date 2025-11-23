/**
 * ChilliGuard IoT Sensor Node
 * ESP32 Soil Monitoring System for Chilli Cultivation
 * 
 * Sensors:
 * - DHT22: Temperature & Humidity
 * - Soil Moisture Sensor (Analog)
 * - Placeholders for NPK & pH sensors (to be added)
 * 
 * Uploads to: Firebase Realtime Database
 * Compatible with: ChilliGuard Mobile App
 */

#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#include "DHT.h"
#include <NTPClient.h>
#include <WiFiUdp.h>

// ============================================================================
// HARDWARE CONFIGURATION
// ============================================================================

#define DHT_PIN 4
#define DHT_TYPE DHT22
#define SOIL_MOISTURE_PIN 36
#define BUTTON_PIN 23

// ============================================================================
// FIELD CONFIGURATION - CHANGE THIS TO MATCH YOUR APP
// ============================================================================

const char* FIELD_ID = "field_123";  // ⭐ MUST MATCH your app's field_id

// ============================================================================
// SOIL MOISTURE CALIBRATION
// ============================================================================
// HOW TO CALIBRATE:
// 1. Place sensor in completely DRY soil/air → Note the raw value → Set as DRY_VALUE
// 2. Place sensor in water or fully WET soil → Note the raw value → Set as WET_VALUE
// 3. For resistive sensors: DRY_VALUE > WET_VALUE (resistance increases when dry)

#define DRY_VALUE 4095   // Raw ADC value in dry conditions
#define WET_VALUE 1500   // Raw ADC value in wet conditions

// ============================================================================
// WIFI CREDENTIALS
// ============================================================================

const char* WIFI_SSID = "Nava-2.4G";
const char* WIFI_PASSWORD = "firuzi1969";

// ============================================================================
// FIREBASE CONFIGURATION
// ============================================================================

const char* FIREBASE_API_KEY = "AIzaSyBNM2OaQaY5unRso7kH-uD0lkHJhQdlB7g";
const char* FIREBASE_DATABASE_URL = "https://soilmonitoringapp-76262-default-rtdb.firebaseio.com/";
const char* FIREBASE_USER_EMAIL = "mehrshadnava@gmail.com";
const char* FIREBASE_USER_PASSWORD = "mehrshadnava2003*";

// ============================================================================
// SENSOR READING INTERVAL
// ============================================================================

const unsigned long READ_INTERVAL = 30000; // 30 seconds (adjust as needed)

// ============================================================================
// NPK SENSOR PLACEHOLDER VALUES
// ============================================================================
// TODO: Replace these with actual NPK sensor readings when available
// Optimal ranges for chilli:
//   - pH: 6.0-7.5
//   - Nitrogen: 100-150 ppm
//   - Phosphorus: 40-60 ppm
//   - Potassium: 150-200 ppm

#define PLACEHOLDER_PH 7.0
#define PLACEHOLDER_NITROGEN 120.0
#define PLACEHOLDER_PHOSPHORUS 50.0
#define PLACEHOLDER_POTASSIUM 180.0

// ============================================================================
// GLOBAL OBJECTS
// ============================================================================

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
DHT dht(DHT_PIN, DHT_TYPE);

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 0, 60000); // UTC timezone

unsigned long lastReadTime = 0;
bool lastButtonState = HIGH;
bool currentButtonState = HIGH;
bool manualReadRequested = false;

// ============================================================================
// SETUP
// ============================================================================

void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.println("======================================");
  Serial.println("    ChilliGuard IoT Sensor Node");
  Serial.println("======================================");
  
  // Initialize sensors
  dht.begin();
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  
  // Connect to WiFi
  connectToWiFi();
  
  // Setup Firebase
  setupFirebase();
  
  // Initialize NTP time sync
  setupNTPTime();
  
  Serial.println("✅ System initialized successfully!");
  Serial.println("📡 Sending sensor data every " + String(READ_INTERVAL / 1000) + " seconds");
  Serial.println("🔘 Press button for manual reading");
  Serial.println("======================================");
}

// ============================================================================
// WIFI CONNECTION
// ============================================================================

void connectToWiFi() {
  Serial.print("🌐 Connecting to WiFi: ");
  Serial.println(WIFI_SSID);
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println();
    Serial.print("✅ Connected! IP: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println();
    Serial.println("❌ WiFi connection failed!");
  }
}

// ============================================================================
// FIREBASE SETUP
// ============================================================================

void setupFirebase() {
  Serial.println("🔥 Connecting to Firebase...");
  
  config.api_key = FIREBASE_API_KEY;
  config.database_url = FIREBASE_DATABASE_URL;
  auth.user.email = FIREBASE_USER_EMAIL;
  auth.user.password = FIREBASE_USER_PASSWORD;
  config.token_status_callback = tokenStatusCallback;
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  
  Serial.print("⏳ Authenticating");
  int timeout = 0;
  while (auth.token.uid == "" && timeout < 20) {
    Serial.print(".");
    delay(1000);
    timeout++;
  }
  
  if (auth.token.uid != "") {
    Serial.println();
    Serial.println("✅ Firebase authenticated!");
    Serial.print("👤 User UID: ");
    Serial.println(auth.token.uid.c_str());
  } else {
    Serial.println();
    Serial.println("❌ Firebase authentication failed!");
  }
}

// ============================================================================
// NTP TIME SYNC
// ============================================================================

void setupNTPTime() {
  Serial.println("⏰ Synchronizing time with NTP server...");
  
  timeClient.begin();
  
  int timeout = 0;
  while (!timeClient.update() && timeout < 10) {
    Serial.print(".");
    delay(1000);
    timeout++;
  }
  
  if (timeout >= 10) {
    Serial.println();
    Serial.println("⚠️  NTP sync failed! Using system time.");
  } else {
    Serial.println();
    Serial.println("✅ NTP synchronized!");
    Serial.print("📅 Current time (UTC): ");
    Serial.println(timeClient.getFormattedTime());
  }
}

// ============================================================================
// MAIN LOOP
// ============================================================================

void loop() {
  // Keep time updated
  timeClient.update();
  
  // Check for manual button press
  readButton();
  
  // Read and upload sensors (automatic or manual)
  if (manualReadRequested || millis() - lastReadTime >= READ_INTERVAL) {
    readAndUploadSensors();
    manualReadRequested = false;
    lastReadTime = millis();
  }
  
  // Small delay to prevent CPU hogging
  delay(100);
}

// ============================================================================
// BUTTON HANDLER
// ============================================================================

void readButton() {
  currentButtonState = digitalRead(BUTTON_PIN);
  
  // Detect button press (HIGH → LOW transition)
  if (lastButtonState == HIGH && currentButtonState == LOW) {
    manualReadRequested = true;
    Serial.println("\n🔘 Manual reading triggered by button");
  }
  
  lastButtonState = currentButtonState;
}

// ============================================================================
// READ SENSORS
// ============================================================================

void readAndUploadSensors() {
  Serial.println("\n========================================");
  Serial.println("📊 SENSOR READINGS");
  Serial.println("========================================");
  
  // Read DHT22 sensor
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  
  // Read and calibrate soil moisture
  int soilMoistureRaw = analogRead(SOIL_MOISTURE_PIN);
  int soilMoisturePercent = map(soilMoistureRaw, DRY_VALUE, WET_VALUE, 0, 100);
  soilMoisturePercent = constrain(soilMoisturePercent, 0, 100);
  
  // Check for sensor errors
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("❌ Failed to read from DHT sensor!");
    return;
  }
  
  // Display readings
  Serial.println("✅ DHT22 Sensor:");
  Serial.print("   🌡️  Temperature: "); 
  Serial.print(temperature); 
  Serial.println(" °C");
  Serial.print("   💧 Humidity: "); 
  Serial.print(humidity); 
  Serial.println(" %");
  
  Serial.println();
  Serial.println("✅ Soil Moisture Sensor:");
  Serial.print("   📊 Raw ADC: "); 
  Serial.println(soilMoistureRaw);
  Serial.print("   💦 Calibrated: "); 
  Serial.print(soilMoisturePercent); 
  Serial.println(" %");
  
  // Placeholder NPK values (TODO: Replace with actual sensors)
  Serial.println();
  Serial.println("⚠️  NPK Sensors (PLACEHOLDER VALUES):");
  Serial.print("   🧪 pH: "); 
  Serial.println(PLACEHOLDER_PH);
  Serial.print("   🌱 Nitrogen (N): "); 
  Serial.print(PLACEHOLDER_NITROGEN); 
  Serial.println(" ppm");
  Serial.print("   🌼 Phosphorus (P): "); 
  Serial.print(PLACEHOLDER_PHOSPHORUS); 
  Serial.println(" ppm");
  Serial.print("   🍃 Potassium (K): "); 
  Serial.print(PLACEHOLDER_POTASSIUM); 
  Serial.println(" ppm");
  
  Serial.println("========================================");
  
  // Upload to Firebase
  uploadToFirebase(
    temperature,
    humidity,
    soilMoisturePercent,
    PLACEHOLDER_PH,
    PLACEHOLDER_NITROGEN,
    PLACEHOLDER_PHOSPHORUS,
    PLACEHOLDER_POTASSIUM
  );
}

// ============================================================================
// UPLOAD TO FIREBASE
// ============================================================================

void uploadToFirebase(
  float temp, 
  float hum, 
  int moisture, 
  float ph, 
  float nitrogen, 
  float phosphorus, 
  float potassium
) {
  Serial.println("📤 Uploading to Firebase...");
  
  // Get current timestamp
  timeClient.update();
  unsigned long currentTimestampSec = timeClient.getEpochTime();
  unsigned long long currentTimestampMillis = (unsigned long long)currentTimestampSec * 1000;
  
  // Create Firebase path: /sensorData/<timestamp_in_seconds>
  String path = "/sensorData/" + String(currentTimestampSec);
  
  // Create JSON object matching ChilliGuard backend schema
  FirebaseJson json;
  json.set("field_id", FIELD_ID);
  json.set("ph", ph);
  json.set("nitrogen", (int)nitrogen);
  json.set("phosphorus", (int)phosphorus);
  json.set("potassium", (int)potassium);
  json.set("moisture", moisture);
  json.set("temperature", temp);
  json.set("humidity", hum);
  json.set("timestamp", (double)currentTimestampMillis);
  
  // Upload to Firebase RTDB
  Serial.print("   📍 Path: ");
  Serial.println(path);
  Serial.print("   ⏰ Timestamp: ");
  Serial.print(currentTimestampMillis);
  Serial.print(" (");
  Serial.print(timeClient.getFormattedTime());
  Serial.println(" UTC)");
  
  if (Firebase.RTDB.setJSON(&fbdo, path.c_str(), &json)) {
    Serial.println("✅ Data uploaded successfully!");
    Serial.println("   Your app will receive this data automatically!");
  } else {
    Serial.println("❌ Upload failed!");
    Serial.print("   Error: ");
    Serial.println(fbdo.errorReason());
  }
  
  Serial.println("========================================\n");
}

// ============================================================================
// HELPER: Print formatted timestamp for debugging
// ============================================================================

void printCurrentTime() {
  timeClient.update();
  Serial.println("⏰ Current Time (UTC):");
  Serial.print("   ");
  Serial.println(timeClient.getFormattedTime());
  Serial.print("   Epoch (seconds): ");
  Serial.println(timeClient.getEpochTime());
  Serial.print("   Epoch (milliseconds): ");
  Serial.println(String((unsigned long long)timeClient.getEpochTime() * 1000));
}

