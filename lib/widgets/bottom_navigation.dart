import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/widgets/bible_traverser.dart';
import 'package:living_way/widgets/bottom_navigation_item.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
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
                      border: const Border(
                          top: BorderSide(
                              color: lightPrimaryColor, width: 2.5))),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomNavigationItem(
                            icon: AppIcons.home,
                            homePageNavigation: HomePageNavigation.devotion),
                        BottomNavigationItem(
                            icon: AppIcons.fire,
                            homePageNavigation: HomePageNavigation.testimonial),
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
