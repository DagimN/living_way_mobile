import 'package:flutter/material.dart';

//? Colors
const lightPrimaryColor = Color(0xFF4F398A);
const lightPrimaryPaleColor = Color(0xFF847AA0);
const lightInactiveColor = Color(0xFF343635);

//? Gradients
const lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFAC7), Color(0xFFFFFFFF)]);
const lightTopicGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0x3DE3D9FF), Color(0xA5F8F5BB)]);

final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: lightPrimaryColor),
    useMaterial3: true);
