import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

class ThemeController extends ChangeNotifier {
  double textSize = 0.3;
  Brightness brightness = Brightness.dark;
  Fonts selectedFont = Fonts.RobotoSlab;

  ThemeController() {
    _init();
  }

  Future<void> _init() async {
    textSize = await CacheService.instance
        .readData<double>('textSize', defaultValue: 0.3);
    brightness = Brightness.values[await CacheService.instance
        .readData<int>('brightness', defaultValue: 1)];
    selectedFont = Fonts.values[
        await CacheService.instance.readData<int>('font', defaultValue: 5)];

    notifyListeners();
  }

  set setTextSize(double value) {
    textSize = value;
    notifyListeners();
    CacheService.instance.writeData<double>('textSize', value);
  }

  set setFont(Fonts value) {
    selectedFont = value;
    notifyListeners();
    CacheService.instance.writeData<int>('font', value.index);
  }

  void toggleBrightness() {
    if (brightness == Brightness.light) {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }

    notifyListeners();
    CacheService.instance.writeData<int>('brightness', brightness.index);
  }
}
