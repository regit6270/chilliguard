import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/soil_health/soil_health_bloc.dart';
import '../../widgets/common/bottom_navigation_bar.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/soil_health/duration_selector.dart';
import '../../widgets/soil_health/parameter_selector.dart';
import '../../widgets/soil_health/stat_card.dart';

class SoilHealthScreen extends StatefulWidget {
  const SoilHealthScreen({super.key});

  @override
  State<SoilHealthScreen> createState() => _SoilHealthScreenState();
}

class _SoilHealthScreenState extends State<SoilHealthScreen> {
  @override
  void initState() {
    super.initState();
    _loadSoilHealth();
  }

  void _loadSoilHealth() {
    print('🔍 [Screen] Triggering LoadSoilHealthData event');
    const fieldId = 'field_123'; // TODO: Get from LocalStorageService
    context.read<SoilHealthBloc>().add(
          const LoadSoilHealthData(fieldId: fieldId, duration: '7d'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Health'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Learn About Soil Health',
            onPressed: () => context.push('/knowledge-base/soil-health'),
          ),
        ],
      ),
      // ⭐ CRITICAL FIX: Added <SoilHealthBloc, SoilHealthState> types
      body: BlocBuilder<SoilHealthBloc, SoilHealthState>(
        builder: (context, state) {
          print('🔍 [Screen] BLocBuilder state: ${state.runtimeType}');

          if (state is SoilHealthLoading) {
            return const LoadingOverlay(message: 'Loading soil data...');
          }

          if (state is SoilHealthError) {
            return _buildErrorView(state.message);
          }

          if (state is SoilHealthLoaded) {
            print(
                '✅ [Screen] SoilHealthLoaded - ${state.readings.length} readings');
            return RefreshIndicator(
              onRefresh: () async {
                // ⭐ FIXED: Use correct event
                context.read<SoilHealthBloc>().add(
                      const LoadSoilHealthData(
                        fieldId: 'field_123',
                        duration: '7d',
                      ),
                    );
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Duration Selector
                    DurationSelector(
                      selectedDuration: state.selectedDuration,
                      onDurationChanged: (duration) {
                        context.read<SoilHealthBloc>().add(
                              ChangeDuration(duration),
                            );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Statistics Cards
                    if (state.latestReading != null) _buildStatsGrid(state),
                    const SizedBox(height: 24),

                    // Parameter Selector
                    Text(
                      'Parameter Trends',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ParameterSelector(
                      selectedParameter: state.selectedParameter,
                      onParameterChanged: (parameter) {
                        context.read<SoilHealthBloc>().add(
                              ChangeParameter(parameter),
                            );
                      },
                    ),
                    const SizedBox(height: 20),

                    // ⭐ FIXED: Chart now receives correct data
                    _buildChart(state),
                    const SizedBox(height: 24),

                    // Analysis Summary
                    _buildAnalysisSummary(state),
                    const SizedBox(height: 80), // Bottom nav padding
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
      bottomNavigationBar:
          const ChilliGuardBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildStatsGrid(SoilHealthLoaded state) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        StatCard(
          label: 'Current',
          value: _getCurrentValue(state),
          color: Colors.blue,
          icon: Icons.show_chart,
        ),
        StatCard(
          label: 'Average',
          value: _getAverageValue(state),
          color: Colors.green,
          icon: Icons.analytics,
        ),
        StatCard(
          label: 'Range',
          value: _getRangeValue(state),
          color: Colors.orange,
          icon: Icons.swap_vert,
        ),
      ],
    );
  }

  String _getCurrentValue(SoilHealthLoaded state) {
    final reading = state.latestReading!;
    switch (state.selectedParameter) {
      case 'ph':
        return reading.ph.toStringAsFixed(1);
      case 'nitrogen':
        return '${reading.nitrogen.toStringAsFixed(0)} ppm';
      case 'phosphorus':
        return '${reading.phosphorus.toStringAsFixed(0)} ppm';
      case 'potassium':
        return '${reading.potassium.toStringAsFixed(0)} ppm';
      case 'moisture':
        return '${reading.moisture.toStringAsFixed(0)}%';
      case 'temperature':
        return '${reading.temperature.toStringAsFixed(1)}°C';
      default:
        return 'N/A';
    }
  }

  String _getAverageValue(SoilHealthLoaded state) {
    final avg = state.averages[state.selectedParameter] ?? 0;
    switch (state.selectedParameter) {
      case 'ph':
        return avg.toStringAsFixed(1);
      case 'nitrogen':
      case 'phosphorus':
      case 'potassium':
        return '${avg.toStringAsFixed(0)} ppm';
      case 'moisture':
        return '${avg.toStringAsFixed(0)}%';
      case 'temperature':
        return '${avg.toStringAsFixed(1)}°C';
      default:
        return 'N/A';
    }
  }

  String _getRangeValue(SoilHealthLoaded state) {
    // ⭐ FIXED: Get readings instead of trends
    if (state.readings.isEmpty) return 'N/A';

    final parameter = state.selectedParameter;
    double minVal = double.infinity;
    double maxVal = double.negativeInfinity;

    for (final reading in state.readings) {
      double value;
      switch (parameter) {
        case 'ph':
          value = reading.ph;
          break;
        case 'nitrogen':
          value = reading.nitrogen;
          break;
        case 'phosphorus':
          value = reading.phosphorus;
          break;
        case 'potassium':
          value = reading.potassium;
          break;
        case 'moisture':
          value = reading.moisture;
          break;
        case 'temperature':
          value = reading.temperature;
          break;
        default:
          value = 0;
      }

      if (value < minVal) minVal = value;
      if (value > maxVal) maxVal = value;
    }

    return '${minVal.toStringAsFixed(1)}-${maxVal.toStringAsFixed(1)}';
  }

  Widget _buildChart(SoilHealthLoaded state) {
    // ⭐ FIXED: Extract chart values from readings
    final chartSpots = _getChartSpots(state);

    if (chartSpots.isEmpty) {
      return Container(
        height: 240,
        alignment: Alignment.center,
        child: const Text('No data available'),
      );
    }

    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[200]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % (chartSpots.length ~/ 5).clamp(1, 10) ==
                      0) {
                    return Text(
                      'D${value.toInt() + 1}',
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: chartSpots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ NEW HELPER: Extract chart spots from readings
  List<FlSpot> _getChartSpots(SoilHealthLoaded state) {
    final spots = <FlSpot>[];
    final parameter = state.selectedParameter;

    for (int i = 0; i < state.readings.length; i++) {
      final reading = state.readings[i];
      double value;

      switch (parameter) {
        case 'ph':
          value = reading.ph;
          break;
        case 'nitrogen':
          value = reading.nitrogen;
          break;
        case 'phosphorus':
          value = reading.phosphorus;
          break;
        case 'potassium':
          value = reading.potassium;
          break;
        case 'moisture':
          value = reading.moisture;
          break;
        case 'temperature':
          value = reading.temperature;
          break;
        default:
          value = 0;
      }

      spots.add(FlSpot(i.toDouble(), value));
    }

    return spots;
  }

  Widget _buildAnalysisSummary(SoilHealthLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Analysis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getAnalysisText(state),
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => context.push('/soil-improvement-recommendations'),
            icon: const Icon(Icons.lightbulb_outline, size: 18),
            label: const Text('View Recommendations'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getAnalysisText(SoilHealthLoaded state) {
    final parameter = state.selectedParameter;
    final avg = state.averages[parameter] ?? 0;

    switch (parameter) {
      case 'ph':
        if (avg >= 5.5 && avg <= 7.5) {
          return 'Your soil pH is in the optimal range for chilli cultivation (5.5-7.5). Maintain current practices.';
        } else if (avg < 5.5) {
          return 'Soil pH is slightly acidic. Consider applying lime to raise pH for better chilli growth.';
        } else {
          return 'Soil pH is slightly alkaline. Consider applying sulfur to lower pH for optimal nutrient availability.';
        }
      case 'nitrogen':
        if (avg >= 100 && avg <= 150) {
          return 'Nitrogen levels are optimal for chilli growth. Continue with current fertilization schedule.';
        } else if (avg < 100) {
          return 'Nitrogen is below optimal levels. Apply urea (50 kg/ha) or compost to boost nitrogen content.';
        } else {
          return 'Nitrogen is high. Reduce fertilizer application to prevent excessive vegetative growth.';
        }
      case 'moisture':
        if (avg >= 60 && avg <= 70) {
          return 'Soil moisture is optimal. Maintain current irrigation schedule.';
        } else if (avg < 60) {
          return 'Soil moisture is low. Increase irrigation frequency and consider mulching to retain moisture.';
        } else {
          return 'Soil moisture is high. Improve drainage and reduce irrigation to prevent root diseases.';
        }
      default:
        return 'Monitor this parameter regularly for optimal crop health.';
    }
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Soil Health',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadSoilHealth,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
