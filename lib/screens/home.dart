import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final themeController = Provider.of<ThemeController>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Brightness brightness = themeController.brightness;

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light),
        body: appFlavor == "prod"
            ? Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                    gradient: AppTheme(brightness).backgroundGradient),
                child: layoutController.selectedHomeScreen)
            : Banner(
                message: (appFlavor ?? "").capitalize(),
                location: BannerLocation.topEnd,
                color: appFlavor == "dev" ? Colors.blue : Colors.yellow,
                child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: BoxDecoration(
                        gradient: AppTheme(brightness).backgroundGradient),
                    child: layoutController.selectedHomeScreen),
              ),
        bottomNavigationBar: const BottomNavigation());
  }
}
