import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/bmi_record.dart';
import '../../data/repositories/bmi_repository.dart';

final bmiProvider = StateNotifierProvider<BMIProvider, BMIState>((ref) {
  return BMIProvider(ref.watch(bmiRepositoryProvider));
});

class BMIProvider extends StateNotifier<BMIState> {
  final BMIRepository _repository;

  BMIProvider(this._repository) : super(const BMIState());

  Future<void> calculateBMI({
    required double height,
    required double weight,
    required bool isMetric,
  }) async {
    // Convert to metric if imperial
    final heightInMeters = isMetric ? height / 100 : height * 0.0254;
    final weightInKg = isMetric ? weight : weight * 0.453592;

    // Calculate BMI
    final bmi = weightInKg / (heightInMeters * heightInMeters);

    // Determine category
    String category;
    Color categoryColor;
    if (bmi < 18.5) {
      category = 'Underweight';
      categoryColor = Colors.blue;
    } else if (bmi < 25) {
      category = 'Normal';
      categoryColor = Colors.green;
    } else if (bmi < 30) {
      category = 'Overweight';
      categoryColor = Colors.orange;
    } else {
      category = 'Obese';
      categoryColor = Colors.red;
    }

    // Save to history
    final record = BMIRecord(
      bmi: bmi,
      height: height,
      weight: weight,
      isMetric: isMetric,
      timestamp: DateTime.now(),
    );
    await _repository.saveBMIRecord(record);

    state = BMIState(
      bmi: bmi,
      category: category,
      categoryColor: categoryColor,
    );
  }

  Future<void> loadHistory() async {
    final records = await _repository.getBMIRecords();
    state = state.copyWith(history: records);
  }

  Future<void> deleteRecord(BMIRecord record) async {
    await _repository.deleteBMIRecord(record);
    await loadHistory();
  }
}

class BMIState {
  final double? bmi;
  final String category;
  final Color categoryColor;
  final List<BMIRecord> history;

  const BMIState({
    this.bmi,
    this.category = '',
    this.categoryColor = Colors.black,
    this.history = const [],
  });

  BMIState copyWith({
    double? bmi,
    String? category,
    Color? categoryColor,
    List<BMIRecord>? history,
  }) {
    return BMIState(
      bmi: bmi ?? this.bmi,
      category: category ?? this.category,
      categoryColor: categoryColor ?? this.categoryColor,
      history: history ?? this.history,
    );
  }
} 