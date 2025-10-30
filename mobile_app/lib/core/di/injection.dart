import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // ========================================
  // STEP 1: Register External Dependencies
  // (Things that don't have @injectable annotation)
  // ========================================

  // SharedPreferences (async - must be awaited first)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Firebase Auth (single registration)
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Firebase Messaging
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  // Flutter Local Notifications
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  // ========================================
  // STEP 2: Initialize Injectable
  // This auto-registers ALL classes with:
  // @injectable, @lazySingleton, @singleton, @factory
  // ========================================
  // This includes:
  // - AuthBloc
  // - UserService
  // - All your BLoCs
  // - All your repositories
  // ========================================

  getIt.init();
}
