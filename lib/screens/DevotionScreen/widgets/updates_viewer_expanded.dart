import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:provider/provider.dart';

import 'verse_of_the_day.dart';

class UpdatesViewerExpanded extends StatelessWidget {
  final NetworkImage image;
  const UpdatesViewerExpanded({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    Brightness brightness = themeController.brightness;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: AppTheme(brightness).backgroundColor,
        body: Hero(
            tag: "updates",
            child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                    image: DecorationImage(image: image, fit: BoxFit.cover),
                    gradient: AppTheme(brightness).backgroundGradient),
                child: const VerseOfTheDay(isEnlarged: true))));
  }
}
