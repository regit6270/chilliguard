import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/di/injection.dart';
import '../core/themes/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../presentation/blocs/alert/alert_bloc.dart';
import '../presentation/blocs/auth/auth_bloc.dart';
import '../presentation/blocs/auth/auth_event.dart'; // ADD THIS
import '../presentation/blocs/batch/batch_bloc.dart';
import '../presentation/blocs/connectivity/connectivity_bloc.dart';
import '../presentation/blocs/connectivity/connectivity_event.dart'; // ADD THIS
import '../presentation/blocs/connectivity/connectivity_state.dart'; // ADD THIS
import '../presentation/blocs/dashboard/dashboard_bloc.dart';
import '../presentation/blocs/disease_detection/disease_detection_bloc.dart';
import '../presentation/blocs/language/language_bloc.dart';
import '../presentation/blocs/language/language_event.dart'; // ADD THIS
import '../presentation/blocs/language/language_state.dart'; // ADD THIS
import '../presentation/blocs/recommendation/recommendation_bloc.dart';
import '../presentation/blocs/sensor/sensor_bloc.dart';
import '../presentation/blocs/soil_health/soil_health_bloc.dart';
import 'routes/app_router.dart';

class ChilliGuardApp extends StatelessWidget {
  const ChilliGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Core BLoCs (using YOUR existing event names)
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<ConnectivityBloc>()..add(ConnectivityStartMonitoring()),
        ),
        BlocProvider(
          create: (_) => getIt<LanguageBloc>()..add(LanguageLoadRequested()),
        ),
        BlocProvider(
          create: (_) => getIt<SensorBloc>(),
        ),

        // Feature BLoCs (NEW - no initial events needed)
        BlocProvider(
          create: (_) => getIt<DashboardBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<DiseaseDetectionBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<BatchBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<SoilHealthBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<AlertBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<RecommendationBloc>(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return MaterialApp.router(
            title: 'ChilliGuard',
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,

            // Localization (Hindi-first as per PRD)
            locale: languageState is LanguageLoaded
                ? languageState.locale
                : const Locale('hi'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('hi', ''),
            ],

            // Routing
            routerConfig: AppRouter.router,

            // Global connectivity listener
            builder: (context, child) {
              return BlocListener<ConnectivityBloc, ConnectivityState>(
                listener: (context, state) {
                  if (state is ConnectivityOffline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.wifi_off, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.offlineMode,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else if (state is ConnectivityOnline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.wifi, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.backOnline,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
