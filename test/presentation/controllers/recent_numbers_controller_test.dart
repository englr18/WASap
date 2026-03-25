import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasap/domain/entities/recent_number.dart';
import 'package:wasap/domain/repositories/phone_repository.dart';
import 'package:wasap/presentation/controllers/recent_numbers_controller.dart';

class MockPhoneRepository extends Mock implements PhoneRepository {}

void main() {
  group('RecentNumbersController', () {
    late RecentNumbersController controller;
    late MockPhoneRepository mockRepository;

    setUp(() {
      mockRepository = MockPhoneRepository();
    });

    group('initialization', () {
      test('loads recent numbers on initialization', () async {
        final recentNumbers = [
          RecentNumber.create('628123456789'),
          RecentNumber.create('628123456788'),
        ];

        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => recentNumbers);

        controller = RecentNumbersController(mockRepository);

        // Wait for async initialization
        await Future.delayed(const Duration(milliseconds: 10));

        verify(() => mockRepository.getRecentNumbers()).called(1);
      });

      test('sets isLoading to false after loading', () async {
        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => []);

        controller = RecentNumbersController(mockRepository);

        // Wait for async initialization
        await Future.delayed(const Duration(milliseconds: 10));

        expect(controller.state.isLoading, false);
      });

      test('sets recent numbers from repository', () async {
        final recentNumbers = [RecentNumber.create('628123456789')];

        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => recentNumbers);

        controller = RecentNumbersController(mockRepository);

        // Wait for async initialization
        await Future.delayed(const Duration(milliseconds: 10));

        expect(controller.state.recentNumbers, recentNumbers);
      });

      test('handles empty list from repository', () async {
        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => []);

        controller = RecentNumbersController(mockRepository);

        // Wait for async initialization
        await Future.delayed(const Duration(milliseconds: 10));

        expect(controller.state.recentNumbers, isEmpty);
      });
    });

    group('addRecentNumber', () {
      test('calls repository addRecentNumber', () async {
        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => []);
        when(
          () => mockRepository.addRecentNumber(any()),
        ).thenAnswer((_) async {});

        controller = RecentNumbersController(mockRepository);
        await Future.delayed(const Duration(milliseconds: 10));

        await controller.addRecentNumber('628123456789');

        verify(() => mockRepository.addRecentNumber('628123456789')).called(1);
      });

      test('reloads recent numbers after adding', () async {
        final newRecentNumbers = [RecentNumber.create('628123456789')];

        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => []);
        when(
          () => mockRepository.addRecentNumber(any()),
        ).thenAnswer((_) async {});

        controller = RecentNumbersController(mockRepository);
        await Future.delayed(const Duration(milliseconds: 10));

        // Reset the mock to return new numbers
        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => newRecentNumbers);

        await controller.addRecentNumber('628123456789');

        // getRecentNumbers should be called at least twice - once on init, once after add
        verifyInOrder([
          () => mockRepository.getRecentNumbers(),
          () => mockRepository.getRecentNumbers(),
        ]);
      });
    });

    group('clearRecentNumbers', () {
      test('calls repository clearRecentNumbers', () async {
        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => []);
        when(
          () => mockRepository.clearRecentNumbers(),
        ).thenAnswer((_) async {});

        controller = RecentNumbersController(mockRepository);
        await Future.delayed(const Duration(milliseconds: 10));

        await controller.clearRecentNumbers();

        verify(() => mockRepository.clearRecentNumbers()).called(1);
      });

      test('clears local state after clearing', () async {
        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => [RecentNumber.create('628123456789')]);
        when(
          () => mockRepository.clearRecentNumbers(),
        ).thenAnswer((_) async {});

        controller = RecentNumbersController(mockRepository);
        await Future.delayed(const Duration(milliseconds: 10));

        await controller.clearRecentNumbers();

        expect(controller.state.recentNumbers, isEmpty);
      });
    });

    group('refresh', () {
      test('reloads recent numbers from repository', () async {
        final newRecentNumbers = [
          RecentNumber.create('628123456789'),
          RecentNumber.create('628123456788'),
        ];

        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => []);

        controller = RecentNumbersController(mockRepository);
        await Future.delayed(const Duration(milliseconds: 10));

        when(
          () => mockRepository.getRecentNumbers(),
        ).thenAnswer((_) async => newRecentNumbers);

        await controller.refresh();

        expect(controller.state.recentNumbers, newRecentNumbers);
      });
    });
  });

  group('RecentNumbersState', () {
    test('default constructor creates empty state', () {
      const state = RecentNumbersState();

      expect(state.recentNumbers, isEmpty);
      expect(state.isLoading, true);
    });

    test('constructor accepts all parameters', () {
      const state = RecentNumbersState(recentNumbers: [], isLoading: false);

      expect(state.recentNumbers, isEmpty);
      expect(state.isLoading, false);
    });

    test('copyWith returns new instance with updated values', () {
      final recentNumbers = [RecentNumber.create('628123456789')];
      const original = RecentNumbersState(isLoading: true);
      final copied = original.copyWith(
        recentNumbers: recentNumbers,
        isLoading: false,
      );

      expect(copied.recentNumbers, recentNumbers);
      expect(copied.isLoading, false);
    });

    test('copyWith preserves values not specified', () {
      final recentNumbers = [RecentNumber.create('628123456789')];
      final original = RecentNumbersState(
        recentNumbers: recentNumbers,
        isLoading: false,
      );
      final copied = original.copyWith(isLoading: true);

      expect(copied.recentNumbers, recentNumbers);
      expect(copied.isLoading, true);
    });
  });
}
