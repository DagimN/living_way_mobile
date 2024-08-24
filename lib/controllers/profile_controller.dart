import "package:flutter/material.dart";
import "package:living_way/models/profile.dart";

class ProfileController extends ChangeNotifier {
  Profile? userProfile;
  bool isAnonymous = false;
  List<TimeOfDay> prayerTimes = [const TimeOfDay(hour: 6, minute: 00)];

  void removePrayerTime(int index) {
    prayerTimes.removeAt(index);
    notifyListeners();
  }

  void addPrayerTime(TimeOfDay value) {
    prayerTimes.add(value);
    notifyListeners();
  }

  set setUserProfile(Profile value) {
    userProfile = value;
    notifyListeners();
  }

  set setAnonymousProfile(bool value) {
    isAnonymous = value;
    notifyListeners();
  }
}
