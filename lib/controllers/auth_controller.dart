import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    //TODO: Perform login

    if (account != null) {
      isLoggedInViaGoogle = true;

      if (sharedPreferences != null) {
        await sharedPreferences?.setBool('isLoggedIn', true);
        await sharedPreferences?.setBool('isLoggedInViaGoogle', true);
      } else {
        //TODO: Log error in crashlytics
        logger.e('Shared preferences has not been initialized');
      }

      return true;
    }

    return false;
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
