import '../../domain/entities/soil_recommendation.dart';

/// Soil recommendation model with bilingual support
///
/// Backend provides both English and Hindi versions for all text fields.
/// Field naming pattern: `fieldName` (English) and `fieldNameHi` (Hindi)
class SoilRecommendationModel {
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
  final dynamic currentValue; // Can be double, String, or Map
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

  const SoilRecommendationModel({
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

  factory SoilRecommendationModel.fromJson(Map<String, dynamic> json) {
    return SoilRecommendationModel(
      issue: json['issue'] as String? ?? '',
      issueHi: json['issue_hi'] as String? ?? '',
      description: json['description'] as String? ?? '',
      descriptionHi: json['description_hi'] as String? ?? '',
      solution: json['solution'] as String? ?? '',
      solutionHi: json['solution_hi'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      dosageCalculation: json['dosage_calculation'] as String? ?? '',
      timeline: json['timeline'] as String? ?? '',
      applicationMethod: json['application_method'] as String? ?? '',
      organicAlternative: json['organic_alternative'] as String? ?? '',
      estimatedCost: json['estimated_cost'] as String? ?? '',
      priority: json['priority'] as String? ?? 'medium',
      currentValue: json['current_value'],
      currentThresholds: json['current_thresholds'] as String? ?? '',
      targetRange: json['target_range'] as String? ?? '',
      actionUrgency: json['action_urgency'] as String? ?? '',
      actionUrgencyHi: json['action_urgency_hi'] as String? ?? '',
      recommendationOrder: json['recommendation_order'] as int? ?? 0,
      indicators: (json['indicators'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      deficit: (json['deficit'] as num?)?.toDouble(),
      deficitPercentage: (json['deficit_percentage'] as num?)?.toDouble(),
      excess: (json['excess'] as num?)?.toDouble(),
      excessPercentage: (json['excess_percentage'] as num?)?.toDouble(),
      deviation: (json['deviation'] as num?)?.toDouble(),
      severityPercentage: (json['severity_percentage'] as num?)?.toDouble(),
      criticalWarning: json['critical_warning'] as String?,
      riskFactors: (json['risk_factors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      preventionMeasures: (json['prevention_measures'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'issue': issue,
      'issue_hi': issueHi,
      'description': description,
      'description_hi': descriptionHi,
      'solution': solution,
      'solution_hi': solutionHi,
      'dosage': dosage,
      'dosage_calculation': dosageCalculation,
      'timeline': timeline,
      'application_method': applicationMethod,
      'organic_alternative': organicAlternative,
      'estimated_cost': estimatedCost,
      'priority': priority,
      'current_value': currentValue,
      'current_thresholds': currentThresholds,
      'target_range': targetRange,
      'action_urgency': actionUrgency,
      'action_urgency_hi': actionUrgencyHi,
      'recommendation_order': recommendationOrder,
      'indicators': indicators,
    };

    // Add optional fields only if they're not null
    if (deficit != null) data['deficit'] = deficit;
    if (deficitPercentage != null) {
      data['deficit_percentage'] = deficitPercentage;
    }
    if (excess != null) data['excess'] = excess;
    if (excessPercentage != null) data['excess_percentage'] = excessPercentage;
    if (deviation != null) data['deviation'] = deviation;
    if (severityPercentage != null) {
      data['severity_percentage'] = severityPercentage;
    }
    if (criticalWarning != null) data['critical_warning'] = criticalWarning;
    if (riskFactors != null) data['risk_factors'] = riskFactors;
    if (preventionMeasures != null) {
      data['prevention_measures'] = preventionMeasures;
    }

    return data;
  }

  SoilRecommendation toEntity() {
    return SoilRecommendation(
      issue: issue,
      issueHi: issueHi,
      description: description,
      descriptionHi: descriptionHi,
      solution: solution,
      solutionHi: solutionHi,
      dosage: dosage,
      dosageCalculation: dosageCalculation,
      timeline: timeline,
      applicationMethod: applicationMethod,
      organicAlternative: organicAlternative,
      estimatedCost: estimatedCost,
      priority: priority,
      currentValue: currentValue,
      currentThresholds: currentThresholds,
      targetRange: targetRange,
      actionUrgency: actionUrgency,
      actionUrgencyHi: actionUrgencyHi,
      recommendationOrder: recommendationOrder,
      indicators: indicators,
      deficit: deficit,
      deficitPercentage: deficitPercentage,
      excess: excess,
      excessPercentage: excessPercentage,
      deviation: deviation,
      severityPercentage: severityPercentage,
      criticalWarning: criticalWarning,
      riskFactors: riskFactors,
      preventionMeasures: preventionMeasures,
    );
  }

  factory SoilRecommendationModel.fromEntity(SoilRecommendation entity) {
    return SoilRecommendationModel(
      issue: entity.issue,
      issueHi: entity.issueHi,
      description: entity.description,
      descriptionHi: entity.descriptionHi,
      solution: entity.solution,
      solutionHi: entity.solutionHi,
      dosage: entity.dosage,
      dosageCalculation: entity.dosageCalculation,
      timeline: entity.timeline,
      applicationMethod: entity.applicationMethod,
      organicAlternative: entity.organicAlternative,
      estimatedCost: entity.estimatedCost,
      priority: entity.priority,
      currentValue: entity.currentValue,
      currentThresholds: entity.currentThresholds,
      targetRange: entity.targetRange,
      actionUrgency: entity.actionUrgency,
      actionUrgencyHi: entity.actionUrgencyHi,
      recommendationOrder: entity.recommendationOrder,
      indicators: entity.indicators,
      deficit: entity.deficit,
      deficitPercentage: entity.deficitPercentage,
      excess: entity.excess,
      excessPercentage: entity.excessPercentage,
      deviation: entity.deviation,
      severityPercentage: entity.severityPercentage,
      criticalWarning: entity.criticalWarning,
      riskFactors: entity.riskFactors,
      preventionMeasures: entity.preventionMeasures,
    );
  }
}
