import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chilliguard.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Sensor readings table
    await db.execute('''
      CREATE TABLE sensor_readings (
        reading_id TEXT PRIMARY KEY,
        field_id TEXT NOT NULL,
        ph REAL,
        nitrogen REAL,
        phosphorus REAL,
        potassium REAL,
        moisture REAL,
        temperature REAL,
        humidity REAL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Crop batches table
    await db.execute('''
      CREATE TABLE crop_batches (
        batch_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        field_id TEXT NOT NULL,
        crop_type TEXT NOT NULL,
        planting_date TEXT NOT NULL,
        estimated_harvest_date TEXT,
        actual_harvest_date TEXT,
        area REAL NOT NULL,
        seed_variety TEXT,
        status TEXT NOT NULL,
        health_score REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Disease detections table
    await db.execute('''
      CREATE TABLE disease_detections (
        detection_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        field_id TEXT,
        batch_id TEXT,
        disease_name TEXT NOT NULL,
        confidence REAL NOT NULL,
        severity TEXT NOT NULL,
        affected_area_percent REAL NOT NULL,
        image_url TEXT,
        model_type TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Alerts table
    await db.execute('''
      CREATE TABLE alerts (
        alert_id TEXT PRIMARY KEY,
        field_id TEXT NOT NULL,
        alert_type TEXT NOT NULL,
        parameter TEXT NOT NULL,
        message TEXT NOT NULL,
        severity TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        acknowledged INTEGER NOT NULL,
        acknowledged_at TEXT
      )
    ''');

    // Create indexes
    await db
        .execute('CREATE INDEX idx_sensor_field ON sensor_readings(field_id)');
    await db.execute('CREATE INDEX idx_batch_field ON crop_batches(field_id)');
    await db.execute(
        'CREATE INDEX idx_detection_batch ON disease_detections(batch_id)');
    await db.execute('CREATE INDEX idx_alert_field ON alerts(field_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete('sensor_readings');
    await db.delete('crop_batches');
    await db.delete('disease_detections');
    await db.delete('alerts');
  }
}
