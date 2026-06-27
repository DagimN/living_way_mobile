import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/config/paths.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

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
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: Center(
            child: Image.asset(AppImages.aboutLogo,
                height: orientation == Orientation.portrait
                    ? screenHeight * .3
                    : screenHeight * .4,
                width: screenWidth * .7)));
  }
}
