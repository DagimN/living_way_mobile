import 'package:flutter/material.dart';

//? Colors
const lightPrimaryColor = Color(0xFF4F398A);

//? Gradients
const lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFAC7), Color(0xFFFFFFFF)]);

final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: lightPrimaryColor),
    useMaterial3: true);
