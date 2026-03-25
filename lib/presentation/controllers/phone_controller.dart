import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/phone_number.dart';
import '../../domain/repositories/whatsapp_repository.dart';
import '../../domain/usecases/launch_whatsapp.dart';
import '../../data/services/phone_normalizer.dart';
import '../../data/services/whatsapp_launcher.dart';

/// State for phone input and validation.
class PhoneState {
  /// The raw input from the user
  final String input;

  /// The normalized phone number
  final PhoneNumber? normalized;

  /// Whether the current input is valid
  final bool isValid;

  /// Whether WhatsApp is currently launching
  final bool isLoading;

  /// Error message if any
  final String? error;

  const PhoneState({
    this.input = '',
    this.normalized,
    this.isValid = false,
    this.isLoading = false,
    this.error,
  });

  PhoneState copyWith({
    String? input,
    PhoneNumber? normalized,
    bool? isValid,
    bool? isLoading,
    String? error,
  }) {
    return PhoneState(
      input: input ?? this.input,
      normalized: normalized ?? this.normalized,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Controller for phone input and validation.
///
/// Manages phone number input, normalization in real-time,
/// and WhatsApp launch functionality.
class PhoneController extends StateNotifier<PhoneState> {
  final PhoneNormalizerService _normalizer;
  final LaunchWhatsApp _launchWhatsApp;

  PhoneController({
    PhoneNormalizerService? normalizer,
    LaunchWhatsApp? launchWhatsApp,
  }) : _normalizer = normalizer ?? PhoneNormalizerService(),
       _launchWhatsApp =
           launchWhatsApp ?? LaunchWhatsApp(WhatsAppLauncherService()),
       super(const PhoneState());

  /// Updates the phone input and normalizes in real-time.
  void updateInput(String input) {
    final normalized = _normalizer.normalize(input);
    final isValid = normalized.isValid;

    state = PhoneState(
      input: input,
      normalized: normalized,
      isValid: isValid,
      isLoading: false,
      error: null,
    );
  }

  /// Clears the phone input.
  void clearInput() {
    state = const PhoneState();
  }

  /// Launches WhatsApp with the current normalized number.
  Future<void> launchWhatsApp({String? message}) async {
    if (state.normalized == null || !state.isValid) {
      state = state.copyWith(error: 'Invalid phone number');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final result = await _launchWhatsApp(state.normalized!, message: message);

    if (result is LaunchFailure) {
      state = state.copyWith(isLoading: false, error: result.message);
    } else {
      state = state.copyWith(isLoading: false, error: null);
    }
  }

  /// Clears any error state.
  void clearError() {
    state = state.copyWith(error: null);
  }
}
