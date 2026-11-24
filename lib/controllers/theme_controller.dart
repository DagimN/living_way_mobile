import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  double textSize = 0.3;
  ThemeMode themeMode = ThemeMode.light;
  Fonts selectedFont = Fonts.RobotoSlab;

  ThemeController() {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    textSize = await CacheService.instance
        .readData<double>('textSize', defaultValue: 0.3);
    final storedThemeMode = await CacheService.instance
        .readData<int>('themeMode', defaultValue: -1);
    if (storedThemeMode >= 0 && storedThemeMode < ThemeMode.values.length) {
      themeMode = ThemeMode.values[storedThemeMode];
    } else {
      final storedBrightness = await CacheService.instance
          .readData<int>('brightness', defaultValue: Brightness.light.index);
      themeMode = storedBrightness == Brightness.dark.index
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    selectedFont = Fonts.values[
        await CacheService.instance.readData<int>('font', defaultValue: 5)];

    notifyListeners();
  }

  Brightness get brightness => switch (themeMode) {
        ThemeMode.system =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
        ThemeMode.light => Brightness.light,
        ThemeMode.dark => Brightness.dark,
      };

  AppTheme get theme => AppTheme(brightness);

  @override
  void didChangePlatformBrightness() {
    if (themeMode == ThemeMode.system) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  void setThemeMode(ThemeMode value) {
    if (themeMode == value) return;
    themeMode = value;
    notifyListeners();
    CacheService.instance.writeData<int>('themeMode', value.index);
  }
}
