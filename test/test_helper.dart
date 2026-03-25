import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasap/domain/entities/app_settings.dart';
import 'package:wasap/domain/entities/phone_number.dart';
import 'package:wasap/domain/entities/recent_number.dart';
import 'package:wasap/domain/repositories/whatsapp_repository.dart';

/// Fake implementations for mocktail registerFallbackValue.
class FakePhoneNumber extends Fake implements PhoneNumber {}

class FakeAppSettings extends Fake implements AppSettings {}

class FakeRecentNumber extends Fake implements RecentNumber {}

class FakeLaunchResult extends Fake implements LaunchResult {}

/// Registers all fallback values for mocktail.
///
/// Call this in setUpAll() of your test files.
void registerTestFallbackValues() {
  registerFallbackValue(FakePhoneNumber());
  registerFallbackValue(FakeAppSettings());
  registerFallbackValue(FakeRecentNumber());
  registerFallbackValue(FakeLaunchResult());
  registerFallbackValue(ThemeMode.light);
  registerFallbackValue(const Locale('en'));
}

/// Test utilities for common operations.
class TestUtils {
  /// Creates a list of test phone numbers for various test scenarios.
  static List<String> get testPhoneNumbers => [
    '081234567890', // 0-prefixed
    '8123456789', // 8-prefixed
    '628123456789', // 62-prefixed
    '+628123456789', // +62 format
    '0812 345 6789', // with spaces
    '0812-345-6789', // with dashes
  ];

  /// Creates a list of invalid phone numbers for error testing.
  static List<String> get invalidPhoneNumbers => [
    '',
    'abc',
    '123',
    '123456789', // too short
  ];
}
