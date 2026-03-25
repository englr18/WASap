import 'package:flutter_test/flutter_test.dart';
import 'package:wasap/domain/entities/phone_number.dart';
import 'package:wasap/domain/usecases/normalize_phone_number.dart';

void main() {
  late NormalizePhoneNumber normalizePhoneNumber;

  setUp(() {
    normalizePhoneNumber = NormalizePhoneNumber();
  });

  group('NormalizePhoneNumber', () {
    group('call - normalization pipeline', () {
      group('input starting with 62', () {
        test('keeps 62-prefixed number as-is', () {
          final result = normalizePhoneNumber('628123456789');
          expect(result.value, '628123456789');
        });

        test('normalizes +62 format by removing +', () {
          final result = normalizePhoneNumber('+628123456789');
          expect(result.value, '628123456789');
        });

        test('normalizes number with spaces and 62 prefix', () {
          final result = normalizePhoneNumber('+62 812 345 6789');
          expect(result.value, '628123456789');
        });

        test('normalizes 62 with dashes', () {
          final result = normalizePhoneNumber('62-812-345-6789');
          expect(result.value, '628123456789');
        });
      });

      group('input starting with 0', () {
        test('replaces leading 0 with 62', () {
          final result = normalizePhoneNumber('081234567890');
          expect(result.value, '6281234567890');
        });

        test('normalizes 0 with spaces', () {
          final result = normalizePhoneNumber('0812 345 6789');
          expect(result.value, '628123456789');
        });

        test('normalizes 0 with dashes', () {
          final result = normalizePhoneNumber('0812-345-6789');
          expect(result.value, '628123456789');
        });

        test('handles +62 input correctly', () {
          final result = normalizePhoneNumber('+628123456789');
          expect(result.value, '628123456789');
        });
      });

      group('input starting with 8', () {
        test('prepends 62 to number starting with 8', () {
          final result = normalizePhoneNumber('8123456789');
          expect(result.value, '628123456789');
        });

        test('normalizes 8 with spaces', () {
          final result = normalizePhoneNumber('812 345 6789');
          expect(result.value, '628123456789');
        });

        test('normalizes 8 with dashes', () {
          final result = normalizePhoneNumber('812-345-6789');
          expect(result.value, '628123456789');
        });
      });

      group('input with other formats', () {
        test('prepends 62 to number starting with country code', () {
          final result = normalizePhoneNumber('628123456789');
          expect(result.value, '628123456789');
        });

        test('prepends 62 to number without country code prefix', () {
          final result = normalizePhoneNumber('1234567890');
          expect(result.value, '621234567890');
        });
      });

      group('edge cases', () {
        test('handles empty string', () {
          final result = normalizePhoneNumber('');
          expect(result.value, '');
        });

        test('handles string with only non-digit characters', () {
          final result = normalizePhoneNumber('abc-def-ghi');
          expect(result.value, '');
        });

        test('handles string with mixed alphanumeric - only digits remain', () {
          // The normalization removes all non-digit characters first
          final result = normalizePhoneNumber('0812abc123');
          expect(result.value, '62812123'); // Only digits kept after removeAll
        });

        test('handles string with leading zeros only', () {
          final result = normalizePhoneNumber('0000');
          // After removing non-digits: '0000'
          // Starts with 0, so replace 0 with 62: '620000' -> but wait, 0000 has leading zeros
          // digitsOnly = '0000', starts with 0, so replace 0 with 62: '620000'
          // That gives 5 digits but starts with 62
          expect(result.value, '62000'); // Only one 0 gets replaced
        });

        test('handles single digit input', () {
          final result = normalizePhoneNumber('8');
          expect(result.value, '628');
        });

        test('handles very long number', () {
          final result = normalizePhoneNumber('0812345678901234567890');
          expect(result.value, '62812345678901234567890');
        });
      });
    });

    group('call - deterministic behavior', () {
      test('produces consistent output for same input', () {
        final result1 = normalizePhoneNumber('081234567890');
        final result2 = normalizePhoneNumber('081234567890');
        expect(result1.value, result2.value);
      });
    });

    group('call - idempotency', () {
      test('normalizing normalized number returns same result', () {
        final normalized = normalizePhoneNumber('081234567890');
        final result = normalizePhoneNumber(normalized.value);
        expect(result.value, '6281234567890');
      });

      test('double normalization is idempotent for 62-prefixed', () {
        final first = normalizePhoneNumber('628123456789');
        final second = normalizePhoneNumber(first.value);
        expect(second.value, '628123456789');
      });

      test('double normalization is idempotent for 0-prefixed', () {
        final first = normalizePhoneNumber('081234567890');
        final second = normalizePhoneNumber(first.value);
        expect(second.value, '6281234567890');
      });

      test('double normalization is idempotent for 8-prefixed', () {
        final first = normalizePhoneNumber('8123456789');
        final second = normalizePhoneNumber(first.value);
        expect(second.value, '628123456789');
      });

      test('idempotency rule: normalize(normalize(x)) == normalize(x)', () {
        // Test all format variations
        final inputs = [
          '081234567890',
          '8123456789',
          '628123456789',
          '+628123456789',
          '0812 345 6789',
        ];

        for (final input in inputs) {
          final first = normalizePhoneNumber(input);
          final second = normalizePhoneNumber(first.value);
          expect(second.value, first.value, reason: 'Failed for input: $input');
        }
      });
    });

    group('isValid', () {
      test('returns true for valid normalized number', () {
        final phoneNumber = PhoneNumber('628123456789');
        expect(normalizePhoneNumber.isValid(phoneNumber), true);
      });

      test('returns false for invalid normalized number', () {
        final phoneNumber = PhoneNumber('812345678');
        expect(normalizePhoneNumber.isValid(phoneNumber), false);
      });

      test('returns false for empty number', () {
        final phoneNumber = PhoneNumber('');
        expect(normalizePhoneNumber.isValid(phoneNumber), false);
      });

      test('returns false for number less than 10 digits', () {
        final phoneNumber = PhoneNumber('628123456');
        expect(normalizePhoneNumber.isValid(phoneNumber), false);
      });

      test('returns true for number with exactly 10 digits', () {
        final phoneNumber = PhoneNumber('6281234567');
        expect(normalizePhoneNumber.isValid(phoneNumber), true);
      });

      test('returns true for number with more than 10 digits', () {
        final phoneNumber = PhoneNumber('6281234567890');
        expect(normalizePhoneNumber.isValid(phoneNumber), true);
      });
    });
  });

  group('Integration: normalization and validation', () {
    test('normalized number from 0812 should be valid', () {
      final normalized = normalizePhoneNumber('081234567890');
      expect(normalizePhoneNumber.isValid(normalized), true);
    });

    test('normalized number from 812 should be valid', () {
      final normalized = normalizePhoneNumber('8123456789');
      expect(normalizePhoneNumber.isValid(normalized), true);
    });

    test('normalized number from +62812 should be valid', () {
      final normalized = normalizePhoneNumber('+628123456789');
      expect(normalizePhoneNumber.isValid(normalized), true);
    });

    test(
      'normalized number from non-Indonesian should be invalid if too short',
      () {
        // Test with 9 digits - becomes 62123456789 (11 digits) which IS valid
        final normalized9 = normalizePhoneNumber('123456789');
        expect(normalizePhoneNumber.isValid(normalized9), true);

        // Test with 8 digits - becomes 6212345678 (10 digits) which IS valid
        final normalized8 = normalizePhoneNumber('12345678');
        expect(normalizePhoneNumber.isValid(normalized8), true);

        // Test with 7 digits - becomes 621234567 (9 digits) which is NOT valid
        final veryShortNormalized = normalizePhoneNumber('1234567');
        expect(normalizePhoneNumber.isValid(veryShortNormalized), false);
      },
    );
  });
}
