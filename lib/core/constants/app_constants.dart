class AppConstants {
  // App Info
  static const String appName = 'SuperApp';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A powerful Super app with advanced features.';
  static const String developerName = 'Md. Khairul Islam';

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String fontSizeKey = 'font_size';
  static const String fontFamilyKey = 'font_family';
  static const String calculatorHistoryKey = 'calculator_history';
  static const String bmiHistoryKey = 'bmi_history';
  static const String languageKey = 'language';

  // Font Sizes
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 16.0;
  static const double largeFontSize = 18.0;

  // Font Families
  static const String sansFont = 'Sans';
  static const String serifFont = 'Serif';
  static const String monoFont = 'Monospace';

  // Padding
  static const double smallPadding = 8.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;

  // Border Radius
  static const double borderRadius = 12.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;

  // Animation Duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // API Endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String invalidInputMessage = 'Invalid input. Please try again.';

  // Success Messages
  static const String calculationSavedMessage = 'Calculation saved successfully.';
  static const String settingsUpdatedMessage = 'Settings updated successfully.';
} 