import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

final settingsProvider = StateNotifierProvider<SettingsProvider, SettingsState>((ref) {
  return SettingsProvider();
});

class SettingsProvider extends StateNotifier<SettingsState> {
  SettingsProvider() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeMode = ThemeMode.values[prefs.getInt(AppConstants.themeKey) ?? 0];
    final fontSize = prefs.getDouble(AppConstants.fontSizeKey) ?? AppConstants.mediumFontSize;
    final fontFamily = prefs.getString(AppConstants.fontFamilyKey) ?? AppConstants.sansFont;

    state = state.copyWith(
      themeMode: themeMode,
      fontSize: fontSize,
      fontFamily: fontFamily,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themeKey, state.themeMode.index);
    await prefs.setDouble(AppConstants.fontSizeKey, state.fontSize);
    await prefs.setString(AppConstants.fontFamilyKey, state.fontFamily);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveSettings();
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size);
    _saveSettings();
  }

  void setFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
    _saveSettings();
  }

  Future<void> clearCalculatorHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.calculatorHistoryKey);
  }

  Future<void> clearBMIHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.bmiHistoryKey);
  }
}

class SettingsState {
  final ThemeMode themeMode;
  final double fontSize;
  final String fontFamily;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.fontSize = AppConstants.mediumFontSize,
    this.fontFamily = AppConstants.sansFont,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    String? fontFamily,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
} 