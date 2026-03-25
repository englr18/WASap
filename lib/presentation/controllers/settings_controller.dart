import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/phone_repository.dart';

/// State for app settings.
class SettingsState {
  final AppSettings settings;
  final bool isLoading;

  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoading = true,
  });

  SettingsState copyWith({AppSettings? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Controller for app settings (theme and locale).
///
/// Manages theme mode and language settings with persistence.
class SettingsController extends StateNotifier<SettingsState> {
  final PhoneRepository _repository;

  SettingsController(this._repository) : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    state = state.copyWith(settings: settings, isLoading: false);
  }

  /// Sets the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    final newSettings = state.settings.copyWith(themeMode: mode);
    await _repository.saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }

  /// Sets the locale (language).
  Future<void> setLocale(Locale locale) async {
    final newSettings = state.settings.copyWith(locale: locale);
    await _repository.saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }
}
