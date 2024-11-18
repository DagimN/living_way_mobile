import "dart:convert";

import "package:flutter/material.dart";
import "package:living_way/models/profile.dart";
import "package:shared_preferences/shared_preferences.dart";

class ProfileController extends ChangeNotifier {
  Profile? userProfile;
  bool isAnonymous = false;
  List<TimeOfDay> prayerTimes = [const TimeOfDay(hour: 6, minute: 00)];

  ProfileController() {
    SharedPreferences.getInstance().then((instance) {
      final profileCache = instance.getString('profile');

      if (profileCache != null) {
        userProfile = Profile.fromJson(json.decode(profileCache));
        notifyListeners();
      }
    });
  }

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
