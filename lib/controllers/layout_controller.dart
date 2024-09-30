import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/screens/ActivityScreen/index.dart';
import 'package:living_way/screens/BibleScreen/index.dart';
import 'package:living_way/screens/DevotionScreen/index.dart';
import 'package:living_way/screens/profile_screen.dart';
import 'package:living_way/screens/testimonial_screen.dart';

enum HomePageNavigation {
  devotion,
  testimonial,
  bible,
  activity,
  profile;
}

enum AppLocale { en, am }

class LayoutController extends ChangeNotifier {
  HomePageNavigation _selectedHomePageNavigation = HomePageNavigation.bible;
  List<GlobalKey> verseKeys = [];
  AppLocale appLocale = AppLocale.en;
  bool isDarkMode = false;
  bool willReceiveNotification = true;
  bool willRemindPrayer = false;
  int initialIntroductionPageIndex = 0;
  double textSize = 12.0;
  String? selectedFont;

  final List<String> fonts = ['Font 1', 'Font 2', 'Font 3'];
  final List<Map<String, String>> settingsNavigation = [
    {'name': "General", 'route': '/settings'},
    {'name': "Profile", 'route': '/profile'},
    {'name': "Donations", 'route': '/donation'},
    {'name': "Contact Us", 'route': '/contacts'},
    {'name': "About", 'route': '/about'}
  ];
  final scrollController = ScrollController();

  AnimationController? verseHighlightController;
  AnimationController? bibleTraverseController;

  LayoutController() {
    selectedFont = fonts.first;
    scrollController.addListener(() {
      if (verseHighlightController != null &&
          verseHighlightController?.value != 1) {
        verseHighlightController?.forward();
      }
    });
  }

  HomePageNavigation get getSelectedHomePageNavigation =>
      _selectedHomePageNavigation;

  Widget get selectedHomeScreen {
    switch (_selectedHomePageNavigation) {
      case HomePageNavigation.devotion:
        return const DevotionScreen();
      case HomePageNavigation.testimonial:
        return const TestimonialScreen();
      case HomePageNavigation.bible:
        return const BibleScreen();
      case HomePageNavigation.activity:
        return const ActivityScreen();
      case HomePageNavigation.profile:
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }

  void scrollToTop() {
    scrollController.animateTo(0,
        curve: Curves.easeInOut, duration: const Duration(milliseconds: 500));
  }

  void scrollToVerse(GlobalKey verseKey) async {
    if (verseKey.currentContext != null) {
      await Scrollable.ensureVisible(verseKey.currentContext!,
          curve: Curves.easeInOut, duration: const Duration(milliseconds: 700));
      verseHighlightController?.reverse();
    }
  }

  set setSelectedHomePageNavigation(HomePageNavigation value) {
    if (value == HomePageNavigation.bible) {
      bibleTraverseController?.forward();
    } else {
      bibleTraverseController?.reverse();
    }

    _selectedHomePageNavigation = value;

    notifyListeners();
  }

  set setVerseKeys(List<GlobalKey> keys) {
    verseKeys = keys;
  }

  set setVerseAnimationController(AnimationController controller) {
    verseHighlightController = controller;
  }

  set setBibleTraverserAnimationController(AnimationController controller) {
    bibleTraverseController = controller;
  }

  set setAppLocale(AppLocale value) {
    appLocale = value;
    notifyListeners();
  }

  set setIntroPageIndex(int value) {
    initialIntroductionPageIndex = value;
    notifyListeners();
  }

  set setTheme(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  set setTextSize(double value) {
    textSize = value;
    notifyListeners();
  }

  set setWillReceiveNotification(bool value) {
    willReceiveNotification = value;
    notifyListeners();
  }

  set setWillRemindPrayer(bool value) {
    willRemindPrayer = value;
    notifyListeners();
  }
}
