import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasap/domain/entities/phone_number.dart';
import 'package:wasap/domain/repositories/whatsapp_repository.dart';
import 'package:wasap/domain/usecases/launch_whatsapp.dart';
import 'package:wasap/presentation/controllers/phone_controller.dart';

class MockLaunchWhatsApp extends Mock implements LaunchWhatsApp {}

class FakePhoneNumber extends Fake implements PhoneNumber {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePhoneNumber());
  });

  group('PhoneController', () {
    late PhoneController controller;
    late MockLaunchWhatsApp mockLaunchWhatsApp;

    setUp(() {
      mockLaunchWhatsApp = MockLaunchWhatsApp();
      controller = PhoneController(launchWhatsApp: mockLaunchWhatsApp);
    });

    group('initial state', () {
      test('has empty input', () {
        expect(controller.state.input, '');
      });

      test('has null normalized', () {
        expect(controller.state.normalized, null);
      });

      test('is not valid', () {
        expect(controller.state.isValid, false);
      });

      test('is not loading', () {
        expect(controller.state.isLoading, false);
      });

      test('has no error', () {
        expect(controller.state.error, null);
      });
    });

    group('updateInput', () {
      test('updates input and normalizes phone number', () {
        controller.updateInput('081234567890');

        expect(controller.state.input, '081234567890');
        expect(controller.state.normalized?.value, '6281234567890');
        expect(controller.state.isValid, true);
      });

      test('updates input with 8-prefixed number', () {
        controller.updateInput('8123456789');

        expect(controller.state.input, '8123456789');
        expect(controller.state.normalized?.value, '628123456789');
        expect(controller.state.isValid, true);
      });

      test('updates input with 62-prefixed number', () {
        controller.updateInput('628123456789');

        expect(controller.state.input, '628123456789');
        expect(controller.state.normalized?.value, '628123456789');
        expect(controller.state.isValid, true);
      });

      test('handles empty input', () {
        controller.updateInput('');

        expect(controller.state.input, '');
        expect(controller.state.normalized?.value, '');
        expect(controller.state.isValid, false);
      });

      test('handles invalid input that becomes too short', () {
        controller.updateInput('123');

        expect(controller.state.input, '123');
        expect(
          controller.state.normalized?.value,
          '62123',
        ); // Gets 62 prepended
        expect(controller.state.isValid, false); // But too short
      });

      test('clears previous loading and error state', () {
        // First set some state
        controller.updateInput('081234567890');

        // Then update again
        controller.updateInput('8123456789');

        expect(controller.state.isLoading, false);
        expect(controller.state.error, null);
      });
    });

    group('clearInput', () {
      test('resets state to initial values', () {
        controller.updateInput('081234567890');
        controller.clearInput();

        expect(controller.state.input, '');
        expect(controller.state.normalized, null);
        expect(controller.state.isValid, false);
        expect(controller.state.isLoading, false);
        expect(controller.state.error, null);
      });
    });

    group('launchWhatsApp', () {
      test('calls launchWhatsApp use case with valid number', () async {
        controller.updateInput('081234567890');
        when(
          () => mockLaunchWhatsApp(any(), message: any(named: 'message')),
        ).thenAnswer((_) async => const LaunchSuccess());

        await controller.launchWhatsApp();

        verify(
          () => mockLaunchWhatsApp(any(), message: any(named: 'message')),
        ).called(1);
      });

      test('sets loading state while launching', () async {
        controller.updateInput('081234567890');

        // Create a delayed future to test loading state
        when(
          () => mockLaunchWhatsApp(any(), message: any(named: 'message')),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return const LaunchSuccess();
        });

        final future = controller.launchWhatsApp();

        // At this point loading should be true
        expect(controller.state.isLoading, true);

        await future;

        // After completion, loading should be false
        expect(controller.state.isLoading, false);
      });

      test('sets error state when launch fails', () async {
        controller.updateInput('081234567890');
        when(
          () => mockLaunchWhatsApp(any(), message: any(named: 'message')),
        ).thenAnswer(
          (_) async => const LaunchFailure('WhatsApp not installed'),
        );

        await controller.launchWhatsApp();

        expect(controller.state.error, 'WhatsApp not installed');
        expect(controller.state.isLoading, false);
      });

      test('does not launch when number is invalid', () async {
        controller.updateInput('123');

        await controller.launchWhatsApp();

        expect(controller.state.error, 'Invalid phone number');
        verifyNever(
          () => mockLaunchWhatsApp(any(), message: any(named: 'message')),
        );
      });

      test('does not launch when normalized is null', () async {
        // Controller starts with null normalized
        await controller.launchWhatsApp();

        expect(controller.state.error, 'Invalid phone number');
        verifyNever(
          () => mockLaunchWhatsApp(any(), message: any(named: 'message')),
        );
      });

      test('passes message parameter to use case', () async {
        controller.updateInput('081234567890');
        const testMessage = 'Hello there!';
        when(
          () => mockLaunchWhatsApp(any(), message: testMessage),
        ).thenAnswer((_) async => const LaunchSuccess());

        await controller.launchWhatsApp(message: testMessage);

        verify(() => mockLaunchWhatsApp(any(), message: testMessage)).called(1);
      });

      test('clears error on successful launch', () async {
        // First trigger an error
        controller.updateInput('123');
        await controller.launchWhatsApp();
        expect(controller.state.error, 'Invalid phone number');

        // Then update to valid and launch
        controller.updateInput('081234567890');
        when(
          () => mockLaunchWhatsApp(any(), message: any(named: 'message')),
        ).thenAnswer((_) async => const LaunchSuccess());

        await controller.launchWhatsApp();

        expect(controller.state.error, null);
      });
    });

    group('clearError', () {
      test('clears error state', () {
        controller.updateInput('123');
        // Error is set when trying to launch with invalid number
        // Let's set it directly
        controller.state = controller.state.copyWith(error: 'Some error');

        controller.clearError();

        expect(controller.state.error, null);
      });
    });

    group('copyWith', () {
      test('creates copy with updated values', () {
        final newState = controller.state.copyWith(
          input: 'test',
          isLoading: true,
        );

        expect(newState.input, 'test');
        expect(newState.isLoading, true);
        expect(newState.isValid, controller.state.isValid);
      });

      test('preserves values not specified', () {
        controller.updateInput('081234567890');
        final newState = controller.state.copyWith(isLoading: true);

        expect(newState.input, '081234567890');
        expect(newState.normalized, controller.state.normalized);
        expect(newState.isValid, controller.state.isValid);
      });

      test('setting error to null clears error', () {
        controller.state = controller.state.copyWith(error: 'Some error');
        final newState = controller.state.copyWith(error: null);

        expect(newState.error, null);
      });
    });
  });

  group('PhoneState', () {
    test('default constructor creates empty state', () {
      const state = PhoneState();

      expect(state.input, '');
      expect(state.normalized, null);
      expect(state.isValid, false);
      expect(state.isLoading, false);
      expect(state.error, null);
    });

    test('constructor accepts all parameters', () {
      const phoneNumber = PhoneNumber('628123456789');
      const state = PhoneState(
        input: '081234567890',
        normalized: phoneNumber,
        isValid: true,
        isLoading: true,
        error: 'Error',
      );

      expect(state.input, '081234567890');
      expect(state.normalized, phoneNumber);
      expect(state.isValid, true);
      expect(state.isLoading, true);
      expect(state.error, 'Error');
    });
  });
}
