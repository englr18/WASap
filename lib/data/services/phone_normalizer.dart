import '../../domain/entities/phone_number.dart';
import '../../domain/usecases/normalize_phone_number.dart';

/// Service for phone number normalization.
///
/// This service provides a simplified interface to the domain use case,
/// handling input validation and normalization.
class PhoneNormalizerService {
  /// The normalization use case
  final NormalizePhoneNumber _normalizeUseCase;

  /// Creates a new PhoneNormalizerService.
  PhoneNormalizerService({NormalizePhoneNumber? normalizeUseCase})
    : _normalizeUseCase = normalizeUseCase ?? NormalizePhoneNumber();

  /// Normalizes the given phone number input.
  ///
  /// Returns a [PhoneNumber] entity with the normalized value.
  PhoneNumber normalize(String input) {
    return _normalizeUseCase(input);
  }

  /// Validates if the given phone number is valid.
  bool isValid(PhoneNumber phoneNumber) {
    return _normalizeUseCase.isValid(phoneNumber);
  }

  /// Validates the given raw input string.
  ///
  /// Returns true if the normalized result would be valid.
  bool isValidInput(String input) {
    final normalized = normalize(input);
    return normalized.isValid;
  }
}
