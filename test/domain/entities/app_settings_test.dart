import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasap/domain/entities/app_settings.dart';

void main() {
  group('AppSettings', () {
    group('constructor', () {
      test('creates AppSettings with default values', () {
        const settings = AppSettings();
        expect(settings.themeMode, ThemeMode.light);
        expect(settings.locale, const Locale('en'));
      });

      test('creates AppSettings with given values', () {
        const settings = AppSettings(
          themeMode: ThemeMode.dark,
          locale: Locale('id'),
        );
        expect(settings.themeMode, ThemeMode.dark);
        expect(settings.locale, const Locale('id'));
      });
    });

    group('copyWith', () {
      test('returns same settings when no parameters provided', () {
        const settings = AppSettings();
        final copied = settings.copyWith();

        expect(copied.themeMode, settings.themeMode);
        expect(copied.locale, settings.locale);
      });

      test('returns new settings with updated themeMode', () {
        const settings = AppSettings();
        final copied = settings.copyWith(themeMode: ThemeMode.dark);

        expect(copied.themeMode, ThemeMode.dark);
        expect(copied.locale, settings.locale);
      });

      test('returns new settings with updated locale', () {
        const settings = AppSettings();
        final copied = settings.copyWith(locale: const Locale('id'));

        expect(copied.locale, const Locale('id'));
        expect(copied.themeMode, settings.themeMode);
      });

      test('returns new settings with both values updated', () {
        const settings = AppSettings();
        final copied = settings.copyWith(
          themeMode: ThemeMode.system,
          locale: const Locale('id'),
        );

        expect(copied.themeMode, ThemeMode.system);
        expect(copied.locale, const Locale('id'));
      });

      test('does not modify original settings', () {
        const settings = AppSettings();
        settings.copyWith(themeMode: ThemeMode.dark);

        expect(settings.themeMode, ThemeMode.light);
      });
    });

    group('equality', () {
      test('two AppSettings with same values are equal', () {
        const settings1 = AppSettings(
          themeMode: ThemeMode.dark,
          locale: Locale('id'),
        );
        const settings2 = AppSettings(
          themeMode: ThemeMode.dark,
          locale: Locale('id'),
        );
        expect(settings1, equals(settings2));
      });

      test('two AppSettings with different themeMode are not equal', () {
        const settings1 = AppSettings(themeMode: ThemeMode.light);
        const settings2 = AppSettings(themeMode: ThemeMode.dark);
        expect(settings1, isNot(equals(settings2)));
      });

      test('two AppSettings with different locale are not equal', () {
        const settings1 = AppSettings(locale: Locale('en'));
        const settings2 = AppSettings(locale: Locale('id'));
        expect(settings1, isNot(equals(settings2)));
      });
    });

    group('hashCode', () {
      test('two equal AppSettings have same hashCode', () {
        const settings1 = AppSettings(
          themeMode: ThemeMode.dark,
          locale: Locale('id'),
        );
        const settings2 = AppSettings(
          themeMode: ThemeMode.dark,
          locale: Locale('id'),
        );
        expect(settings1.hashCode, equals(settings2.hashCode));
      });
    });

    group('toString', () {
      test('returns correct string representation', () {
        const settings = AppSettings();
        expect(settings.toString(), contains('AppSettings'));
        expect(settings.toString(), contains('themeMode'));
        expect(settings.toString(), contains('locale'));
      });
    });
  });
}
