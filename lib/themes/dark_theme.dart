import 'package:flutter/material.dart';

//? Gradients
const darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF9C8156), Color(0xFF2B2A22)]);

final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFAA9F2C)),
    useMaterial3: true);


