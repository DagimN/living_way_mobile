import "dart:convert";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:living_way/core/core.dart";

class ProfileController extends ChangeNotifier {
  final posts = [];

  Profile? userProfile;

  bool isAnonymous = false;
  bool willReceiveNotification = true;
  bool willRemindPrayer = false;

  ProfileController() {
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

    notifyListeners();
  }

  Future<Profile?> syncProfile(Profile profile) async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.get('$url/api/v1/profile',
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
      dio.close();
    }
  }

  Future<void> editProfile(FormData formData) async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
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
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
    }
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
