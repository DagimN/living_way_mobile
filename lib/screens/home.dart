import 'package:flutter/material.dart';
import 'package:living_way/controllers/layout_controller.dart';
// import 'package:living_way/themes/dark_theme.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //TODO: Implement dark mode
    // Brightness brightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
        floatingActionButton: layoutController.getSelectedHomePageNavigation ==
                HomePageNavigation.testimonial
            ? FloatingActionButton(
                backgroundColor: lightPrimaryButtonColor,
                onPressed: () {},
                child: const Icon(Icons.file_upload_outlined, size: 28))
            : null,
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(gradient: lightBackgroundGradient
                // brightness == Brightness.light
                //     ? lightBackgroundGradient
                //     : darkBackgroundGradient
                ),
            child: layoutController.selectedHomeScreen),
        bottomNavigationBar: const BottomNavigation());
  }
}
