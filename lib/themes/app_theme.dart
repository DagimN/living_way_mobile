import 'package:flutter/material.dart';
import 'package:living_way/themes/dark_theme.dart';
import 'package:living_way/themes/light_theme.dart';

class AppTheme {
  Brightness brightness;

  AppTheme(this.brightness);

  Color get primaryColor {
    return brightness == Brightness.light
        ? lightPrimaryColor
        : darkPrimaryColor;
  }

  Color get secondaryColor {
    return brightness == Brightness.light
        ? lightPrimaryColor
        : darkSecondaryColor;
  }

  Color get inactiveColor {
    return brightness == Brightness.light
        ? lightInactiveColor
        : darkInactiveColor;
  }

  Color get backgroundColor {
    return brightness == Brightness.light
        ? lightBackgroundColor
        : darkBackgroundColor;
  }

  Color get accentColor {
    return brightness == Brightness.light ? lightAccentColor : darkAccentColor;
  }

  Color get subHeadingColor {
    return brightness == Brightness.light ? lightPrimaryColor : darkAccentColor;
  }

  Color get dividerColor {
    return brightness == Brightness.light
        ? Colors.grey[200]!
        : darkAccentColor.withOpacity(0.5);
  }

  Color get chipColor {
    return brightness == Brightness.light ? Colors.white : darkInactiveColor;
  }

  Color? get inactiveChipColor {
    return brightness == Brightness.light ? null : Colors.grey[400];
  }

  Color get iconColor {
    return brightness == Brightness.light ? Colors.black : darkAppBarColor;
  }

  Color get primaryButtonColor {
    return brightness == Brightness.light
        ? lightPrimaryButtonColor
        : darkPrimaryButtonColor;
  }

  LinearGradient get backgroundGradient {
    return brightness == Brightness.light
        ? lightBackgroundGradient
        : darkBackgroundGradient;
  }
}
