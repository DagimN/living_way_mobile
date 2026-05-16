import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/themes/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme returns light colors', () {
      final theme = AppTheme(Brightness.light);
      expect(theme.primaryColor, isNotNull);
      expect(theme.backgroundColor, isNotNull);
      expect(theme.iconColor, Colors.black);
    });

    test('dark theme returns dark colors', () {
      final theme = AppTheme(Brightness.dark);
      expect(theme.primaryColor, isNotNull);
      expect(theme.backgroundColor, isNotNull);
    });

    test('chipColor differs by brightness', () {
      final light = AppTheme(Brightness.light);
      final dark = AppTheme(Brightness.dark);
      expect(light.chipColor, Colors.white);
      expect(dark.chipColor, dark.inactiveColor);
    });

    test('inactiveChipColor is null in light mode', () {
      final light = AppTheme(Brightness.light);
      expect(light.inactiveChipColor, isNull);
    });

    test('gradients are available for both themes', () {
      expect(AppTheme(Brightness.light).backgroundGradient, isNotNull);
      expect(AppTheme(Brightness.dark).backgroundGradient, isNotNull);
      expect(AppTheme(Brightness.light).topicGradient, isNotNull);
      expect(AppTheme(Brightness.dark).topicGradient, isNotNull);
    });
  });
}
