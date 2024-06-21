import 'package:flutter/material.dart';
// import 'package:living_way/themes/dark_theme.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/widgets/bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Brightness brightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(gradient: lightBackgroundGradient
                // brightness == Brightness.light
                //     ? lightBackgroundGradient
                //     : darkBackgroundGradient
                )),
        bottomNavigationBar: const BottomNavigation());
  }
}
