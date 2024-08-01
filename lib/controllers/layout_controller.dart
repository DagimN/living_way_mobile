import 'package:flutter/material.dart';
import 'package:living_way/screens/activity_screen.dart';
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

class LayoutController extends ChangeNotifier {
  HomePageNavigation _selectedHomePageNavigation = HomePageNavigation.bible;

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

  set setSelectedHomePageNavigation(HomePageNavigation value) {
    _selectedHomePageNavigation = value;
    notifyListeners();
  }
}
