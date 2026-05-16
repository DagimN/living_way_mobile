import "dart:convert";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:living_way/core/core.dart";

class ProfileController extends ChangeNotifier {
  final Dio? _dio;

  final posts = [];

  Profile? userProfile;

  bool isAnonymous = false;
  List<TimeOfDay> prayerTimes = [];
  bool willReceiveNotification = true;
  bool willRemindPrayer = false;

  ProfileController({Dio? dio}) : _dio = dio {
    //TODO: Implement stay logged in feature

    _init();
  }

  Future<void> _init() async {
    final profileCache = await CacheService.instance
        .readData<String>('profile', defaultValue: '{}');

    if (profileCache != "{}") {
      final profile = Profile.fromJson(json.decode(profileCache));

      userProfile = await syncProfile(profile) ?? profile;
    }

    willReceiveNotification = await CacheService.instance
        .readData<bool>('willReceiveNotification', defaultValue: true);
    willRemindPrayer = await CacheService.instance
        .readData<bool>('willRemindPrayer', defaultValue: false);

    final prayerTimes = (await CacheService.instance
        .readData<List<String>>('reminders', defaultValue: ['6:00']));
    for (final prayerTime in prayerTimes) {
      final time = (prayerTime as String).split(":");
      final hour = int.parse(time[0]);
      final minute = int.parse(time[1]);

      this.prayerTimes.add(TimeOfDay(hour: hour, minute: minute));
    }

    notifyListeners();
  }

  Dio _client() => _dio ?? Dio();

  bool get _shouldCloseClient => _dio == null;

  Future<Profile?> syncProfile(Profile profile) async {
    final client = _client();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await client.get('$url/api/v1/profile',
          queryParameters: {"id": profile.id, "tid": profile.tokenId});

      if (response.statusCode != 200) return null;

      final data = response.data['data'];
      await CacheService.instance
          .writeData<String>('profile', json.encode(data));

      return Profile.fromJson(data);
    } catch (error) {
      logger.e(error);
      return null;
    } finally {
      if (_shouldCloseClient) client.close();
    }
  }

  Future<void> editProfile(FormData formData) async {
    final client = _client();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response =
          await client.put('$url/api/v1/profile/edit', data: formData);

      if (response.statusCode != 200) return;

      userProfile = Profile.fromJson(response.data['result']['data']);
      notifyListeners();
    } catch (error) {
      logger.e(error);
    } finally {
      if (_shouldCloseClient) client.close();
    }
  }

  Future<void> deleteProfile() async {
    final client = _client();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await client.delete('$url/api/v1/profile/delete',
          queryParameters: {"id": userProfile?.id});

      if (response.statusCode != 200) return;
    } catch (error) {
      logger.e(error);
    } finally {
      if (_shouldCloseClient) client.close();
    }
  }

  void removePrayerTime(int index) {
    prayerTimes.removeAt(index);
    notifyListeners();
    CacheService.instance.writeData<List<String>>('reminders',
        prayerTimes.map((time) => '${time.hour}:${time.minute}').toList());
  }

  void addPrayerTime(TimeOfDay value) {
    prayerTimes.add(value);
    notifyListeners();
    CacheService.instance.writeData<List<String>>('reminders',
        prayerTimes.map((time) => '${time.hour}:${time.minute}').toList());
  }

  void editPrayerTime(TimeOfDay value, int index) {
    prayerTimes.replaceRange(index, index + 1, [value]);
    notifyListeners();
    CacheService.instance.writeData<List<String>>('reminders',
        prayerTimes.map((time) => '${time.hour}:${time.minute}').toList());
  }

  set setUserProfile(Profile value) {
    userProfile = value;
    notifyListeners();
  }

  set setWillReceiveNotification(bool value) {
    willReceiveNotification = value;
    notifyListeners();
    CacheService.instance.writeData<bool>('willReceiveNotification', value);
  }

  set setWillRemindPrayer(bool value) {
    willRemindPrayer = value;
    notifyListeners();
    CacheService.instance.writeData<bool>('willRemindPrayer', value);
  }
}
