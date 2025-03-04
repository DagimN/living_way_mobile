import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flavor_getter/flavor_getter.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:living_way/constants/urls.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/models/profile.dart';
import 'package:living_way/models/signup_progress.dart';
import 'package:living_way/services/logging_service.dart';
import 'package:living_way/utils/security_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  SharedPreferences? sharedPreferences;
  bool isLoggedIn = false;
  bool isLoggedInViaGoogle = false;
  bool isLoggedInViaManual = false;
  SignupProgress signupProgress = SignupProgress();
  ProfileController? profileController;

  AuthController() {
    SharedPreferences.getInstance().then((instance) {
      sharedPreferences = instance;
      isLoggedIn = instance.getBool('isLoggedIn') ?? false;
      isLoggedInViaGoogle = instance.getBool('isLoggedInViaGoogle') ?? false;
      isLoggedInViaManual = instance.getBool('isLoggedInViaManual') ?? false;
      notifyListeners();
    });
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
        if (sharedPreferences != null) {
          await sharedPreferences?.setBool('isLoggedIn', true);
          await sharedPreferences?.setBool('isLoggedInViaGoogle', true);
        } else {
          const message = 'Shared preferences has not been initialized';
          logger.e(message);
          throw ErrorDescription(message);
        }

        return true;
      }
    }

    await GoogleSignIn().signOut();

    return false;
  }

  Future<Response> performSignup() async {
    final dio = Dio();
    final flavor = await FlavorGetter().getFlavor();
    final url = flavor == "dev"
        ? Urls.devApiUrl
        : flavor == "staging"
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

      if (response.statusCode != 201) return response;

      signupProgress = SignupProgress();

      profileController?.setUserProfile =
          Profile.fromJson(response.data['data']);

      if (sharedPreferences != null) {
        await sharedPreferences?.setString(
            'profile', json.encode(response.data['data']));
        await sharedPreferences?.setBool('isLoggedIn', true);
        await sharedPreferences?.setBool('isLoggedInViaManual', true);
      } else {
        const message = 'Shared preferences has not been initialized';
        logger.e(message);
        throw ErrorDescription(message);
      }

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
    final flavor = await FlavorGetter().getFlavor();
    final url = flavor == "dev"
        ? Urls.devApiUrl
        : flavor == "staging"
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

      profileController?.setUserProfile =
          Profile.fromJson(response.data['data']);

      if (sharedPreferences != null) {
        await sharedPreferences?.setString(
            'profile', json.encode(response.data['data']));
      } else {
        const message = 'Shared preferences has not been initialized';
        logger.e(message);
        throw ErrorDescription(message);
      }

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

    if (sharedPreferences != null) {
      await sharedPreferences?.remove('profile');
      await sharedPreferences?.setBool('isLoggedIn', false);
      await sharedPreferences?.setBool('isLoggedInViaGoogle', false);
    } else {
      const message = 'Shared preferences has not been initialized';
      logger.e(message);
      throw ErrorDescription(message);
    }
  }

  Future<void> logoutViaManual() async {
    if (sharedPreferences != null) {
      await sharedPreferences?.remove('profile');
      await sharedPreferences?.setBool('isLoggedIn', false);
      await sharedPreferences?.setBool('isLoggedInViaManual', false);
    } else {
      const message = 'Shared preferences has not been initialized';
      logger.e(message);
      throw ErrorDescription(message);
    }
  }
}
