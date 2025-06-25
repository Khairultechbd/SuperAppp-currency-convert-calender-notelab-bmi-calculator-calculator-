import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/calculation.dart';
import '../../../../core/constants/app_constants.dart';

final calculatorProvider = StateNotifierProvider<CalculatorProvider, CalculatorState>((ref) {
  return CalculatorProvider();
});

class CalculatorProvider extends StateNotifier<CalculatorState> {
  CalculatorProvider() : super(const CalculatorState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(AppConstants.calculatorHistoryKey);
    
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List;
      final history = jsonList
          .map((json) => Calculation.fromJson(json as Map<String, dynamic>))
          .toList();
      state = state.copyWith(history: history);
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.history.map((calc) => calc.toJson()).toList();
    await prefs.setString(AppConstants.calculatorHistoryKey, jsonEncode(jsonList));
  }

  void appendNumber(String number) {
    if (state.currentInput == '0') {
      state = state.copyWith(currentInput: number);
    } else {
      state = state.copyWith(currentInput: state.currentInput + number);
    }
  }

  void appendOperator(String operator) {
    if (state.currentInput.isNotEmpty) {
      state = state.copyWith(currentInput: state.currentInput + operator);
    }
  }

  void clear() {
    state = const CalculatorState();
  }

  void calculate() {
    try {
      final expression = state.currentInput;
      final parser = GrammarParser();
      final context = ContextModel();
      
      final parsedExpression = parser.parse(expression);
      final result = parsedExpression.evaluate(EvaluationType.REAL, context);
      
      final calculation = Calculation(
        expression: expression,
        result: result.toString(),
        timestamp: DateTime.now(),
      );

      final updatedHistory = [calculation, ...state.history];
      state = state.copyWith(
        currentInput: result.toString(),
        previousInput: expression,
        history: updatedHistory,
      );

      _saveHistory();
    } catch (e) {
      state = state.copyWith(
        currentInput: 'Error',
        previousInput: state.currentInput,
      );
    }
  }

  void delete() {
    if (state.currentInput.isNotEmpty) {
      state = state.copyWith(
        currentInput: state.currentInput.substring(0, state.currentInput.length - 1),
      );
    }
  }

  void clearHistory() {
    state = state.copyWith(history: []);
    _saveHistory();
  }

  void deleteHistoryItem(int index) {
    final updatedHistory = List<Calculation>.from(state.history);
    updatedHistory.removeAt(index);
    state = state.copyWith(history: updatedHistory);
    _saveHistory();
  }
}

class CalculatorState {
  final String currentInput;
  final String previousInput;
  final List<Calculation> history;

  const CalculatorState({
    this.currentInput = '0',
    this.previousInput = '',
    this.history = const [],
  });

  CalculatorState copyWith({
    String? currentInput,
    String? previousInput,
    List<Calculation>? history,
  }) {
    return CalculatorState(
      currentInput: currentInput ?? this.currentInput,
      previousInput: previousInput ?? this.previousInput,
      history: history ?? this.history,
    );
  }
}

class Calculation {
  final String expression;
  final String result;
  final DateTime timestamp;

  Calculation({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Calculation.fromJson(Map<String, dynamic> json) {
    return Calculation(
      expression: json['expression'] as String,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
} 