import '../entities/phone_number.dart';

/// Use case for normalizing Indonesian phone numbers.
///
/// This use case transforms various phone number formats into the
/// canonical WhatsApp-compatible format: 62XXXXXXXXX
///
/// Normalization pipeline (strict order):
/// 1. Remove all non-digit characters
/// 2. If starts with `62` → use as-is
/// 3. If starts with `0` → replace `0` with `62`
/// 4. If starts with `8` → prepend `62`
/// 5. Otherwise → prepend `62`
class NormalizePhoneNumber {
  /// Normalizes the given phone number input.
  ///
  /// Returns a [PhoneNumber] entity with the normalized value.
  /// The normalization is deterministic and idempotent.
  PhoneNumber call(String input) {
    if (input.isEmpty) {
      return const PhoneNumber('');
    }

    // Step 1: Remove all non-digit characters
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.isEmpty) {
      return const PhoneNumber('');
    }

    // Step 2-5: Apply normalization rules
    String normalized;
    if (digitsOnly.startsWith('62')) {
      // Already starts with 62
      normalized = digitsOnly;
    } else if (digitsOnly.startsWith('0')) {
      // Replace leading 0 with 62
      normalized = '62${digitsOnly.substring(1)}';
    } else if (digitsOnly.startsWith('8')) {
      // Prepend 62
      normalized = '62$digitsOnly';
    } else {
      // Prepend 62
      normalized = '62$digitsOnly';
    }

    return PhoneNumber(normalized);
  }

  /// Validates if the given normalized number is valid.
  ///
  /// A number is valid if:
  /// - Length >= 10 digits
  /// - Starts with 62
  bool isValid(PhoneNumber phoneNumber) {
    return phoneNumber.isValid;
  }
}
