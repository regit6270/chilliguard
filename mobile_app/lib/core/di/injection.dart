// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart' as http;
// import 'package:injectable/injectable.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../core/database/database_helper.dart';
// import '../../core/network/api_client.dart';
// import '../../core/network/network_info.dart';
// import '../../data/datasources/local/alert_local_data_source.dart';
// import '../../data/datasources/local/batch_local_data_source.dart';
// import '../../data/datasources/local/sensor_local_data_source.dart';
// import '../../data/datasources/remote/alert_remote_data_source.dart';
// import '../../data/datasources/remote/batch_remote_data_source.dart';
// import '../../data/datasources/remote/sensor_remote_data_source.dart';
// import '../../data/repositories/alert_repository_impl.dart';
// import '../../data/repositories/batch_repository.dart';
// import '../../data/repositories/batch_repository_impl.dart';
// // Import repositories that need manual registration
// import '../../data/repositories/sensor_repository_impl.dart';
// import 'injection.config.dart';

// final getIt = GetIt.instance;

// @InjectableInit(
//   initializerName: 'init',
//   preferRelativeImports: true,
//   asExtension: true,
// )
// Future<void> configureDependencies() async {
//   // ========================================
//   // STEP 1: Register External Dependencies
//   // ========================================

//   // SharedPreferences (async singleton)
//   final sharedPreferences = await SharedPreferences.getInstance();
//   getIt.registerSingleton<SharedPreferences>(sharedPreferences);

//   // Connectivity
//   getIt.registerLazySingleton<Connectivity>(() => Connectivity());

//   // HTTP Client
//   getIt.registerLazySingleton<http.Client>(() => http.Client());

//   // Firebase Auth
//   getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

//   // Firebase Messaging
//   getIt.registerLazySingleton<FirebaseMessaging>(
//     () => FirebaseMessaging.instance,
//   );

//   // ========================================
//   // STEP 2: Register Core Services
//   // ========================================

//   // API Client
//   //getIt.registerLazySingleton<ApiClient>(() => ApiClient());
//   //ApiClient is already handled by getIt.init() with proper dependencies.

//   // Database Helper
//   getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

//   // Network Info
//   getIt.registerLazySingleton<NetworkInfo>(
//     () => NetworkInfoImpl(getIt<Connectivity>()),
//   );

//   // ========================================
//   // STEP 3: Register Data Sources
//   // ========================================

//   // Sensor Data Sources
//   getIt.registerLazySingleton<SensorRemoteDataSource>(
//     () => SensorRemoteDataSourceImpl(getIt<ApiClient>()),
//   );
//   getIt.registerLazySingleton<SensorLocalDataSource>(
//     () => SensorLocalDataSourceImpl(getIt<DatabaseHelper>()),
//   );

//   // Batch Data Sources
//   getIt.registerLazySingleton<BatchRemoteDataSource>(
//     () => BatchRemoteDataSourceImpl(getIt<ApiClient>()),
//   );
//   getIt.registerLazySingleton<BatchLocalDataSource>(
//     () => BatchLocalDataSourceImpl(getIt<DatabaseHelper>()),
//   );

//   // Alert Data Sources
//   getIt.registerLazySingleton<AlertRemoteDataSource>(
//     () => AlertRemoteDataSourceImpl(getIt<ApiClient>()),
//   );
//   getIt.registerLazySingleton<AlertLocalDataSource>(
//     () => AlertLocalDataSourceImpl(getIt<DatabaseHelper>()),
//   );

//   // ========================================
//   // STEP 4: Register Repositories
//   // ========================================

//   // Sensor Repository
//   getIt.registerLazySingleton<SensorRepositoryImpl>(
//     () => SensorRepositoryImpl(
//       remoteDataSource: getIt<SensorRemoteDataSource>(),
//       localDataSource: getIt<SensorLocalDataSource>(),
//       networkInfo: getIt<NetworkInfo>(),
//     ),
//   );

//   // Batch Repository (both interface and implementation)
//   getIt.registerLazySingleton<BatchRepositoryImpl>(
//     () => BatchRepositoryImpl(
//       remoteDataSource: getIt<BatchRemoteDataSource>(),
//       //localDataSource: getIt<BatchLocalDataSource>(), //BatchRepository likely doesn't need local caching yet
//       networkInfo: getIt<NetworkInfo>(),
//     ),
//   );
//   // Register as interface for BLoCs that use the interface
//   getIt.registerLazySingleton<BatchRepository>(
//     () => getIt<BatchRepositoryImpl>(),
//   );

//   // Alert Repository
//   getIt.registerLazySingleton<AlertRepositoryImpl>(
//     () => AlertRepositoryImpl(
//       remoteDataSource: getIt<AlertRemoteDataSource>(),
//       localDataSource: getIt<AlertLocalDataSource>(),
//       networkInfo: getIt<NetworkInfo>(),
//     ),
//   );

//   // ========================================
//   // STEP 5: Initialize Injectable (Auto-registers @injectable classes)
//   // ========================================

//   getIt.init();
// }

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
  // Register ONLY external dependencies that don't have @injectable
  // ========================================

  // SharedPreferences (async - must be awaited)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Firebase Auth
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Firebase Messaging
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  // Flutter Local Notifications (for NotificationService)
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  // ========================================
  // Initialize Injectable
  // This auto-registers ALL classes with:
  // @injectable, @lazySingleton, @singleton, @factory
  // ========================================

  getIt.init();
}
