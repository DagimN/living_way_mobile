import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';

class SplashScreen extends StatefulWidget {
  final BuildContext context;
  const SplashScreen(this.context, {super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        body: Center(
            child: Image.asset(AppImages.aboutLogo,
                height: orientation == Orientation.portrait
                    ? screenHeight * .3
                    : screenHeight * .4,
                width: screenWidth * .7)));
  }
}
