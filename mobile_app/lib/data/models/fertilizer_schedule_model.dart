import '../../domain/entities/fertilizer_schedule.dart';

/// Fertilizer schedule models with bilingual support
///
/// All models follow the pattern: `field` (English) and `fieldHi` (Hindi)
class FertilizerItemModel {
  final String name;
  final String nameHi;
  final double dosagePerHa;
  final String unit;
  final double totalQuantityForField;
  final double costPerUnit;
  final double totalCost;
  final String? contains;
  final String? percentageOfTotal;
  final String? percentageOfTotalK;
  final String? preparation;
  final String? researchNote;
  final String? calculationNote;
  final String? supplierNote;

  const FertilizerItemModel({
    required this.name,
    required this.nameHi,
    required this.dosagePerHa,
    required this.unit,
    required this.totalQuantityForField,
    required this.costPerUnit,
    required this.totalCost,
    this.contains,
    this.percentageOfTotal,
    this.percentageOfTotalK,
    this.preparation,
    this.researchNote,
    this.calculationNote,
    this.supplierNote,
  });

  factory FertilizerItemModel.fromJson(Map<String, dynamic> json) {
    return FertilizerItemModel(
      name: json['name'] as String? ?? '',
      nameHi: json['name_hi'] as String? ?? '',
      dosagePerHa: (json['dosage_per_ha'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
      totalQuantityForField:
          (json['total_quantity_for_field'] as num?)?.toDouble() ?? 0.0,
      costPerUnit: (json['cost_per_unit'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0.0,
      contains: json['contains'] as String?,
      percentageOfTotal: json['percentage_of_total'] as String?,
      percentageOfTotalK: json['percentage_of_total_K'] as String?,
      preparation: json['preparation'] as String?,
      researchNote: json['research_note'] as String?,
      calculationNote: json['calculation_note'] as String?,
      supplierNote: json['supplier_note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'name_hi': nameHi,
      'dosage_per_ha': dosagePerHa,
      'unit': unit,
      'total_quantity_for_field': totalQuantityForField,
      'cost_per_unit': costPerUnit,
      'total_cost': totalCost,
    };

    if (contains != null) data['contains'] = contains;
    if (percentageOfTotal != null) {
      data['percentage_of_total'] = percentageOfTotal;
    }
    if (percentageOfTotalK != null) {
      data['percentage_of_total_K'] = percentageOfTotalK;
    }
    if (preparation != null) data['preparation'] = preparation;
    if (researchNote != null) data['research_note'] = researchNote;
    if (calculationNote != null) data['calculation_note'] = calculationNote;
    if (supplierNote != null) data['supplier_note'] = supplierNote;

    return data;
  }

  FertilizerItem toEntity() {
    return FertilizerItem(
      name: name,
      nameHi: nameHi,
      dosagePerHa: dosagePerHa,
      unit: unit,
      totalQuantityForField: totalQuantityForField,
      costPerUnit: costPerUnit,
      totalCost: totalCost,
      contains: contains,
      percentageOfTotal: percentageOfTotal,
      percentageOfTotalK: percentageOfTotalK,
      preparation: preparation,
      researchNote: researchNote,
      calculationNote: calculationNote,
      supplierNote: supplierNote,
    );
  }
}

class FertilizerStageModel {
  final String stage;
  final String stageHi;
  final int day;
  final int daysAfterTransplanting;
  final String applicationDate;
  final String applicationMethod;
  final String applicationMethodHi;
  final String notes;
  final String researchNote;
  final List<FertilizerItemModel> fertilizers;
  final dynamic totalCostStage;

  const FertilizerStageModel({
    required this.stage,
    required this.stageHi,
    required this.day,
    required this.daysAfterTransplanting,
    required this.applicationDate,
    required this.applicationMethod,
    required this.applicationMethodHi,
    required this.notes,
    required this.researchNote,
    required this.fertilizers,
    required this.totalCostStage,
  });

  factory FertilizerStageModel.fromJson(Map<String, dynamic> json) {
    return FertilizerStageModel(
      stage: json['stage'] as String? ?? '',
      stageHi: json['stage_hi'] as String? ?? '',
      day: json['day'] as int? ?? 0,
      daysAfterTransplanting: json['days_after_transplanting'] as int? ?? 0,
      applicationDate: json['application_date'] as String? ?? '',
      applicationMethod: json['application_method'] as String? ?? '',
      applicationMethodHi: json['application_method_hi'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      researchNote: json['research_note'] as String? ?? '',
      fertilizers: (json['fertilizers'] as List<dynamic>?)
              ?.map((e) =>
                  FertilizerItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCostStage: json['total_cost_stage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'stage_hi': stageHi,
      'day': day,
      'days_after_transplanting': daysAfterTransplanting,
      'application_date': applicationDate,
      'application_method': applicationMethod,
      'application_method_hi': applicationMethodHi,
      'notes': notes,
      'research_note': researchNote,
      'fertilizers': fertilizers.map((e) => e.toJson()).toList(),
      'total_cost_stage': totalCostStage,
    };
  }

  FertilizerStage toEntity() {
    return FertilizerStage(
      stage: stage,
      stageHi: stageHi,
      day: day,
      daysAfterTransplanting: daysAfterTransplanting,
      applicationDate: applicationDate,
      applicationMethod: applicationMethod,
      applicationMethodHi: applicationMethodHi,
      notes: notes,
      researchNote: researchNote,
      fertilizers: fertilizers.map((e) => e.toEntity()).toList(),
      totalCostStage: totalCostStage,
    );
  }
}

class FertilizerScheduleSummaryModel {
  final double fieldAreaHectares;
  final String cropType;
  final String varietyType;
  final Map<String, dynamic> totalNutrientsCalculated;
  final Map<String, dynamic> totalFertilizersNeeded;
  final Map<String, String> estimatedTotalCost;
  final Map<String, String> expectedYield;

  const FertilizerScheduleSummaryModel({
    required this.fieldAreaHectares,
    required this.cropType,
    required this.varietyType,
    required this.totalNutrientsCalculated,
    required this.totalFertilizersNeeded,
    required this.estimatedTotalCost,
    required this.expectedYield,
  });

  factory FertilizerScheduleSummaryModel.fromJson(Map<String, dynamic> json) {
    return FertilizerScheduleSummaryModel(
      fieldAreaHectares:
          (json['field_area_hectares'] as num?)?.toDouble() ?? 0.0,
      cropType: json['crop_type'] as String? ?? 'chilli',
      varietyType: json['variety_type'] as String? ?? 'hybrid',
      totalNutrientsCalculated:
          json['total_nutrients_calculated'] as Map<String, dynamic>? ?? {},
      totalFertilizersNeeded:
          json['total_fertilizers_needed'] as Map<String, dynamic>? ?? {},
      estimatedTotalCost:
          Map<String, String>.from(json['estimated_total_cost'] ?? {}),
      expectedYield: Map<String, String>.from(json['expected_yield'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field_area_hectares': fieldAreaHectares,
      'crop_type': cropType,
      'variety_type': varietyType,
      'total_nutrients_calculated': totalNutrientsCalculated,
      'total_fertilizers_needed': totalFertilizersNeeded,
      'estimated_total_cost': estimatedTotalCost,
      'expected_yield': expectedYield,
    };
  }

  FertilizerScheduleSummary toEntity() {
    return FertilizerScheduleSummary(
      fieldAreaHectares: fieldAreaHectares,
      cropType: cropType,
      varietyType: varietyType,
      totalNutrientsCalculated: totalNutrientsCalculated,
      totalFertilizersNeeded: totalFertilizersNeeded,
      estimatedTotalCost: estimatedTotalCost,
      expectedYield: expectedYield,
    );
  }
}

class FertilizerScheduleModel {
  final List<FertilizerStageModel> schedule;
  final FertilizerScheduleSummaryModel summary;

  const FertilizerScheduleModel({
    required this.schedule,
    required this.summary,
  });

  factory FertilizerScheduleModel.fromJson(Map<String, dynamic> json) {
    return FertilizerScheduleModel(
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((e) =>
                  FertilizerStageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      summary: FertilizerScheduleSummaryModel.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule': schedule.map((e) => e.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }

  FertilizerSchedule toEntity() {
    return FertilizerSchedule(
      schedule: schedule.map((e) => e.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}
