import 'package:flutter_test/flutter_test.dart';
import 'package:wasap/data/services/phone_normalizer.dart';
import 'package:wasap/domain/entities/phone_number.dart';
import 'package:wasap/domain/usecases/normalize_phone_number.dart';

void main() {
  group('PhoneNormalizerService', () {
    late PhoneNormalizerService service;

    setUp(() {
      service = PhoneNormalizerService();
    });

    group('normalize', () {
      test('normalizes phone number starting with 0', () {
        final result = service.normalize('081234567890');
        expect(result.value, '6281234567890');
      });

      test('normalizes phone number starting with 8', () {
        final result = service.normalize('8123456789');
        expect(result.value, '628123456789');
      });

      test('normalizes phone number starting with 62', () {
        final result = service.normalize('628123456789');
        expect(result.value, '628123456789');
      });

      test('normalizes phone number with +62', () {
        final result = service.normalize('+628123456789');
        expect(result.value, '628123456789');
      });

      test('normalizes phone number with spaces', () {
        final result = service.normalize('0812 345 6789');
        expect(result.value, '628123456789');
      });

      test('normalizes phone number with dashes', () {
        final result = service.normalize('0812-345-6789');
        expect(result.value, '628123456789');
      });

      test('returns empty string for empty input', () {
        final result = service.normalize('');
        expect(result.value, '');
      });

      test('returns empty string for non-digit input', () {
        final result = service.normalize('abc-def');
        expect(result.value, '');
      });
    });

    group('isValid', () {
      test('returns true for valid phone number', () {
        final phoneNumber = PhoneNumber('628123456789');
        expect(service.isValid(phoneNumber), true);
      });

      test('returns false for invalid phone number', () {
        final phoneNumber = PhoneNumber('812345678');
        expect(service.isValid(phoneNumber), false);
      });

      test('returns false for empty phone number', () {
        final phoneNumber = PhoneNumber('');
        expect(service.isValid(phoneNumber), false);
      });

      test('returns false for short phone number', () {
        final phoneNumber = PhoneNumber('628123456');
        expect(service.isValid(phoneNumber), false);
      });
    });

    group('isValidInput', () {
      test(
        'returns true for valid input that produces valid normalized number',
        () {
          expect(service.isValidInput('081234567890'), true);
          expect(service.isValidInput('8123456789'), true);
          expect(service.isValidInput('628123456789'), true);
          expect(service.isValidInput('+628123456789'), true);
        },
      );

      test(
        'returns false for invalid input that produces invalid normalized number',
        () {
          expect(service.isValidInput(''), false);
          expect(
            service.isValidInput(
              '1234567',
            ), // 7 digits becomes 621234567 (9 digits) - invalid
            false,
          );
          expect(service.isValidInput('abc'), false);
        },
      );
    });

    group('with custom NormalizePhoneNumber', () {
      test('uses injected NormalizePhoneNumber', () {
        final customNormalizer = NormalizePhoneNumber();
        final customService = PhoneNormalizerService(
          normalizeUseCase: customNormalizer,
        );

        final result = customService.normalize('081234567890');
        expect(result.value, '6281234567890');
      });
    });
  });
}
