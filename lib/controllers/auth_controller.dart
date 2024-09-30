import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool isLoggedIn = false;

  AuthController() {
    SharedPreferences.getInstance().then((instance) {
      isLoggedIn = instance.getBool('isLoggedIn') ?? false;
    });
  }
}
