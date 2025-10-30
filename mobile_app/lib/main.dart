import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/utils/app_logger.dart';
import 'firebase_options.dart';

void main() async {
  // ✅ CRITICAL: Must be first
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Step 1: Initialize Firebase
    AppLogger.info('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('✅ Firebase initialized');

    // ✅ Step 2: Setup Crashlytics
    FlutterError.onError = (errorDetails) {
      AppLogger.error(
        'Flutter Error caught',
        errorDetails.exception,
        errorDetails.stack,
      );
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // ✅ Step 3: Initialize Hive
    AppLogger.info('💾 Initializing Hive...');
    await Hive.initFlutter();

// ✅ Open boxes (NO ADAPTERS NEEDED - using Map storage)
    await Hive.openBox('users');
    await Hive.openBox('settings');
    await Hive.openBox('app_cache');

    final userBox = Hive.box('users');
    AppLogger.info('✅ Hive initialized successfully');
    AppLogger.info('   - Users cached: ${userBox.length}');
    AppLogger.info('   - Boxes opened: users, settings, app_cache');

    // ✅ Step 4: Initialize Dependency Injection
    AppLogger.info('💉 Configuring dependencies...');
    await configureDependencies();
    AppLogger.info('✅ Dependencies configured');

    // ✅ Step 5: Set device orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // ✅ Step 6: Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // ✅ ❌ TEMPORARILY DISABLE SERVICE INIT (This is what's crashing!)
    // await _initializeServices();

    // ✅ Step 7: Launch app
    AppLogger.info('🚀 Launching ChilliGuard...');
    runApp(const ChilliGuardApp());
  } catch (e, stackTrace) {
    // ✅ CRITICAL: Show error instead of black screen
    AppLogger.error('❌ FATAL: App initialization failed', e, stackTrace);

    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red[900],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    '❌ Initialization Failed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      e.toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    stackTrace.toString().split('\n').take(5).join('\n'),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ❌ COMMENT OUT THIS FUNCTION FOR NOW
/*
Future<void> _initializeServices() async {
  try {
    final localStorageService = getIt<LocalStorageService>();
    await localStorageService.init();

    final notificationService = getIt<NotificationService>();
    await notificationService.initialize();

    AppLogger.info('Services initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize services', error: e, stackTrace: stackTrace);
  }
}
*/
