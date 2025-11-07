import 'package:equatable/equatable.dart';

/// Soil recommendation entity with bilingual support (English & Hindi)
///
/// The backend always provides both language versions in the response.
/// Use `issue` for English and `issueHi` for Hindi display in the UI.
/// Language selection is handled at the presentation layer based on
/// the app's current locale (Localizations.localeOf(context).languageCode).
class SoilRecommendation extends Equatable {
  final String issue;
  final String issueHi;
  final String description;
  final String descriptionHi;
  final String solution;
  final String solutionHi;
  final String dosage;
  final String dosageCalculation;
  final String timeline;
  final String applicationMethod;
  final String organicAlternative;
  final String estimatedCost;
  final String priority;
  final dynamic currentValue;
  final String currentThresholds;
  final String targetRange;
  final String actionUrgency;
  final String actionUrgencyHi;
  final int recommendationOrder;
  final List<String> indicators;

  // Optional fields
  final double? deficit;
  final double? deficitPercentage;
  final double? excess;
  final double? excessPercentage;
  final double? deviation;
  final double? severityPercentage;
  final String? criticalWarning;
  final List<String>? riskFactors;
  final List<String>? preventionMeasures;

  const SoilRecommendation({
    required this.issue,
    required this.issueHi,
    required this.description,
    required this.descriptionHi,
    required this.solution,
    required this.solutionHi,
    required this.dosage,
    required this.dosageCalculation,
    required this.timeline,
    required this.applicationMethod,
    required this.organicAlternative,
    required this.estimatedCost,
    required this.priority,
    required this.currentValue,
    required this.currentThresholds,
    required this.targetRange,
    required this.actionUrgency,
    required this.actionUrgencyHi,
    required this.recommendationOrder,
    required this.indicators,
    this.deficit,
    this.deficitPercentage,
    this.excess,
    this.excessPercentage,
    this.deviation,
    this.severityPercentage,
    this.criticalWarning,
    this.riskFactors,
    this.preventionMeasures,
  });

  @override
  List<Object?> get props => [
        issue,
        issueHi,
        description,
        descriptionHi,
        solution,
        solutionHi,
        dosage,
        dosageCalculation,
        timeline,
        applicationMethod,
        organicAlternative,
        estimatedCost,
        priority,
        currentValue,
        currentThresholds,
        targetRange,
        actionUrgency,
        actionUrgencyHi,
        recommendationOrder,
        indicators,
        deficit,
        deficitPercentage,
        excess,
        excessPercentage,
        deviation,
        severityPercentage,
        criticalWarning,
        riskFactors,
        preventionMeasures,
      ];

  // Helper methods
  bool get isHighPriority => priority == 'high';
  bool get isMediumPriority => priority == 'medium';
  bool get isLowPriority => priority == 'low';

  bool get hasDeficit => deficit != null && deficit! > 0;
  bool get hasExcess => excess != null && excess! > 0;
  bool get isCritical => criticalWarning != null && criticalWarning!.isNotEmpty;

  String getCurrentValueFormatted() {
    if (currentValue is double) {
      return (currentValue as double).toStringAsFixed(1);
    } else if (currentValue is int) {
      return currentValue.toString();
    } else if (currentValue is String) {
      return currentValue as String;
    }
    return currentValue?.toString() ?? 'N/A';
  }
}
