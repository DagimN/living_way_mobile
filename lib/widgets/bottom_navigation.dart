import 'package:flutter/material.dart';
import 'package:living_way/core/config/paths.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        height: 103,
        child: Stack(children: [
          Positioned(
              bottom: 0,
              child: Container(
                  height: 77,
                  width: screenWidth,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                          top: BorderSide(
                              color: AppTheme(themeController.brightness)
                                  .primaryColor,
                              width: 2.5))),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomNavigationItem(
                            icon: AppIcons.home,
                            homePageNavigation: HomePageNavigation.home),
                        BottomNavigationItem(
                            icon: AppIcons.fire,
                            homePageNavigation: HomePageNavigation.library),
                        SizedBox(width: 50),
                        BottomNavigationItem(
                            icon: AppIcons.calendar,
                            homePageNavigation: HomePageNavigation.activity),
                        BottomNavigationItem(
                            iconWidegt: Icon(Icons.menu_rounded, size: 32),
                            homePageNavigation: HomePageNavigation.other)
                      ]))),
          const BibleTraverser()
        ]));
  }
}
