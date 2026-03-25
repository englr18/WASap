import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/recent_number.dart';

/// Service for persisting recent phone numbers using SharedPreferences.
///
/// Implements:
/// - Maximum 20 entries
/// - FIFO (First In, First Out)
/// - No duplicates (most recent item appears first)
/// - Most recent item appears first in the list
class RecentNumbersStorageService {
  static const String _recentNumbersKey = 'recent_numbers';
  static const int _maxRecentNumbers = 20;

  final SharedPreferences _prefs;

  RecentNumbersStorageService(this._prefs);

  /// Adds a phone number to the recent numbers list.
  ///
  /// Implements FIFO with max 20 entries and no duplicates.
  /// If the number already exists, it's moved to the front (most recent).
  Future<void> addRecentNumber(String phoneNumber) async {
    final recentNumbers = await getRecentNumbers();

    // Remove if already exists (to move to front)
    recentNumbers.removeWhere((r) => r.phoneNumber == phoneNumber);

    // Add new entry at the beginning
    final newEntry = RecentNumber.create(phoneNumber);
    recentNumbers.insert(0, newEntry);

    // Keep only the first 20 entries
    final trimmedList = recentNumbers.take(_maxRecentNumbers).toList();

    // Save to SharedPreferences
    final jsonList = trimmedList.map((r) => r.toJson()).toList();
    await _prefs.setString(_recentNumbersKey, jsonEncode(jsonList));
  }

  /// Gets all recent phone numbers, sorted by most recent first.
  Future<List<RecentNumber>> getRecentNumbers() async {
    final jsonString = _prefs.getString(_recentNumbersKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => RecentNumber.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If parsing fails, return empty list
      return [];
    }
  }

  /// Clears all recent numbers.
  Future<void> clearRecentNumbers() async {
    await _prefs.remove(_recentNumbersKey);
  }
}
