import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/widgets/bible_traverser.dart';
import 'package:living_way/widgets/bottom_navigation_item.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final layoutController = Provider.of<LayoutController>(context);

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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const BottomNavigationItem(
                            icon: AppIcons.devotion,
                            homePageNavigation: HomePageNavigation.devotion),
                        const BottomNavigationItem(
                            icon: AppIcons.testimonial,
                            homePageNavigation: HomePageNavigation.testimonial),
                        const SizedBox(width: 50),
                        const BottomNavigationItem(
                            icon: AppIcons.activity,
                            homePageNavigation: HomePageNavigation.activity),
                        IconButton(
                            onPressed: () {
                              layoutController.setSelectedHomePageNavigation =
                                  HomePageNavigation.profile;
                            },
                            icon:
                                Image.asset(AppImages.signupFlow3, height: 24))
                      ]))),
          const BibleTraverser()
        ]));
  }
}
