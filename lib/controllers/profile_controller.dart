import "dart:convert";

import "package:dio/dio.dart";
import "package:flavor_getter/flavor_getter.dart";
import "package:flutter/material.dart";
import "package:living_way/constants/urls.dart";
import "package:living_way/models/profile.dart";
import "package:living_way/services/logging_service.dart";
import "package:shared_preferences/shared_preferences.dart";

class ProfileController extends ChangeNotifier {
  Profile? userProfile;
  final posts = [];
  bool isAnonymous = false;
  List<TimeOfDay> prayerTimes = [const TimeOfDay(hour: 6, minute: 00)];
  bool willReceiveNotification = true;
  bool willRemindPrayer = false;

  ProfileController() {
    SharedPreferences.getInstance().then((instance) async {
      final profileCache = instance.getString('profile');
      //TODO: Implement stay logged in feature

      if (profileCache != null) {
        final profile = Profile.fromJson(json.decode(profileCache));
        userProfile = profile;
        notifyListeners();

        userProfile = await syncProfile(profile) ?? userProfile;
      }
    });
  }

  Future<Profile?> syncProfile(Profile profile) async {
    final dio = Dio();
    final flavor = await FlavorGetter().getFlavor();
    final url = flavor == "dev"
        ? Urls.devApiUrl
        : flavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.get('$url/api/v1/profile',
          queryParameters: {"id": profile.id, "tid": profile.tokenId});

      if (response.statusCode != 200) return null;

      return Profile.fromJson(response.data['data']);
    } catch (error) {
      logger.e(error);
      return null;
    } finally {
      dio.close();
    }
  }

  Future<void> editProfile(FormData formData) async {
    final dio = Dio();
    final flavor = await FlavorGetter().getFlavor();
    final url = flavor == "dev"
        ? Urls.devApiUrl
        : flavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response =
          await dio.put('$url/api/v1/profile/edit', data: formData);

      if (response.statusCode != 200) return;

      userProfile = Profile.fromJson(response.data['result']['data']);
      notifyListeners();
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
    }
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

  set setWillReceiveNotification(bool value) {
    willReceiveNotification = value;
    notifyListeners();
  }

  set setWillRemindPrayer(bool value) {
    willRemindPrayer = value;
    notifyListeners();
  }
}
