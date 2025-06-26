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
    required double feet,
    required double inches,
    required double weight,
  }) async {
    // Convert height to total inches
    final totalInches = feet * 12 + inches;
    // Convert height to meters
    final heightInMeters = totalInches * 0.0254;

    // Calculate BMI
    final bmi = weight / (heightInMeters * heightInMeters);

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
      feet: feet,
      inches: inches,
      weight: weight,
      timestamp: DateTime.now(),
    );
    await _repository.saveBMIRecord(record);

    state = BMIState(
      bmi: bmi,
      category: category,
      categoryColor: categoryColor,
      history: state.history,
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

  Future<void> undoDelete(BMIRecord record) async {
    await _repository.saveBMIRecord(record);
    await loadHistory();
  }

  void resetCurrentBMI() {
    state = state.copyWith(
      bmi: null,
      category: '',
      categoryColor: Colors.black,
    );
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