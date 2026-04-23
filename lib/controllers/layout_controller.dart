import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/screens/ActivityScreen/index.dart';
import 'package:living_way/screens/BibleScreen/index.dart';
import 'package:living_way/screens/DailyFeedScreen/index.dart';
import 'package:living_way/screens/more_screen.dart';
import 'package:living_way/screens/LibraryScreen/index.dart';

enum HomePageNavigation {
  home,
  library,
  bible,
  activity,
  other;
}

class LayoutController extends ChangeNotifier {
  HomePageNavigation _selectedHomePageNavigation = HomePageNavigation.bible;
  List<GlobalKey> verseKeys = [];
  int initialIntroductionPageIndex = 0;
  bool showSplashScreen = true;
  bool showVerseOfTheDayControls = true;

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
    scrollController.addListener(() {
      if (verseHighlightController != null &&
          verseHighlightController?.value != 1) {
        verseHighlightController?.forward();
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      showSplashScreen = false;
      notifyListeners();
    });
  }

  HomePageNavigation get getSelectedHomePageNavigation =>
      _selectedHomePageNavigation;

  Widget get selectedHomeScreen {
    switch (_selectedHomePageNavigation) {
      case HomePageNavigation.home:
        return const DailyFeedScreen();
      case HomePageNavigation.library:
        return const LibraryScreen();
      case HomePageNavigation.bible:
        return const BibleScreen();
      case HomePageNavigation.activity:
        return const ActivityScreen();
      case HomePageNavigation.other:
        return const MoreScreen();
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

  set setIntroPageIndex(int value) {
    initialIntroductionPageIndex = value;
    notifyListeners();
  }

  set setShowVerseOfTheDayControls(bool value) {
    showVerseOfTheDayControls = value;
    notifyListeners();
  }
}
