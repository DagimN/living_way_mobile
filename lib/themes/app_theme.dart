import 'package:flutter/material.dart';
import 'package:living_way/themes/dark_theme.dart' as dark;
import 'package:living_way/themes/light_theme.dart' as light;

class AppTheme {
  Brightness brightness;

  AppTheme(this.brightness);

  Color get primaryColor {
    return brightness == Brightness.light
        ? light.primaryColor
        : dark.primaryColor;
  }

  Color get primaryPaleColor {
    return brightness == Brightness.light
        ? light.primaryColor
        : dark.primaryColor;
  }

  Color get primaryPanelColor {
    return brightness == Brightness.light
        ? light.primaryPanelColor
        : dark.primaryPanelColor;
  }

  Color get secondaryColor {
    return brightness == Brightness.light
        ? light.primaryColor
        : dark.secondaryColor;
  }

  Color get inactiveColor {
    return brightness == Brightness.light
        ? light.inactiveColor
        : dark.inactiveColor;
  }

  Color get backgroundColor {
    return brightness == Brightness.light
        ? light.backgroundColor
        : dark.backgroundColor;
  }

  Color get accentColor {
    return brightness == Brightness.light
        ? light.accentColor
        : dark.accentColor;
  }

  Color get subHeadingColor {
    return brightness == Brightness.light
        ? light.primaryColor
        : dark.accentColor;
  }

  Color get dividerColor {
    return brightness == Brightness.light
        ? Colors.grey[200]!
        : dark.accentColor.withAlpha(128);
  }

  Color get chipColor {
    return brightness == Brightness.light ? Colors.white : inactiveColor;
  }

  Color? get inactiveChipColor {
    return brightness == Brightness.light ? null : Colors.grey[400];
  }

  Color get iconColor {
    return brightness == Brightness.light ? Colors.black : dark.appBarColor;
  }

  Color get primaryButtonColor {
    return brightness == Brightness.light
        ? light.primaryButtonColor
        : dark.primaryButtonColor;
  }

  Color get pendingColor {
    return brightness == Brightness.light
        ? light.pendingColor
        : dark.pendingColor;
  }

  LinearGradient get backgroundGradient {
    return brightness == Brightness.light
        ? light.backgroundGradient
        : dark.backgroundGradient;
  }

  LinearGradient get topicGradient {
    return brightness == Brightness.light
        ? light.topicGradient
        : dark.topicGradient;
  }
}
