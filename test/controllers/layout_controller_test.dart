import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/layout_controller.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('LayoutController', () {
    late LayoutController controller;

    setUp(() {
      controller = LayoutController();
    });

    test('defaults to bible navigation', () {
      expect(
        controller.getSelectedHomePageNavigation,
        HomePageNavigation.bible,
      );
    });

    test('showSplashScreen starts true', () {
      expect(controller.showSplashScreen, isTrue);
    });

    test('settingsNavigation has expected routes', () {
      expect(controller.settingsNavigation, hasLength(5));
      expect(controller.settingsNavigation.first['route'], '/settings');
    });

    test('setSelectedHomePageNavigation updates selection', () {
      controller.setSelectedHomePageNavigation = HomePageNavigation.home;
      expect(
        controller.getSelectedHomePageNavigation,
        HomePageNavigation.home,
      );
    });

    test('setIntroPageIndex updates index', () {
      controller.setIntroPageIndex = 2;
      expect(controller.initialIntroductionPageIndex, 2);
    });

    test('setShowVerseOfTheDayControls updates flag', () {
      controller.setShowVerseOfTheDayControls = false;
      expect(controller.showVerseOfTheDayControls, isFalse);
    });

    test('selectedHomeScreen returns widget for navigation', () {
      controller.setSelectedHomePageNavigation = HomePageNavigation.library;
      expect(controller.selectedHomeScreen, isNotNull);
    });

    test('notifies listeners on navigation change', () {
      var notified = false;
      controller.addListener(() => notified = true);
      controller.setSelectedHomePageNavigation = HomePageNavigation.activity;
      expect(notified, isTrue);
    });
  });
}
