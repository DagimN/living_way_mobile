import "dart:convert";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:functional_status_codes/functional_status_codes.dart";
import "package:living_way/core/core.dart";

class ProfileController extends ChangeNotifier {
  final posts = [];

  Profile? userProfile;

  bool isAnonymous = false;
  bool willReceiveNotification = true;
  bool willRemindPrayer = false;

  ProfileController() {
    _init();
  }

  Future<void> _init() async {
    final profileCache = await CacheService.instance
        .readData<String>('profile', defaultValue: '{}');

    if (profileCache != "{}") {
      userProfile = Profile.fromJson(json.decode(profileCache));
      await syncProfile();
    }

    willReceiveNotification = await CacheService.instance
        .readData<bool>('willReceiveNotification', defaultValue: true);
    willRemindPrayer = await CacheService.instance
        .readData<bool>('willRemindPrayer', defaultValue: false);

    notifyListeners();
  }

  Future<void> syncProfile() async {
    if (userProfile == null) return;

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio
          .get('$url/api/v1/profile', queryParameters: {"id": userProfile?.id});

      if (response.statusCode != 200) return;

      final data = response.data['data'];
      await CacheService.instance
          .writeData<String>('profile', json.encode(data));

      userProfile = Profile.fromJson(data);
    } catch (error) {
      logger.e(error);
      return;
    } finally {
      dio.close();
      notifyListeners();
    }
  }

  Future<bool> editProfile(FormData formData) async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response =
          await dio.put('$url/api/v1/profile/edit', data: formData);

      if (!response.statusCode.isSuccess) return false;

      userProfile = Profile.fromJson(response.data['result']['data']);
      notifyListeners();
      AnalyticsService.logEvent('profile_updated',
          parameters: {'id': userProfile?.id ?? ''});
      return true;
    } catch (error) {
      logger.e(error);
      return false;
    } finally {
      dio.close();
    }
  }

  Future<void> deleteProfile() async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.delete('$url/api/v1/profile/delete',
          queryParameters: {"id": userProfile?.id});

      if (response.statusCode != 200) return;
      AnalyticsService.logEvent('profile_deleted',
          parameters: {'id': userProfile?.id ?? ''});
      clearValues();
    } catch (error) {
      logger.e(error);
    }
  }

  set setUserProfile(Profile? value) {
    userProfile = value;
    notifyListeners();
  }

  set setWillReceiveNotification(bool value) {
    willReceiveNotification = value;
    notifyListeners();
    CacheService.instance.writeData<bool>('willReceiveNotification', value);
    AnalyticsService.logEvent('notification_preference_changed',
        parameters: {'enabled': value.toString()});
  }

  set setWillRemindPrayer(bool value) {
    willRemindPrayer = value;
    notifyListeners();
    CacheService.instance.writeData<bool>('willRemindPrayer', value);
    AnalyticsService.logEvent('prayer_reminder_changed',
        parameters: {'enabled': value.toString()});
  }

  void clearValues() {
    userProfile = null;
    isAnonymous = false;
    willReceiveNotification = true;
    willRemindPrayer = false;
    CacheService.instance.deleteData('profile');
    CacheService.instance.writeData('willReceiveNotification', true);
    CacheService.instance.writeData('willRemindPrayer', false);
    notifyListeners();
  }
}
