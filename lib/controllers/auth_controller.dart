import 'package:dio/dio.dart';
import 'package:flavor_getter/flavor_getter.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:living_way/constants/urls.dart';
import 'package:living_way/services/logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  SharedPreferences? sharedPreferences;
  bool isLoggedIn = false;
  bool isLoggedInViaGoogle = false;
  bool isLoggedInViaManual = false;

  AuthController() {
    SharedPreferences.getInstance().then((instance) {
      sharedPreferences = instance;
      isLoggedIn = instance.getBool('isLoggedIn') ?? false;
      isLoggedInViaGoogle = instance.getBool('isLoggedInViaGoogle') ?? false;
      isLoggedInViaManual = instance.getBool('isLoggedInViaManual') ?? false;
      notifyListeners();
    });
  }

  Future<bool> loginViaGoogle() async {
    final account =
        await GoogleSignIn(scopes: <String>['email', 'profile']).signIn();

    if (account != null) {
      bool success = await performLogin(account.email);
      isLoggedInViaGoogle = success;

      if (success) {
        if (sharedPreferences != null) {
          await sharedPreferences?.setBool('isLoggedIn', true);
          await sharedPreferences?.setBool('isLoggedInViaGoogle', true);
        } else {
          //TODO: Log error in crashlytics
          logger.e('Shared preferences has not been initialized');
        }

        return true;
      }
    }

    await GoogleSignIn().signOut();

    return false;
  }

  Future<bool> performSignup() async {
    await Future.delayed(const Duration(seconds: 3));
    //TODO: Save signup cache
    return true;
  }

  Future<bool> performLogin(String email,
      {String? password, bool? isOAuth = false}) async {
    //TODO: Perform login
    final dio = Dio();
    final flavor = await FlavorGetter().getFlavor();
    final url = flavor == "dev" ? Urls.devApiUrl : Urls.prodApiUrl;

    try {
      //TODO: Encrypt query params
      final response = await dio.get('$url/api/v1/auth/login',
          queryParameters: {"em": email, "p": password, "o": isOAuth});

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
      await sharedPreferences?.setBool('isLoggedIn', false);
      await sharedPreferences?.setBool('isLoggedInViaGoogle', false);
    } else {
      //TODO: Log error in crashlytics
      logger.e('Shared preferences has not been initialized');
    }
  }
}
