import '../../domain/entities/app_settings.dart';
import '../../domain/entities/recent_number.dart';
import '../../domain/repositories/phone_repository.dart';
import '../services/recent_numbers_storage.dart';
import '../services/settings_storage.dart';

/// Implementation of [PhoneRepository] using SharedPreferences.
class PhoneRepositoryImpl implements PhoneRepository {
  final SettingsStorageService _settingsStorage;
  final RecentNumbersStorageService _recentNumbersStorage;

  PhoneRepositoryImpl({
    required SettingsStorageService settingsStorage,
    required RecentNumbersStorageService recentNumbersStorage,
  }) : _settingsStorage = settingsStorage,
       _recentNumbersStorage = recentNumbersStorage;

  @override
  Future<void> addRecentNumber(String phoneNumber) {
    return _recentNumbersStorage.addRecentNumber(phoneNumber);
  }

  @override
  Future<List<RecentNumber>> getRecentNumbers() {
    return _recentNumbersStorage.getRecentNumbers();
  }

  @override
  Future<void> clearRecentNumbers() {
    return _recentNumbersStorage.clearRecentNumbers();
  }

  @override
  Future<AppSettings> getSettings() async {
    return _settingsStorage.loadSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _settingsStorage.saveSettings(settings);
  }
}
