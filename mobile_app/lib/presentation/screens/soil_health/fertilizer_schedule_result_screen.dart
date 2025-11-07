import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/fertilizer_schedule.dart';
import '../../blocs/recommendation/recommendation_bloc.dart';
import '../../blocs/recommendation/recommendation_state.dart';
import '../../widgets/common/bottom_navigation_bar.dart';
import '../../widgets/common/loading_overlay.dart';

class FertilizerScheduleResultScreen extends StatelessWidget {
  const FertilizerScheduleResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'उर्वरक कार्यक्रम' : 'Fertilizer Schedule'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: isHindi ? 'साझा करें' : 'Share',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isHindi ? 'साझा करें' : 'Share feature'),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<RecommendationBloc, RecommendationState>(
        builder: (context, state) {
          if (state is FertilizerScheduleLoading) {
            return LoadingOverlay(
              message:
                  isHindi ? 'कार्यक्रम बन रहा है...' : 'Generating schedule...',
            );
          }

          if (state is RecommendationError) {
            return _buildErrorView(state.message, isHindi, context);
          }

          if (state is FertilizerScheduleLoaded) {
            return _buildScheduleView(state, isHindi);
          }

          return _buildInitialView(isHindi);
        },
      ),
      bottomNavigationBar:
          const ChilliGuardBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildInitialView(bool isHindi) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            isHindi ? 'कोई कार्यक्रम नहीं मिला' : 'No schedule available',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message, bool isHindi, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(isHindi ? 'वापस जाएं' : 'Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleView(FertilizerScheduleLoaded state, bool isHindi) {
    final schedule = state.schedule;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      color: Colors.green[600],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          _buildSummaryCard(schedule.summary, isHindi),
          const SizedBox(height: 16),

          // Total Cost & Yield Card
          _buildCostYieldCard(schedule.summary, isHindi),
          const SizedBox(height: 24),

          // Section Header
          _buildSectionHeader(isHindi),
          const SizedBox(height: 12),

          // Stage Cards
          ...schedule.schedule.asMap().entries.map((entry) {
            final index = entry.key;
            final stage = entry.value;
            return _buildStageCard(stage, index, isHindi);
          }),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(FertilizerScheduleSummary summary, bool isHindi) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green[700], size: 24),
                const SizedBox(width: 8),
                Text(
                  isHindi ? 'खेत की जानकारी' : 'Field Information',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              isHindi ? 'क्षेत्रफल' : 'Area',
              '${summary.fieldAreaHectares} ${isHindi ? "हेक्टेयर" : "ha"}',
              Icons.landscape,
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              isHindi ? 'किस्म' : 'Variety',
              summary.varietyType == 'hybrid'
                  ? (isHindi ? 'हाइब्रिड' : 'Hybrid')
                  : (isHindi ? 'स्थानीय' : 'Local'),
              Icons.category,
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              isHindi ? 'कुल NPK' : 'Total NPK',
              'N: ${summary.totalNutrientsCalculated['total_N_kg'] ?? 0} | P: ${summary.totalNutrientsCalculated['total_P2O5_kg'] ?? 0} | K: ${summary.totalNutrientsCalculated['total_K2O_kg'] ?? 0} kg',
              Icons.science,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCostYieldCard(FertilizerScheduleSummary summary, bool isHindi) {
    final variety = summary.varietyType;
    return Card(
      elevation: 2,
      color: Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.currency_rupee,
                      color: Colors.green[700], size: 32),
                  const SizedBox(height: 8),
                  Text(
                    isHindi ? 'अनुमानित लागत' : 'Estimated Cost',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    summary.estimatedTotalCost[variety] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: Colors.green[300],
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.agriculture, color: Colors.green[700], size: 32),
                  const SizedBox(height: 8),
                  Text(
                    isHindi ? 'अपेक्षित उपज' : 'Expected Yield',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    summary.expectedYield[variety] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isHindi) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isHindi ? 'उर्वरक लगाने का चरणवार कार्यक्रम' : 'Fertilization Stages',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }

  Widget _buildStageCard(FertilizerStage stage, int index, bool isHindi) {
    final stageColor = _getStageColor(index);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: stageColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: stageColor, width: 2),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: stageColor,
              ),
            ),
          ),
        ),
        title: Text(
          isHindi ? stage.stageHi : stage.stage,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(
                    DateTime.tryParse(stage.applicationDate) ?? DateTime.now(),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Day ${stage.day}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        children: [
          // Application Method
          _buildDetailRow(
            isHindi ? 'प्रयोग विधि' : 'Application Method',
            isHindi ? stage.applicationMethodHi : stage.applicationMethod,
            Icons.agriculture,
          ),
          const Divider(height: 24),

          // Notes
          _buildDetailRow(
            isHindi ? 'नोट्स' : 'Notes',
            stage.notes,
            Icons.note_alt_outlined,
          ),
          const Divider(height: 24),

          // Fertilizers Section
          Row(
            children: [
              Icon(Icons.grass, size: 20, color: Colors.green[700]),
              const SizedBox(width: 8),
              Text(
                isHindi ? 'उर्वरक सूची' : 'Fertilizers',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fertilizer Items
          ...stage.fertilizers
              .map((fertilizer) => _buildFertilizerItem(fertilizer, isHindi)),

          // Research Note
          if (stage.researchNote.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.science, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stage.researchNote,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                        height: 1.4,
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.green[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
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

  Widget _buildFertilizerItem(FertilizerItem fertilizer, bool isHindi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isHindi ? fertilizer.nameHi : fertilizer.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFertilizerDetail(
                  isHindi ? 'प्रति हेक्टेयर' : 'Per hectare',
                  '${fertilizer.dosagePerHa} ${fertilizer.unit}',
                ),
              ),
              Expanded(
                child: _buildFertilizerDetail(
                  isHindi ? 'कुल मात्रा' : 'Total',
                  '${fertilizer.totalQuantityForField} ${fertilizer.unit}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFertilizerDetail(
            isHindi ? 'लागत' : 'Cost',
            '₹${fertilizer.totalCost.toStringAsFixed(0)}',
          ),
          if (fertilizer.contains != null) ...[
            const SizedBox(height: 4),
            Text(
              '${isHindi ? "शामिल" : "Contains"}: ${fertilizer.contains}',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFertilizerDetail(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStageColor(int index) {
    final colors = [
      Colors.purple[600]!,
      Colors.blue[600]!,
      Colors.green[600]!,
      Colors.orange[600]!,
      Colors.red[600]!,
    ];
    return colors[index % colors.length];
  }
}
