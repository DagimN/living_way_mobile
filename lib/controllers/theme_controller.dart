// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppLocale { en, am }

enum Fonts { Futura, Georgia, Helvetica, OpenSans, Quicksand, RobotoSlab }

class ThemeController extends ChangeNotifier {
  double textSize = 0.3;
  AppLocale appLocale = AppLocale.en;
  Brightness brightness = Brightness.light;
  Fonts? selectedFont;

  ThemeController() {
    selectedFont = Fonts.RobotoSlab;

    notifyListeners();
  }

  set setTextSize(double value) {
    textSize = value;
    notifyListeners();
  }

  void toggleAppLocale() {
    if (appLocale == AppLocale.am) {
      appLocale = AppLocale.en;
    } else {
      appLocale = AppLocale.am;
    }

    notifyListeners();
  }

  void toggleBrightness() {
    if (brightness == Brightness.light) {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }

    notifyListeners();
  }
}
