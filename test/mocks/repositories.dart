import 'package:mocktail/mocktail.dart';
import 'package:wasap/domain/entities/app_settings.dart';
import 'package:wasap/domain/entities/recent_number.dart';
import 'package:wasap/domain/repositories/phone_repository.dart';
import 'package:wasap/domain/repositories/whatsapp_repository.dart';

/// Mock implementation of [WhatsAppRepository] for testing.
class MockWhatsAppRepository extends Mock implements WhatsAppRepository {}

/// Mock implementation of [PhoneRepository] for testing.
class MockPhoneRepository extends Mock implements PhoneRepository {}

/// Fake implementations for mocktail registerFallbackValue.

class FakeAppSettings extends Fake implements AppSettings {}

class FakeRecentNumber extends Fake implements RecentNumber {}

/// Registers all fallback values for mocktail.
void registerFallbackValues() {
  registerFallbackValue(FakeAppSettings());
  registerFallbackValue(FakeRecentNumber());
}
