import 'package:equatable/equatable.dart';

/// Fertilizer item with bilingual support (English & Hindi)
///
/// Contains fertilizer details with both language versions.
/// Use `name` for English and `nameHi` for Hindi in the UI.
class FertilizerItem extends Equatable {
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

  const FertilizerItem({
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

  @override
  List<Object?> get props => [
        name,
        nameHi,
        dosagePerHa,
        unit,
        totalQuantityForField,
        costPerUnit,
        totalCost,
        contains,
        percentageOfTotal,
        percentageOfTotalK,
        preparation,
        researchNote,
        calculationNote,
        supplierNote,
      ];
}

class FertilizerStage extends Equatable {
  final String stage;
  final String stageHi;
  final int day;
  final int daysAfterTransplanting;
  final String applicationDate;
  final String applicationMethod;
  final String applicationMethodHi;
  final String notes;
  final String researchNote;
  final List<FertilizerItem> fertilizers;
  final dynamic totalCostStage;

  const FertilizerStage({
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

  @override
  List<Object?> get props => [
        stage,
        stageHi,
        day,
        daysAfterTransplanting,
        applicationDate,
        applicationMethod,
        applicationMethodHi,
        notes,
        researchNote,
        fertilizers,
        totalCostStage,
      ];
}

class FertilizerScheduleSummary extends Equatable {
  final double fieldAreaHectares;
  final String cropType;
  final String varietyType;
  final Map<String, dynamic> totalNutrientsCalculated;
  final Map<String, dynamic> totalFertilizersNeeded;
  final Map<String, String> estimatedTotalCost;
  final Map<String, String> expectedYield;

  const FertilizerScheduleSummary({
    required this.fieldAreaHectares,
    required this.cropType,
    required this.varietyType,
    required this.totalNutrientsCalculated,
    required this.totalFertilizersNeeded,
    required this.estimatedTotalCost,
    required this.expectedYield,
  });

  @override
  List<Object?> get props => [
        fieldAreaHectares,
        cropType,
        varietyType,
        totalNutrientsCalculated,
        totalFertilizersNeeded,
        estimatedTotalCost,
        expectedYield,
      ];
}

class FertilizerSchedule extends Equatable {
  final List<FertilizerStage> schedule;
  final FertilizerScheduleSummary summary;

  const FertilizerSchedule({
    required this.schedule,
    required this.summary,
  });

  @override
  List<Object?> get props => [schedule, summary];

  int get totalStages => schedule.length;

  FertilizerStage? getStageForDay(int day) {
    try {
      return schedule.firstWhere((stage) => stage.day == day);
    } catch (e) {
      return null;
    }
  }

  List<FertilizerStage> getUpcomingStages(DateTime currentDate) {
    return schedule.where((stage) {
      final stageDate = DateTime.parse(stage.applicationDate);
      return stageDate.isAfter(currentDate);
    }).toList();
  }
}
