import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/layout_controller.dart';

class ThemeController extends ChangeNotifier {
  final fonts = <String>['Font 1', 'Font 2', 'Font 3'];

  double textSize = 0.3;
  AppLocale appLocale = AppLocale.en;
  Brightness brightness = Brightness.light;
  String? selectedFont;

  ThemeController() {
    selectedFont = fonts.first;

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
