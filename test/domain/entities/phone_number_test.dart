import 'package:flutter_test/flutter_test.dart';
import 'package:wasap/domain/entities/phone_number.dart';

void main() {
  group('PhoneNumber', () {
    group('constructor', () {
      test('creates PhoneNumber with given value', () {
        const phoneNumber = PhoneNumber('628123456789');
        expect(phoneNumber.value, '628123456789');
      });

      test('creates empty PhoneNumber', () {
        const phoneNumber = PhoneNumber('');
        expect(phoneNumber.value, '');
      });
    });

    group('isValid', () {
      test('returns true for valid 62-prefixed number with 10+ digits', () {
        const phoneNumber = PhoneNumber('628123456789');
        expect(phoneNumber.isValid, true);
      });

      test('returns true for valid 12-digit number starting with 62', () {
        const phoneNumber = PhoneNumber('6281234567890');
        expect(phoneNumber.isValid, true);
      });

      test('returns false for number less than 10 digits', () {
        const phoneNumber = PhoneNumber('628123456');
        expect(phoneNumber.isValid, false);
      });

      test('returns false for number not starting with 62', () {
        const phoneNumber = PhoneNumber('81234567890');
        expect(phoneNumber.isValid, false);
      });

      test('returns false for empty number', () {
        const phoneNumber = PhoneNumber('');
        expect(phoneNumber.isValid, false);
      });

      test('returns false for number starting with +62', () {
        const phoneNumber = PhoneNumber('+628123456789');
        expect(phoneNumber.isValid, false);
      });

      test('returns false for number starting with 0', () {
        const phoneNumber = PhoneNumber('081234567890');
        expect(phoneNumber.isValid, false);
      });
    });

    group('toWhatsAppUrl', () {
      test('returns correct URL without message', () {
        const phoneNumber = PhoneNumber('628123456789');
        expect(phoneNumber.toWhatsAppUrl(), 'https://wa.me/628123456789');
      });

      test('returns correct URL with message', () {
        const phoneNumber = PhoneNumber('628123456789');
        final url = phoneNumber.toWhatsAppUrl(message: 'Hello');
        expect(url, 'https://wa.me/628123456789?text=Hello');
      });

      test('encodes special characters in message', () {
        const phoneNumber = PhoneNumber('628123456789');
        final url = phoneNumber.toWhatsAppUrl(message: 'Hello & Goodbye');
        expect(url, 'https://wa.me/628123456789?text=Hello%20%26%20Goodbye');
      });

      test('returns URL for invalid number', () {
        const phoneNumber = PhoneNumber('812345678');
        expect(phoneNumber.toWhatsAppUrl(), 'https://wa.me/812345678');
      });

      test('returns empty URL for empty number', () {
        const phoneNumber = PhoneNumber('');
        expect(phoneNumber.toWhatsAppUrl(), 'https://wa.me/');
      });
    });

    group('equality', () {
      test('two PhoneNumbers with same value are equal', () {
        const phoneNumber1 = PhoneNumber('628123456789');
        const phoneNumber2 = PhoneNumber('628123456789');
        expect(phoneNumber1, equals(phoneNumber2));
      });

      test('two PhoneNumbers with different values are not equal', () {
        const phoneNumber1 = PhoneNumber('628123456789');
        const phoneNumber2 = PhoneNumber('628123456788');
        expect(phoneNumber1, isNot(equals(phoneNumber2)));
      });

      test('same instance is equal to itself', () {
        const phoneNumber = PhoneNumber('628123456789');
        expect(phoneNumber, equals(phoneNumber));
      });
    });

    group('hashCode', () {
      test('two equal PhoneNumbers have same hashCode', () {
        const phoneNumber1 = PhoneNumber('628123456789');
        const phoneNumber2 = PhoneNumber('628123456789');
        expect(phoneNumber1.hashCode, equals(phoneNumber2.hashCode));
      });
    });

    group('toString', () {
      test('returns correct string representation', () {
        const phoneNumber = PhoneNumber('628123456789');
        expect(phoneNumber.toString(), 'PhoneNumber(628123456789)');
      });
    });
  });
}
