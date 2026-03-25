import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasap/domain/entities/phone_number.dart';
import 'package:wasap/domain/repositories/whatsapp_repository.dart';
import 'package:wasap/domain/usecases/launch_whatsapp.dart';

class MockWhatsAppRepository extends Mock implements WhatsAppRepository {}

void main() {
  late LaunchWhatsApp launchWhatsApp;
  late MockWhatsAppRepository mockRepository;

  setUp(() {
    mockRepository = MockWhatsAppRepository();
    launchWhatsApp = LaunchWhatsApp(mockRepository);
  });

  group('LaunchWhatsApp', () {
    group('call', () {
      test('returns LaunchSuccess when repository returns success', () async {
        // Arrange
        const phoneNumber = PhoneNumber('628123456789');
        when(
          () => mockRepository.launchWhatsApp(
            '628123456789',
            message: any(named: 'message'),
          ),
        ).thenAnswer((_) async => const LaunchSuccess());

        // Act
        final result = await launchWhatsApp(phoneNumber);

        // Assert
        expect(result, isA<LaunchSuccess>());
        verify(
          () => mockRepository.launchWhatsApp(
            '628123456789',
            message: any(named: 'message'),
          ),
        ).called(1);
      });

      test('returns LaunchFailure when repository returns failure', () async {
        // Arrange
        const phoneNumber = PhoneNumber('628123456789');
        when(
          () => mockRepository.launchWhatsApp(
            '628123456789',
            message: any(named: 'message'),
          ),
        ).thenAnswer(
          (_) async => const LaunchFailure('WhatsApp not installed'),
        );

        // Act
        final result = await launchWhatsApp(phoneNumber);

        // Assert
        expect(result, isA<LaunchFailure>());
        expect((result as LaunchFailure).message, 'WhatsApp not installed');
      });

      test('returns LaunchFailure for invalid phone number', () async {
        // Arrange
        const phoneNumber = PhoneNumber(
          '812345678',
        ); // Invalid - not 62-prefixed

        // Act
        final result = await launchWhatsApp(phoneNumber);

        // Assert
        expect(result, isA<LaunchFailure>());
        expect((result as LaunchFailure).message, 'Invalid phone number');
        verifyNever(
          () => mockRepository.launchWhatsApp(
            any(),
            message: any(named: 'message'),
          ),
        );
      });

      test('returns LaunchFailure for empty phone number', () async {
        // Arrange
        const phoneNumber = PhoneNumber(''); // Invalid - empty

        // Act
        final result = await launchWhatsApp(phoneNumber);

        // Assert
        expect(result, isA<LaunchFailure>());
        expect((result as LaunchFailure).message, 'Invalid phone number');
      });

      test('passes message parameter to repository', () async {
        // Arrange
        const phoneNumber = PhoneNumber('628123456789');
        const testMessage = 'Hello, this is a test message';
        when(
          () => mockRepository.launchWhatsApp(
            '628123456789',
            message: testMessage,
          ),
        ).thenAnswer((_) async => const LaunchSuccess());

        // Act
        final result = await launchWhatsApp(phoneNumber, message: testMessage);

        // Assert
        expect(result, isA<LaunchSuccess>());
        verify(
          () => mockRepository.launchWhatsApp(
            '628123456789',
            message: testMessage,
          ),
        ).called(1);
      });

      test('validates phone number before calling repository', () async {
        // Arrange
        const phoneNumber = PhoneNumber('628123456'); // Only 9 digits - invalid

        // Act
        final result = await launchWhatsApp(phoneNumber);

        // Assert
        expect(result, isA<LaunchFailure>());
        verifyNever(
          () => mockRepository.launchWhatsApp(
            any(),
            message: any(named: 'message'),
          ),
        );
      });
    });

    group('isWhatsAppInstalled', () {
      test('returns true when WhatsApp is installed', () async {
        // Arrange
        when(
          () => mockRepository.isWhatsAppInstalled(),
        ).thenAnswer((_) async => true);

        // Act
        final result = await launchWhatsApp.isWhatsAppInstalled();

        // Assert
        expect(result, true);
        verify(() => mockRepository.isWhatsAppInstalled()).called(1);
      });

      test('returns false when WhatsApp is not installed', () async {
        // Arrange
        when(
          () => mockRepository.isWhatsAppInstalled(),
        ).thenAnswer((_) async => false);

        // Act
        final result = await launchWhatsApp.isWhatsAppInstalled();

        // Assert
        expect(result, false);
        verify(() => mockRepository.isWhatsAppInstalled()).called(1);
      });
    });
  });

  group('LaunchResult', () {
    test('LaunchSuccess is equal to another LaunchSuccess', () {
      const result1 = LaunchSuccess();
      const result2 = LaunchSuccess();
      expect(result1, equals(result2));
    });

    test('LaunchFailure with same message are equal', () {
      const result1 = LaunchFailure('Error');
      const result2 = LaunchFailure('Error');
      expect(result1, equals(result2));
    });

    test('LaunchFailure with different messages are not equal', () {
      const result1 = LaunchFailure('Error 1');
      const result2 = LaunchFailure('Error 2');
      expect(result1, isNot(equals(result2)));
    });

    test('LaunchSuccess is not equal to LaunchFailure', () {
      const result1 = LaunchSuccess();
      const result2 = LaunchFailure('Error');
      expect(result1, isNot(equals(result2)));
    });
  });
}
