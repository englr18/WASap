import 'package:flutter/material.dart';

/// Application settings entity representing user preferences.
///
/// Stores theme mode and locale settings that persist across app restarts.
class AppSettings {
  /// The current theme mode (light, dark, or system)
  final ThemeMode themeMode;

  /// The current locale (language)
  final Locale locale;

  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
  });

  /// Creates a copy of this settings with optional overrides.
  AppSettings copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.themeMode == themeMode &&
        other.locale == locale;
  }

  @override
  int get hashCode => Object.hash(themeMode, locale);

  @override
  String toString() => 'AppSettings(themeMode: $themeMode, locale: $locale)';
}
