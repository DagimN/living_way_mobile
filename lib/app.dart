import 'package:flutter/material.dart';
import 'package:living_way/screens/home.dart';
import 'package:living_way/themes/dark_theme.dart';
import 'package:living_way/themes/light_theme.dart';

class LivingWayApp extends StatelessWidget {
  const LivingWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Living Way',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const HomeScreen());
  }
}
