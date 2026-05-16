import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/enums.dart';
import 'package:living_way/core/services/cache_service.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('ThemeController', () {
    late ThemeController controller;

    setUp(() async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      await CacheService.instance.writeData('textSize', 0.3);
      await CacheService.instance.writeData('locale', 0);
      await CacheService.instance.writeData('brightness', 1);
      await CacheService.instance.writeData('font', 5);
      controller = ThemeController();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });

    test('initializes with persisted values', () async {
      final brightnessIndex = await CacheService.instance.readData<int>(
        'brightness',
        defaultValue: -1,
      );
      expect(brightnessIndex, 1);
      expect(controller.textSize, 0.3);
      expect(controller.appLocale, AppLocale.en);
      expect(controller.brightness, Brightness.values[brightnessIndex]);
      expect(controller.selectedFont, Fonts.RobotoSlab);
    });

    test('setTextSize updates textSize', () {
      controller.setTextSize = 0.5;
      expect(controller.textSize, 0.5);
    });

    test('setFont updates selectedFont', () {
      controller.setFont = Fonts.Quicksand;
      expect(controller.selectedFont, Fonts.Quicksand);
    });

    test('toggleAppLocale switches between en and am', () {
      expect(controller.appLocale, AppLocale.en);
      controller.toggleAppLocale();
      expect(controller.appLocale, AppLocale.am);
      controller.toggleAppLocale();
      expect(controller.appLocale, AppLocale.en);
    });

    test('toggleBrightness switches between light and dark', () {
      final initial = controller.brightness;
      controller.toggleBrightness();
      expect(controller.brightness, isNot(initial));
      controller.toggleBrightness();
      expect(controller.brightness, initial);
    });

    test('notifies listeners on changes', () {
      var notified = false;
      controller.addListener(() => notified = true);
      controller.setTextSize = 0.4;
      expect(notified, isTrue);
    });
  });
}
