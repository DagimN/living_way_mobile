import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: const Center(child: Text('About Screen'))));
  }
}
