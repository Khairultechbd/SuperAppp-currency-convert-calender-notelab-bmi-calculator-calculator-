import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/bmi_record.dart';

final bmiRepositoryProvider = Provider<BMIRepository>((ref) {
  return BMIRepository();
});

class BMIRepository {
  Future<void> saveBMIRecord(BMIRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getBMIRecords();
    records.add(record);
    
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(AppConstants.bmiHistoryKey, jsonEncode(jsonList));
  }

  Future<List<BMIRecord>> getBMIRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(AppConstants.bmiHistoryKey);
    
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => BMIRecord.fromJson(json as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> deleteBMIRecord(BMIRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getBMIRecords();
    records.removeWhere((r) => r.timestamp == record.timestamp);
    
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(AppConstants.bmiHistoryKey, jsonEncode(jsonList));
  }
} 