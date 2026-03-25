import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/recent_number.dart';
import '../../domain/repositories/phone_repository.dart';

/// State for recent numbers.
class RecentNumbersState {
  final List<RecentNumber> recentNumbers;
  final bool isLoading;

  const RecentNumbersState({
    this.recentNumbers = const [],
    this.isLoading = true,
  });

  RecentNumbersState copyWith({
    List<RecentNumber>? recentNumbers,
    bool? isLoading,
  }) {
    return RecentNumbersState(
      recentNumbers: recentNumbers ?? this.recentNumbers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Controller for recent phone numbers.
///
/// Manages recent numbers history with max 20 entries, FIFO, no duplicates.
class RecentNumbersController extends StateNotifier<RecentNumbersState> {
  final PhoneRepository _repository;

  RecentNumbersController(this._repository)
    : super(const RecentNumbersState()) {
    _loadRecentNumbers();
  }

  Future<void> _loadRecentNumbers() async {
    final recentNumbers = await _repository.getRecentNumbers();
    state = state.copyWith(recentNumbers: recentNumbers, isLoading: false);
  }

  /// Adds a phone number to recent history.
  Future<void> addRecentNumber(String phoneNumber) async {
    await _repository.addRecentNumber(phoneNumber);
    await _loadRecentNumbers();
  }

  /// Clears all recent numbers.
  Future<void> clearRecentNumbers() async {
    await _repository.clearRecentNumbers();
    state = state.copyWith(recentNumbers: []);
  }

  /// Reloads recent numbers from storage.
  Future<void> refresh() async {
    await _loadRecentNumbers();
  }
}
