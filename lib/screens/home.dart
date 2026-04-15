import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/themes/app_theme.dart';
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
        floatingActionButton: layoutController.getSelectedHomePageNavigation ==
                HomePageNavigation.testimonial
            ? FloatingActionButton(
                backgroundColor: AppTheme(brightness).primaryButtonColor,
                onPressed: () {},
                child: const Icon(Icons.file_upload_outlined, size: 28))
            : null,
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                gradient: AppTheme(brightness).backgroundGradient),
            child: layoutController.selectedHomeScreen),
        bottomNavigationBar: const BottomNavigation());
  }
}
