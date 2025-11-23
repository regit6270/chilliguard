import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/onboarding_screen.dart';
import '../../presentation/screens/auth/phone_verification_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/camera/camera_screen.dart';
//
import '../../presentation/screens/crop_management/batch_detail_screen.dart';
import '../../presentation/screens/crop_management/batch_list_screen.dart';
import '../../presentation/screens/crop_management/create_batch_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/dashboard/feasibility_check_screen.dart';
import '../../presentation/screens/disease/simple_disease_screen.dart';
import '../../presentation/screens/knowledge_base/article_detail_screen.dart';
import '../../presentation/screens/knowledge_base/knowledge_base_screen.dart';
import '../../presentation/screens/knowledge_base/disease_encyclopedia_screen.dart';
import '../../presentation/widgets/knowledge_base/disease_detail_screen.dart';
import '../../presentation/screens/knowledge_base/faq_screen.dart';
import '../../presentation/screens/profile/add_field_screen.dart';
import '../../presentation/screens/profile/field_management_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';
import '../../presentation/screens/reports/batch_comparison_screen.dart';
import '../../presentation/screens/reports/end_cycle_report_screen.dart';
import '../../presentation/screens/reports/reports_list_screen.dart';
import '../../presentation/screens/soil_health/fertilizer_schedule_input_screen.dart';
import '../../presentation/screens/soil_health/fertilizer_schedule_result_screen.dart';
import '../../presentation/screens/soil_health/improvement_recommendations_screen.dart';
import '../../presentation/screens/soil_health/soil_health_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/phone-verification',
        name: 'phone-verification',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return PhoneVerificationScreen(
            verificationId: extra?['verificationId'] ?? '',
            phoneNumber: extra?['phoneNumber'] ?? '',
          );
        },
      ),

      // Main App Routes with Bottom Navigation
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Dashboard Routes
      GoRoute(
        path: '/feasibility-check',
        name: 'feasibility-check',
        builder: (context, state) => const FeasibilityCheckScreen(),
      ),

      // Camera & Disease Detection Routes
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/disease-detection',
        name: 'disease-detection',
        builder: (context, state) => const SimpleDiseaseDetectionScreen(),
      ),

      // Soil Health Routes
      GoRoute(
        path: '/soil-health',
        name: 'soil-health',
        builder: (context, state) => const SoilHealthScreen(),
      ),
      GoRoute(
        path: '/soil-improvement-recommendations',
        name: 'soil-improvement-recommendations',
        builder: (context, state) => const ImprovementRecommendationsScreen(),
      ),
      GoRoute(
        path: '/fertilizer-schedule-input',
        name: 'fertilizer-schedule-input',
        builder: (context, state) => const FertilizerScheduleInputScreen(),
      ),
      GoRoute(
        path: '/fertilizer-schedule-result',
        name: 'fertilizer-schedule-result',
        builder: (context, state) => const FertilizerScheduleResultScreen(),
      ),

      // Crop Management Routes
      GoRoute(
        path: '/crop-batches',
        name: 'crop-batches',
        builder: (context, state) => const BatchListScreen(),
      ),
      GoRoute(
        path: '/crop-management',
        name: 'crop-management',
        builder: (context, state) => const BatchListScreen(),
      ),
      GoRoute(
        path: '/batch/:id',
        name: 'batch-detail',
        builder: (context, state) {
          final batchId = state.pathParameters['id']!;
          return BatchDetailScreen(batchId: batchId);
        },
      ),
      GoRoute(
        path: '/crop-management/batch/:id',
        name: 'crop-management-batch-detail',
        builder: (context, state) {
          final batchId = state.pathParameters['id']!;
          return BatchDetailScreen(batchId: batchId);
        },
      ),
      GoRoute(
        path: '/create-batch',
        name: 'create-batch',
        builder: (context, state) => const CreateBatchScreen(),
      ),
      GoRoute(
        path: '/crop-management/new',
        name: 'crop-management-new',
        builder: (context, state) => const CreateBatchScreen(),
      ),

      // Reports Routes
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsListScreen(),
      ),
      GoRoute(
        path: '/reports/end-cycle/:reportId',
        name: 'end-cycle-report',
        builder: (context, state) {
          final reportId = state.pathParameters['reportId']!;
          return EndCycleReportScreen(reportId: reportId);
        },
      ),
      GoRoute(
        path: '/reports/comparison/:reportId',
        name: 'batch-comparison',
        builder: (context, state) {
          final reportId = state.pathParameters['reportId']!;
          return BatchComparisonScreen(reportId: reportId);
        },
      ),

      // Knowledge Base Routes
      GoRoute(
        path: '/knowledge-base',
        name: 'knowledge-base',
        builder: (context, state) => const KnowledgeBaseScreen(),
      ),

      // Article detail - keep the short form and also add canonical KB path as alias
      GoRoute(
        path: '/article/:id',
        name: 'article-detail',
        builder: (context, state) {
          final articleId = state.pathParameters['id']!;
          return ArticleDetailScreen(articleId: articleId);
        },
      ),
      GoRoute(
        path: '/knowledge-base/article/:id',
        name: 'article-detail-kb',
        builder: (context, state) {
          final articleId = state.pathParameters['id']!;
          return ArticleDetailScreen(articleId: articleId);
        },
      ),

      // KB: disease encyclopedia & disease detail
      GoRoute(
        path: '/knowledge-base/disease-encyclopedia',
        name: 'disease-encyclopedia',
        builder: (context, state) => const DiseaseEncyclopediaScreen(),
      ),
      GoRoute(
        path: '/knowledge-base/disease/:id',
        name: 'disease-detail',
        builder: (context, state) {
          final diseaseId = state.pathParameters['id']!;
          return DiseaseDetailScreen(diseaseId: diseaseId);
        },
      ),

      // FAQ route
      GoRoute(
        path: '/knowledge-base/faq',
        name: 'faq',
        builder: (context, state) => const FaqScreen(),
      ),

      // Profile Routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile/field-management',
        name: 'field-management',
        builder: (context, state) => const FieldManagementScreen(),
      ),
      GoRoute(
        path: '/profile/add-field',
        name: 'add-field',
        builder: (context, state) => const AddFieldScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Error: ${state.error}'),
          ],
        ),
      ),
    ),
  );
}
