import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/controllers/controllers.dart';
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
  late final AnimationController bibleTraverseController;
  late final Animation<double> bibleTraverseWidthAnimation;
  HomePageNavigation _selectedHomePageNavigation = HomePageNavigation.home;
  List<GlobalKey> verseKeys = [];
  int initialIntroductionPageIndex = 0;
  bool showSplashScreen = true;
  bool showVerseOfTheDayControls = true;
  bool isScrollingToVerse = false;

  final List<Map<String, String>> settingsNavigation = [
    {'name': "general", 'route': '/settings'},
    {'name': "devotionals", 'route': '/devotional-calendar'},
    {'name': "give", 'route': '/donation'},
    {'name': "contacts", 'route': '/contacts'},
    {'name': "about", 'route': '/about'}
  ];
  final bibleScrollController = ScrollController();

  AnimationController? verseHighlightController;
  BibleController? bibleController;

  LayoutController({required TickerProvider vsync}) {
    bibleTraverseController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 200), value: 0);
    bibleTraverseWidthAnimation =
        Tween<double>(begin: 72, end: 144).animate(bibleTraverseController);

    bibleScrollController.addListener(() {
      if (verseHighlightController != null &&
          verseHighlightController?.value != 1 &&
          !isScrollingToVerse) {
        verseHighlightController?.forward();
        bibleController?.setVerse = 0;
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      showSplashScreen = false;
      notifyListeners();
    });

    Future.delayed(const Duration(seconds: 10), () {
      VersionCheckService.checkForUpdate();
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
    bibleScrollController.animateTo(0,
        curve: Curves.easeInOut, duration: const Duration(milliseconds: 500));
  }

  void scrollToVerse(Passage passage) async {
    generateVerseKeys(passage);

    await Future.delayed(const Duration(milliseconds: 2000));

    final context = verseKeys[passage.verse].currentContext;

    if (context == null) return;

    isScrollingToVerse = true;

    // ignore: use_build_context_synchronously
    await Scrollable.ensureVisible(context,
        curve: Curves.easeInOut, duration: const Duration(milliseconds: 700));

    verseHighlightController?.reverse();

    isScrollingToVerse = false;
  }

  void generateVerseKeys(Passage passage) {
    verseKeys = List.generate(
        passage.verses.length,
        (index) => GlobalObjectKey(
            '${passage.book.name} ${passage.chapter} ${index + 1}'));
    notifyListeners();
  }

  set setBibleController(BibleController value) {
    bibleController = value;
  }

  set setSelectedHomePageNavigation(HomePageNavigation value) {
    if (value == HomePageNavigation.bible) {
      bibleTraverseController.forward();
    } else {
      bibleTraverseController.reverse();
    }

    _selectedHomePageNavigation = value;
    AnalyticsService.logEvent('navigation_tab_selected',
        parameters: {'tab': value.name});

    notifyListeners();
  }

  set setVerseAnimationController(AnimationController controller) {
    verseHighlightController = controller;
  }

  set setIntroPageIndex(int value) {
    initialIntroductionPageIndex = value;
    notifyListeners();
  }

  set setShowVerseOfTheDayControls(bool value) {
    showVerseOfTheDayControls = value;
    notifyListeners();
  }

  @override
  void dispose() {
    bibleTraverseController.dispose();
    super.dispose();
  }
}
