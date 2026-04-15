import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/controllers/controllers.dart';

class AuthController extends ChangeNotifier {
  bool isLoggedIn = false;
  bool isLoggedInViaGoogle = false;
  bool isLoggedInViaManual = false;
  SignupProgress signupProgress = SignupProgress();
  ProfileController? profileController;

  AuthController() {
    init();
  }

  Future<void> init() async {
    isLoggedIn = await CacheService.instance
        .readData<bool>('isLoggedIn', defaultValue: false);
    isLoggedInViaGoogle = await CacheService.instance
        .readData<bool>('isLoggedInViaGoogle', defaultValue: false);
    isLoggedInViaManual = await CacheService.instance
        .readData<bool>('isLoggedInViaManual', defaultValue: false);
    notifyListeners();
  }

  set setProfileController(ProfileController value) {
    profileController = value;
  }

  Future<bool> loginViaGoogle() async {
    final account =
        await GoogleSignIn(scopes: <String>['email', 'profile']).signIn();

    if (account != null) {
      bool success = await performLogin(account.email, isOAuth: true);
      isLoggedInViaGoogle = success;

      //TODO: Report error

      if (success) {
        await CacheService.instance.writeData<bool>('isLoggedIn', true);
        await CacheService.instance
            .writeData<bool>('isLoggedInViaGoogle', true);

        return true;
      }
    }

    await GoogleSignIn().signOut();

    return false;
  }

  Future<Response> performSignup() async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.post('$url/api/v1/auth/signup', data: {
        "firstName": signupProgress.firstName,
        "lastName": signupProgress.lastName,
        "email": signupProgress.email,
        "password": encrypt(signupProgress.password!),
        "isClient": true
      });

      if (!response.statusCode.isSuccess) return response;

      signupProgress = SignupProgress();

      final data = response.data['data'];
      profileController?.setUserProfile = Profile.fromJson(data);

      await CacheService.instance
          .writeData<String>('profile', json.encode(data));
      await CacheService.instance.writeData<bool>('isLoggedIn', true);
      await CacheService.instance.writeData<bool>('isLoggedInViaManual', true);

      return response;
    } on DioException catch (error) {
      //TODO: Report error
      logger.e(error);
      return error.response ??
          Response(
              requestOptions: RequestOptions(),
              statusCode: 400,
              statusMessage: error.toString());
    } on Exception catch (error) {
      logger.e(error);
      return Response(
          requestOptions: RequestOptions(),
          statusCode: 400,
          statusMessage: error.toString());
    } finally {
      dio.close();
    }
  }

  Future<bool> performLogin(String email,
      {String? password, bool? isOAuth = false}) async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response =
          await dio.get('$url/api/v1/auth/login', queryParameters: {
        "em": email,
        "p": password != null ? encrypt(password) : null,
        "o": isOAuth,
        "client": true
      });

      final data = response.data['data'];

      profileController?.setUserProfile = Profile.fromJson(data);
      await CacheService.instance
          .writeData<String>('profile', json.encode(data));

      return true;
    } catch (error) {
      logger.e(error);
      return false;
    } finally {
      dio.close();
    }
  }

  Future<void> logoutViaGoogle() async {
    await GoogleSignIn().signOut();
    await CacheService.instance.deleteData('profile');
    await CacheService.instance.writeData('isLoggedIn', false);
    await CacheService.instance.writeData('isLoggedInViaGoogle', false);
  }

  Future<void> logoutViaManual() async {
    await CacheService.instance.deleteData('profile');
    await CacheService.instance.writeData<bool>('isLoggedIn', false);
    await CacheService.instance.writeData<bool>('isLoggedInViaManual', false);
  }
}
