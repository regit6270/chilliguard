// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/datasources/local/alert_local_data_source.dart' as _i611;
import '../../data/datasources/local/batch_local_data_source.dart' as _i25;
import '../../data/datasources/local/disease_local_data_source.dart' as _i1059;
import '../../data/datasources/local/sensor_local_data_source.dart' as _i1020;
import '../../data/datasources/remote/alert_remote_data_source.dart' as _i727;
import '../../data/datasources/remote/batch_remote_data_source.dart' as _i373;
import '../../data/datasources/remote/disease_remote_data_source.dart' as _i213;
import '../../data/datasources/remote/recommendation_remote_data_source.dart'
    as _i509;
import '../../data/datasources/remote/sensor_remote_data_source.dart' as _i888;
import '../../data/repositories/alert_repository.dart' as _i652;
import '../../data/repositories/alert_repository_impl.dart' as _i115;
import '../../data/repositories/batch_repository.dart' as _i839;
import '../../data/repositories/batch_repository_impl.dart' as _i615;
import '../../data/repositories/disease_repository.dart' as _i958;
import '../../data/repositories/disease_repository_impl.dart' as _i290;
import '../../data/repositories/recommendation_repository.dart' as _i323;
import '../../data/repositories/recommendation_repository_impl.dart' as _i678;
import '../../data/repositories/sensor_repository.dart' as _i566;
import '../../data/repositories/sensor_repository_impl.dart' as _i119;
import '../../presentation/blocs/alert/alert_bloc.dart' as _i869;
import '../../presentation/blocs/auth/auth_bloc.dart' as _i141;
import '../../presentation/blocs/batch/batch_bloc.dart' as _i960;
import '../../presentation/blocs/connectivity/connectivity_bloc.dart' as _i905;
import '../../presentation/blocs/dashboard/dashboard_bloc.dart' as _i286;
import '../../presentation/blocs/disease_detection/disease_detection_bloc.dart'
    as _i903;
import '../../presentation/blocs/language/language_bloc.dart' as _i117;
import '../../presentation/blocs/recommendation/recommendation_bloc.dart'
    as _i205;
import '../../presentation/blocs/sensor/sensor_bloc.dart' as _i273;
import '../../presentation/blocs/soil_health/soil_health_bloc.dart' as _i284;
import '../database/database_helper.dart' as _i64;
import '../network/api_client.dart' as _i557;
import '../network/network_info.dart' as _i932;
import '../services/local_storage_service.dart' as _i527;
import '../services/notification_service.dart' as _i941;
import '../services/user_service.dart' as _i381;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i64.DatabaseHelper>(() => _i64.DatabaseHelper());
    gh.lazySingleton<_i381.UserService>(() => _i381.UserService());
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i941.NotificationService>(() => _i941.NotificationService(
          gh<_i892.FirebaseMessaging>(),
          gh<_i163.FlutterLocalNotificationsPlugin>(),
        ));
    gh.factory<_i141.AuthBloc>(() => _i141.AuthBloc(
          gh<_i59.FirebaseAuth>(),
          gh<_i381.UserService>(),
        ));
    gh.lazySingleton<_i611.AlertLocalDataSource>(
        () => _i611.AlertLocalDataSourceImpl(gh<_i64.DatabaseHelper>()));
    gh.factory<_i905.ConnectivityBloc>(
        () => _i905.ConnectivityBloc(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i1020.SensorLocalDataSource>(
        () => _i1020.SensorLocalDataSourceImpl(gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i25.BatchLocalDataSource>(
        () => _i25.BatchLocalDataSourceImpl(gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i1059.DiseaseLocalDataSource>(
        () => _i1059.DiseaseLocalDataSourceImpl(gh<_i64.DatabaseHelper>()));
    gh.lazySingleton<_i527.LocalStorageService>(
        () => _i527.LocalStorageService(gh<_i460.SharedPreferences>()));
    gh.factory<_i117.LanguageBloc>(
        () => _i117.LanguageBloc(gh<_i460.SharedPreferences>()));
    gh.singleton<_i557.ApiClient>(
        () => _i557.ApiClient(gh<_i527.LocalStorageService>()));
    gh.lazySingleton<_i213.DiseaseRemoteDataSource>(
        () => _i213.DiseaseRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i958.DiseaseRepository>(() => _i290.DiseaseRepositoryImpl(
          remoteDataSource: gh<_i213.DiseaseRemoteDataSource>(),
          localDataSource: gh<_i1059.DiseaseLocalDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i888.SensorRemoteDataSource>(
        () => _i888.SensorRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i373.BatchRemoteDataSource>(
        () => _i373.BatchRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i839.BatchRepository>(() => _i615.BatchRepositoryImpl(
          remoteDataSource: gh<_i373.BatchRemoteDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i566.SensorRepository>(() => _i119.SensorRepositoryImpl(
          remoteDataSource: gh<_i888.SensorRemoteDataSource>(),
          localDataSource: gh<_i1020.SensorLocalDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i903.DiseaseDetectionBloc>(() => _i903.DiseaseDetectionBloc(
        diseaseRepository: gh<_i958.DiseaseRepository>()));
    gh.lazySingleton<_i727.AlertRemoteDataSource>(
        () => _i727.AlertRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.factory<_i284.SoilHealthBloc>(() =>
        _i284.SoilHealthBloc(sensorRepository: gh<_i566.SensorRepository>()));
    gh.factory<_i273.SensorBloc>(
        () => _i273.SensorBloc(gh<_i566.SensorRepository>()));
    gh.lazySingleton<_i509.RecommendationRemoteDataSource>(
        () => _i509.RecommendationRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.factory<_i960.BatchBloc>(
        () => _i960.BatchBloc(batchRepository: gh<_i839.BatchRepository>()));
    gh.lazySingleton<_i323.RecommendationRepository>(
        () => _i678.RecommendationRepositoryImpl(
              remoteDataSource: gh<_i509.RecommendationRemoteDataSource>(),
              networkInfo: gh<_i932.NetworkInfo>(),
            ));
    gh.lazySingleton<_i652.AlertRepository>(() => _i115.AlertRepositoryImpl(
          remoteDataSource: gh<_i727.AlertRemoteDataSource>(),
          localDataSource: gh<_i611.AlertLocalDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i286.DashboardBloc>(() => _i286.DashboardBloc(
          sensorRepository: gh<_i566.SensorRepository>(),
          batchRepository: gh<_i839.BatchRepository>(),
          alertRepository: gh<_i652.AlertRepository>(),
        ));
    gh.factory<_i205.RecommendationBloc>(
        () => _i205.RecommendationBloc(gh<_i323.RecommendationRepository>()));
    gh.factory<_i869.AlertBloc>(
        () => _i869.AlertBloc(alertRepository: gh<_i652.AlertRepository>()));
    return this;
  }
}
