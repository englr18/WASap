import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasap/data/services/recent_numbers_storage.dart';

void main() {
  group('RecentNumbersStorageService', () {
    late RecentNumbersStorageService service;
    late SharedPreferences prefs;

    setUp(() async {
      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      service = RecentNumbersStorageService(prefs);
    });

    group('addRecentNumber', () {
      test('adds a new phone number to empty list', () async {
        await service.addRecentNumber('628123456789');

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers.length, 1);
        expect(recentNumbers.first.phoneNumber, '628123456789');
      });

      test('adds multiple numbers in order', () async {
        await service.addRecentNumber('628123456789');
        await service.addRecentNumber('628123456788');
        await service.addRecentNumber('628123456787');

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers.length, 3);
        expect(
          recentNumbers[0].phoneNumber,
          '628123456787',
        ); // Most recent first
        expect(recentNumbers[1].phoneNumber, '628123456788');
        expect(recentNumbers[2].phoneNumber, '628123456789');
      });

      test('removes duplicate and moves to front', () async {
        await service.addRecentNumber('628123456789');
        await service.addRecentNumber('628123456788');
        await service.addRecentNumber('628123456789'); // Duplicate

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers.length, 2);
        expect(recentNumbers[0].phoneNumber, '628123456789'); // Moved to front
        expect(recentNumbers[1].phoneNumber, '628123456788');
      });

      test('keeps maximum of 20 entries (FIFO)', () async {
        // Add 21 numbers - ensure we have 20 unique numbers at the end
        final phoneNumbers = List.generate(
          21,
          (i) => '6281234567${i.toString().padLeft(2, '0')}',
        );
        for (final phoneNumber in phoneNumbers) {
          await service.addRecentNumber(phoneNumber);
        }

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers.length, 20);
        // First should be the most recent (21st addition)
        expect(recentNumbers[0].phoneNumber, '628123456720');
        // Last should be from index 1
        expect(recentNumbers[19].phoneNumber, '628123456701');
      });

      test('updates existing entry timestamp when re-adding', () async {
        await service.addRecentNumber('628123456789');
        final firstTimestamp =
            (await service.getRecentNumbers()).first.lastUsed;

        // Wait a bit to ensure different timestamp
        await Future.delayed(const Duration(milliseconds: 10));
        await service.addRecentNumber('628123456789');

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers.length, 1);
        expect(recentNumbers.first.lastUsed.isAfter(firstTimestamp), true);
      });
    });

    group('getRecentNumbers', () {
      test('returns empty list when no data', () async {
        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers, isEmpty);
      });

      test('returns stored numbers sorted by most recent first', () async {
        await service.addRecentNumber('628123456789');
        await service.addRecentNumber('628123456788');

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers[0].phoneNumber, '628123456788');
        expect(recentNumbers[1].phoneNumber, '628123456789');
      });

      test('handles corrupted data gracefully', () async {
        // Set corrupted data directly
        await prefs.setString('recent_numbers', 'not valid json');

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers, isEmpty);
      });

      test('handles null data', () async {
        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers, isEmpty);
      });
    });

    group('clearRecentNumbers', () {
      test('clears all recent numbers', () async {
        await service.addRecentNumber('628123456789');
        await service.addRecentNumber('628123456788');

        await service.clearRecentNumbers();

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers, isEmpty);
      });

      test('works on empty storage', () async {
        await service.clearRecentNumbers();

        final recentNumbers = await service.getRecentNumbers();
        expect(recentNumbers, isEmpty);
      });
    });

    group('persistence', () {
      test('data persists across service instances', () async {
        await service.addRecentNumber('628123456789');

        // Create new service instance with same SharedPreferences
        final newService = RecentNumbersStorageService(prefs);
        final recentNumbers = await newService.getRecentNumbers();

        expect(recentNumbers.length, 1);
        expect(recentNumbers.first.phoneNumber, '628123456789');
      });

      test('serializes RecentNumber correctly', () async {
        await service.addRecentNumber('628123456789');

        final jsonString = prefs.getString('recent_numbers');
        final jsonList = jsonDecode(jsonString!) as List<dynamic>;

        expect(jsonList.length, 1);
        expect(jsonList[0]['phoneNumber'], '628123456789');
        expect(jsonList[0]['lastUsed'], isA<String>());
      });
    });
  });
}
