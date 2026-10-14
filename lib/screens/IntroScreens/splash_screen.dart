import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
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
    final theme = Provider.of<ThemeController>(context).theme;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        backgroundColor: theme.backgroundColor,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const SizedBox.shrink(),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
        ),
        body: Center(
            child: Image.asset(AppImages.aboutLogo,
                height: orientation == Orientation.portrait
                    ? screenHeight * .3
                    : screenHeight * .4,
                width: screenWidth * .7)));
  }
}
