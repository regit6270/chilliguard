import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_logger.dart';
import '../../../domain/entities/sensor_reading.dart';
import '../../../domain/entities/soil_recommendation.dart';
import '../../blocs/recommendation/recommendation_bloc.dart';
import '../../blocs/recommendation/recommendation_event.dart';
import '../../blocs/recommendation/recommendation_state.dart';
import '../../blocs/sensor/sensor_bloc.dart';
import '../../blocs/sensor/sensor_event.dart';
import '../../blocs/sensor/sensor_state.dart';
import '../../widgets/common/loading_overlay.dart';

class ImprovementRecommendationsScreen extends StatefulWidget {
  const ImprovementRecommendationsScreen({super.key});

  @override
  State<ImprovementRecommendationsScreen> createState() =>
      _ImprovementRecommendationsScreenState();
}

class _ImprovementRecommendationsScreenState
    extends State<ImprovementRecommendationsScreen> {
  bool _hasLoadedRecommendations = false;

  @override
  void initState() {
    super.initState();
    // Schedule the load to happen after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }

  void _loadRecommendations() {
    const fieldId = 'field_123'; // TODO: Get from LocalStorageService

    // Get current sensor data from SensorBloc
    final sensorState = context.read<SensorBloc>().state;

    AppLogger.info(
        'Attempting to load recommendations. SensorBloc state: ${sensorState.runtimeType}');

    if (sensorState is SensorLoaded) {
      final reading = sensorState.latestReading;

      // Create sensor data map from the latest reading
      final sensorData = {
        'ph': reading.ph,
        'nitrogen': reading.nitrogen,
        'phosphorus': reading.phosphorus,
        'potassium': reading.potassium,
        'moisture': reading.moisture,
        'temperature': reading.temperature,
        'humidity': reading.humidity,
      };

      // Get current language
      final languageCode = Localizations.localeOf(context).languageCode;

      AppLogger.info(
          'Loading recommendations for field: $fieldId with language: $languageCode');

      // Load recommendations
      context.read<RecommendationBloc>().add(
            LoadSoilImprovements(
              fieldId: fieldId,
              sensorData: sensorData,
              language: languageCode,
            ),
          );

      _hasLoadedRecommendations = true;
    } else {
      // Sensor data not available - load it first
      AppLogger.warning(
          'Sensor data not available (state: ${sensorState.runtimeType}). Loading sensor data first...');
      context.read<SensorBloc>().add(const LoadLatestSensorData('field_123'));
    }
  }

  void _loadRecommendationsFromSensorData(SensorReading reading) {
    const fieldId = 'field_123';

    // Create sensor data map from the latest reading
    final sensorData = {
      'ph': reading.ph,
      'nitrogen': reading.nitrogen,
      'phosphorus': reading.phosphorus,
      'potassium': reading.potassium,
      'moisture': reading.moisture,
      'temperature': reading.temperature,
      'humidity': reading.humidity,
    };

    // Get current language
    final languageCode = Localizations.localeOf(context).languageCode;

    AppLogger.info(
        'Auto-loading recommendations from sensor listener for field: $fieldId');

    // Load recommendations
    context.read<RecommendationBloc>().add(
          LoadSoilImprovements(
            fieldId: fieldId,
            sensorData: sensorData,
            language: languageCode,
          ),
        );

    _hasLoadedRecommendations = true;
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return BlocListener<SensorBloc, SensorState>(
      listener: (context, sensorState) {
        // Auto-load recommendations when sensor data becomes available
        if (sensorState is SensorLoaded && !_hasLoadedRecommendations) {
          AppLogger.info(
              'Sensor data detected, auto-loading recommendations...');
          _loadRecommendationsFromSensorData(sensorState.latestReading);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              isHindi ? 'सुधार की सिफारिशें' : 'Improvement Recommendations'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: isHindi ? 'ताज़ा करें' : 'Refresh',
              onPressed: () {
                _hasLoadedRecommendations = false;
                _loadRecommendations();
              },
            ),
          ],
        ),
        body: BlocBuilder<RecommendationBloc, RecommendationState>(
          builder: (context, state) {
            if (state is SoilImprovementsLoading) {
              return LoadingOverlay(
                message: isHindi
                    ? 'सिफारिशें लोड हो रही हैं...'
                    : 'Loading recommendations...',
              );
            }

            if (state is RecommendationError) {
              return _buildErrorView(state.message, isHindi);
            }

            if (state is RecommendationEmpty) {
              return _buildEmptyView(state.message, isHindi);
            }

            if (state is SoilImprovementsLoaded) {
              return _buildRecommendationsView(state, isHindi);
            }

            return _buildInitialView(isHindi);
          },
        ),
      ),
    );
  }

  Widget _buildInitialView(bool isHindi) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.science_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            isHindi
                ? 'मिट्टी की सिफारिशें देखने के लिए लोड करें'
                : 'Load recommendations to view soil improvements',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadRecommendations,
            icon: const Icon(Icons.lightbulb_outline),
            label:
                Text(isHindi ? 'सिफारिशें लोड करें' : 'Load Recommendations'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message, bool isHindi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadRecommendations,
              icon: const Icon(Icons.refresh),
              label: Text(isHindi ? 'पुनः प्रयास करें' : 'Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(String message, bool isHindi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green[400],
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isHindi
                  ? 'सभी मिट्टी के मापदंड इष्टतम सीमा में हैं'
                  : 'All soil parameters are within optimal range',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(isHindi ? 'वापस जाएं' : 'Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsView(SoilImprovementsLoaded state, bool isHindi) {
    final recommendations = state.recommendations;

    return RefreshIndicator(
      onRefresh: () async {
        _loadRecommendations();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          _buildSummaryCard(state, isHindi),
          const SizedBox(height: 16),

          // High Priority Recommendations
          if (state.highPriority.isNotEmpty) ...[
            _buildPrioritySectionHeader(
              isHindi ? 'उच्च प्राथमिकता' : 'High Priority',
              Colors.red,
              state.highPriority.length,
              isHindi,
            ),
            ...state.highPriority
                .map((rec) => _buildRecommendationCard(rec, isHindi)),
            const SizedBox(height: 16),
          ],

          // Medium Priority Recommendations
          if (state.mediumPriority.isNotEmpty) ...[
            _buildPrioritySectionHeader(
              isHindi ? 'मध्यम प्राथमिकता' : 'Medium Priority',
              Colors.orange,
              state.mediumPriority.length,
              isHindi,
            ),
            ...state.mediumPriority
                .map((rec) => _buildRecommendationCard(rec, isHindi)),
            const SizedBox(height: 16),
          ],

          // Low Priority Recommendations
          if (state.lowPriority.isNotEmpty) ...[
            _buildPrioritySectionHeader(
              isHindi ? 'कम प्राथमिकता' : 'Low Priority',
              Colors.blue,
              state.lowPriority.length,
              isHindi,
            ),
            ...state.lowPriority
                .map((rec) => _buildRecommendationCard(rec, isHindi)),
          ],

          // Fertilizer Schedule Button
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to Fertilizer Schedule Input Screen
                context.push('/fertilizer-schedule-input');
              },
              icon: const Icon(Icons.spa_outlined, size: 24),
              label: Text(
                isHindi ? 'उर्वरक कार्यक्रम देखें' : 'View Fertilizer Schedule',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(SoilImprovementsLoaded state, bool isHindi) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  isHindi ? 'सारांश' : 'Summary',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  isHindi ? 'कुल' : 'Total',
                  state.count.toString(),
                  Colors.blue,
                ),
                _buildSummaryItem(
                  isHindi ? 'उच्च' : 'High',
                  state.highPriority.length.toString(),
                  Colors.red,
                ),
                _buildSummaryItem(
                  isHindi ? 'मध्यम' : 'Medium',
                  state.mediumPriority.length.toString(),
                  Colors.orange,
                ),
                _buildSummaryItem(
                  isHindi ? 'कम' : 'Low',
                  state.lowPriority.length.toString(),
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySectionHeader(
      String title, Color color, int count, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(SoilRecommendation rec, bool isHindi) {
    final priorityColor = rec.isHighPriority
        ? Colors.red
        : rec.isMediumPriority
            ? Colors.orange
            : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        leading: Icon(
          rec.isCritical ? Icons.warning : Icons.lightbulb_outline,
          color: priorityColor,
          size: 32,
        ),
        title: Text(
          isHindi ? rec.issueHi : rec.issue,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${isHindi ? "वर्तमान" : "Current"}: ${rec.getCurrentValueFormatted()} | ${isHindi ? "लक्ष्य" : "Target"}: ${rec.targetRange}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isHindi ? rec.actionUrgencyHi : rec.actionUrgency,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: priorityColor,
                ),
              ),
            ),
          ],
        ),
        children: [
          // Description
          _buildDetailSection(
            isHindi ? 'विवरण' : 'Description',
            isHindi ? rec.descriptionHi : rec.description,
            Icons.info_outline,
          ),

          const Divider(height: 24),

          // Solution
          _buildDetailSection(
            isHindi ? 'समाधान' : 'Solution',
            isHindi ? rec.solutionHi : rec.solution,
            Icons.build_outlined,
          ),

          const Divider(height: 24),

          // Dosage
          _buildDetailSection(
            isHindi ? 'खुराक' : 'Dosage',
            rec.dosage,
            Icons.medication_outlined,
          ),

          const Divider(height: 24),

          // Timeline
          _buildDetailSection(
            isHindi ? 'समयरेखा' : 'Timeline',
            rec.timeline,
            Icons.schedule,
          ),

          const Divider(height: 24),

          // Application Method
          _buildDetailSection(
            isHindi ? 'प्रयोग विधि' : 'Application Method',
            rec.applicationMethod,
            Icons.agriculture_outlined,
          ),

          const Divider(height: 24),

          // Organic Alternative
          _buildDetailSection(
            isHindi ? 'जैविक विकल्प' : 'Organic Alternative',
            rec.organicAlternative,
            Icons.eco_outlined,
          ),

          const Divider(height: 24),

          // Estimated Cost
          _buildDetailSection(
            isHindi ? 'अनुमानित लागत' : 'Estimated Cost',
            rec.estimatedCost,
            Icons.currency_rupee,
          ),

          // Indicators (if present)
          if (rec.indicators.isNotEmpty) ...[
            const Divider(height: 24),
            _buildIndicatorsSection(rec.indicators, isHindi),
          ],

          // Critical Warning (if present)
          if (rec.isCritical && rec.criticalWarning != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.red[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rec.criticalWarning!,
                      style: TextStyle(
                        color: Colors.red[900],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorsSection(List<String> indicators, bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.remove_red_eye_outlined,
                size: 20, color: Colors.blue[700]),
            const SizedBox(width: 12),
            Text(
              isHindi ? 'लक्षण' : 'Indicators',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...indicators.map((indicator) => Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: Colors.blue[700])),
                  Expanded(
                    child: Text(
                      indicator,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
