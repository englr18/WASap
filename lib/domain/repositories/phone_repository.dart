import '../entities/app_settings.dart';
import '../entities/recent_number.dart';

/// Repository interface for phone number storage operations.
///
/// This abstraction allows for different storage implementations
/// without affecting the domain layer.
abstract class PhoneRepository {
  /// Saves the given phone number to recent numbers history.
  ///
  /// Implements FIFO with max 20 entries and no duplicates.
  Future<void> addRecentNumber(String phoneNumber);

  /// Gets all recent phone numbers, sorted by most recent first.
  Future<List<RecentNumber>> getRecentNumbers();

  /// Clears all recent numbers.
  Future<void> clearRecentNumbers();

  /// Gets the current app settings.
  Future<AppSettings> getSettings();

  /// Saves the app settings.
  Future<void> saveSettings(AppSettings settings);
}
