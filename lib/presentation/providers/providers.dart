import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/phone_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/recent_numbers_controller.dart';
import '../../data/services/settings_storage.dart';
import '../../data/services/recent_numbers_storage.dart';
import '../../data/repositories/phone_repository_impl.dart';
import '../../domain/repositories/phone_repository.dart';

/// Provider for SharedPreferences instance.
/// Must be overridden in main.dart before use.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be initialized in main.dart',
  );
});

/// Provider for settings storage service.
final settingsStorageProvider = Provider<SettingsStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsStorageService(prefs);
});

/// Provider for recent numbers storage service.
final recentNumbersStorageProvider = Provider<RecentNumbersStorageService>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RecentNumbersStorageService(prefs);
});

/// Provider for phone repository.
final phoneRepositoryProvider = Provider<PhoneRepository>((ref) {
  final settingsStorage = ref.watch(settingsStorageProvider);
  final recentNumbersStorage = ref.watch(recentNumbersStorageProvider);
  return PhoneRepositoryImpl(
    settingsStorage: settingsStorage,
    recentNumbersStorage: recentNumbersStorage,
  );
});

/// Provider for phone controller.
final phoneControllerProvider =
    StateNotifierProvider<PhoneController, PhoneState>((ref) {
      return PhoneController();
    });

/// Provider for settings controller.
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
      final repository = ref.watch(phoneRepositoryProvider);
      return SettingsController(repository);
    });

/// Provider for recent numbers controller.
final recentNumbersControllerProvider =
    StateNotifierProvider<RecentNumbersController, RecentNumbersState>((ref) {
      final repository = ref.watch(phoneRepositoryProvider);
      return RecentNumbersController(repository);
    });
