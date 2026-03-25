import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';

/// Service for persisting app settings using SharedPreferences.
///
/// Keys:
/// - 'theme_mode': 'light', 'dark', or 'system'
/// - 'locale': 'en' or 'id'
class SettingsStorageService {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  final SharedPreferences _prefs;

  SettingsStorageService(this._prefs);

  /// Loads app settings from SharedPreferences.
  AppSettings loadSettings() {
    final themeModeString = _prefs.getString(_themeModeKey);
    final localeString = _prefs.getString(_localeKey);

    ThemeMode themeMode = ThemeMode.light;
    if (themeModeString == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (themeModeString == 'system') {
      themeMode = ThemeMode.system;
    }

    Locale locale = const Locale('en');
    if (localeString == 'id') {
      locale = const Locale('id');
    }

    return AppSettings(themeMode: themeMode, locale: locale);
  }

  /// Saves app settings to SharedPreferences.
  Future<void> saveSettings(AppSettings settings) async {
    String themeModeString;
    switch (settings.themeMode) {
      case ThemeMode.dark:
        themeModeString = 'dark';
      case ThemeMode.system:
        themeModeString = 'system';
      case ThemeMode.light:
        themeModeString = 'light';
    }

    String localeString = settings.locale.languageCode;

    await _prefs.setString(_themeModeKey, themeModeString);
    await _prefs.setString(_localeKey, localeString);
  }
}
