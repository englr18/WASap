import 'package:flutter_test/flutter_test.dart';
import 'package:wasap/domain/entities/recent_number.dart';

void main() {
  group('RecentNumber', () {
    group('constructor', () {
      test('creates RecentNumber with given phone number and lastUsed', () {
        final lastUsed = DateTime(2024, 1, 15, 10, 30);
        final recentNumber = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: lastUsed,
        );
        expect(recentNumber.phoneNumber, '628123456789');
        expect(recentNumber.lastUsed, lastUsed);
      });
    });

    group('create factory', () {
      test('creates RecentNumber with current timestamp', () {
        final before = DateTime.now();
        final recentNumber = RecentNumber.create('628123456789');
        final after = DateTime.now();

        expect(recentNumber.phoneNumber, '628123456789');
        // Allow for small timing differences
        expect(
          recentNumber.lastUsed.isAfter(
            before.subtract(const Duration(seconds: 1)),
          ),
          true,
        );
        expect(
          recentNumber.lastUsed.isBefore(after.add(const Duration(seconds: 1))),
          true,
        );
      });
    });

    group('fromJson', () {
      test('creates RecentNumber from valid JSON', () {
        final json = {
          'phoneNumber': '628123456789',
          'lastUsed': '2024-01-15T10:30:00.000',
        };
        final recentNumber = RecentNumber.fromJson(json);

        expect(recentNumber.phoneNumber, '628123456789');
        expect(recentNumber.lastUsed, DateTime(2024, 1, 15, 10, 30));
      });

      test('throws when JSON is invalid', () {
        final json = <String, dynamic>{};
        expect(() => RecentNumber.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('toJson', () {
      test('returns correct JSON map', () {
        final lastUsed = DateTime(2024, 1, 15, 10, 30);
        final recentNumber = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: lastUsed,
        );
        final json = recentNumber.toJson();

        expect(json['phoneNumber'], '628123456789');
        expect(json['lastUsed'], lastUsed.toIso8601String());
      });
    });

    group('displayString', () {
      test('formats 10-digit number correctly', () {
        final recentNumber = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: DateTime.now(),
        );
        // 628123456789 = +62 81 234 56789 (format: +62 XX XXX XXXX)
        expect(recentNumber.displayString, '+62 81 234 56789');
      });

      test('formats 11-digit number correctly', () {
        final recentNumber = RecentNumber(
          phoneNumber: '6281234567890',
          lastUsed: DateTime.now(),
        );
        // 6281234567890 = +62 81 234 567890 (format: +62 XX XXX XXXX)
        expect(recentNumber.displayString, '+62 81 234 567890');
      });

      test('returns raw value for number less than 10 digits', () {
        final recentNumber = RecentNumber(
          phoneNumber: '628123456',
          lastUsed: DateTime.now(),
        );
        expect(recentNumber.displayString, '628123456');
      });

      test('handles empty number', () {
        final recentNumber = RecentNumber(
          phoneNumber: '',
          lastUsed: DateTime.now(),
        );
        expect(recentNumber.displayString, '');
      });
    });

    group('isSameAs', () {
      test('returns true for same number', () {
        final recentNumber = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: DateTime.now(),
        );
        expect(recentNumber.isSameAs('628123456789'), true);
      });

      test('returns false for different number', () {
        final recentNumber = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: DateTime.now(),
        );
        expect(recentNumber.isSameAs('628123456788'), false);
      });
    });

    group('equality', () {
      test('two RecentNumbers with same values are equal', () {
        final lastUsed = DateTime(2024, 1, 15, 10, 30);
        final recentNumber1 = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: lastUsed,
        );
        final recentNumber2 = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: lastUsed,
        );
        expect(recentNumber1, equals(recentNumber2));
      });

      test('two RecentNumbers with different values are not equal', () {
        final recentNumber1 = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: DateTime(2024, 1, 15, 10, 30),
        );
        final recentNumber2 = RecentNumber(
          phoneNumber: '628123456788',
          lastUsed: DateTime(2024, 1, 15, 10, 30),
        );
        expect(recentNumber1, isNot(equals(recentNumber2)));
      });

      test('two RecentNumbers with different timestamps are not equal', () {
        final recentNumber1 = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: DateTime(2024, 1, 15, 10, 30),
        );
        final recentNumber2 = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: DateTime(2024, 1, 15, 10, 31),
        );
        expect(recentNumber1, isNot(equals(recentNumber2)));
      });
    });

    group('hashCode', () {
      test('two equal RecentNumbers have same hashCode', () {
        final lastUsed = DateTime(2024, 1, 15, 10, 30);
        final recentNumber1 = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: lastUsed,
        );
        final recentNumber2 = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: lastUsed,
        );
        expect(recentNumber1.hashCode, equals(recentNumber2.hashCode));
      });
    });

    group('toString', () {
      test('returns correct string representation', () {
        final lastUsed = DateTime(2024, 1, 15, 10, 30);
        final recentNumber = RecentNumber(
          phoneNumber: '628123456789',
          lastUsed: lastUsed,
        );
        expect(recentNumber.toString(), contains('RecentNumber'));
        expect(recentNumber.toString(), contains('628123456789'));
      });
    });
  });
}
