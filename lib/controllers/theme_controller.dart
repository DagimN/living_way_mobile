// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLocale { en, am }

enum Fonts { Futura, Georgia, Helvetica, OpenSans, Quicksand, RobotoSlab }

class ThemeController extends ChangeNotifier {
  SharedPreferences? sharedPreferences;

  double textSize = 0.3;
  AppLocale appLocale = AppLocale.en;
  Brightness brightness = Brightness.dark;
  Fonts selectedFont = Fonts.RobotoSlab;

  ThemeController() {
    SharedPreferences.getInstance().then((instance) {
      sharedPreferences = instance;

      textSize = sharedPreferences?.getDouble('textSize') ?? 0.3;
      appLocale = AppLocale.values[sharedPreferences?.getInt('locale') ?? 0];
      brightness =
          Brightness.values[sharedPreferences?.getInt('brightness') ?? 1];
      selectedFont = Fonts.values[sharedPreferences?.getInt('font') ?? 5];

      notifyListeners();
    });
  }

  set setTextSize(double value) {
    textSize = value;
    notifyListeners();
    sharedPreferences?.setDouble('textSize', value);
  }

  set setFont(Fonts value) {
    selectedFont = value;
    notifyListeners();
    sharedPreferences?.setInt('font', value.index);
  }

  void toggleAppLocale() {
    if (appLocale == AppLocale.am) {
      appLocale = AppLocale.en;
    } else {
      appLocale = AppLocale.am;
    }

    notifyListeners();
    sharedPreferences?.setInt('locale', appLocale.index);
  }

  void toggleBrightness() {
    if (brightness == Brightness.light) {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }

    notifyListeners();
    sharedPreferences?.setInt('brightness', brightness.index);
  }
}
