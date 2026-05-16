import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/core/models/profile.dart';
import 'package:living_way/core/services/cache_service.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import '../helpers/api_test_helpers.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('ProfileController', () {
    test('loads cached profile on init', () async {
      final profile = sampleProfileJson();
      await CacheService.instance
          .writeData('profile', json.encode(profile));

      final dio = createMockApiDio(routes: {
        '/profile': MockResponse(
          statusCode: 200,
          data: {'data': profile},
        ),
      });

      final controller = ProfileController(dio: dio);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(controller.userProfile?.firstName, 'John');
    });

    test('syncProfile updates profile from API', () async {
      final updated = sampleProfileJson(firstName: 'Updated');
      final dio = createMockApiDio(routes: {
        '/profile': MockResponse(
          statusCode: 200,
          data: {'data': updated},
        ),
      });

      final controller = ProfileController(dio: dio);
      final result = await controller.syncProfile(
        Profile.fromJson(sampleProfileJson()),
      );

      expect(result?.firstName, 'Updated');
    });

    test('prayer time management persists to cache', () async {
      final controller = ProfileController(dio: createMockApiDio());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      controller.addPrayerTime(const TimeOfDay(hour: 7, minute: 30));
      expect(controller.prayerTimes, hasLength(2));

      controller.editPrayerTime(const TimeOfDay(hour: 8, minute: 0), 0);
      expect(controller.prayerTimes.first.hour, 8);

      controller.removePrayerTime(1);
      expect(controller.prayerTimes, hasLength(1));

      final reminders = await CacheService.instance.readData<List<String>>(
        'reminders',
        defaultValue: [],
      );
      expect(reminders, isNotEmpty);
    });

    test('setWillReceiveNotification persists preference', () async {
      final controller = ProfileController(dio: createMockApiDio());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      controller.setWillReceiveNotification = false;

      final value = await CacheService.instance.readData<bool>(
        'willReceiveNotification',
        defaultValue: true,
      );
      expect(value, isFalse);
    });

    test('deleteProfile calls API', () async {
      final dio = createMockApiDio(routes: {
        '/profile/delete': MockResponse(statusCode: 200, data: {}),
      });

      final controller = ProfileController(dio: dio)
        ..userProfile = Profile.fromJson(sampleProfileJson());

      await controller.deleteProfile();
    });
  });
}
