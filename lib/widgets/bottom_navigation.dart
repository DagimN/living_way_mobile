import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/widgets/bottom_navigation_item.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final layoutController = Provider.of<LayoutController>(context);

    return SizedBox(
        height: 100,
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
                            icon: Image.asset(AppImages.profilePlaceholder,
                                height: 24))
                      ]))),
          Positioned(
              left: screenWidth * .43,
              child: Transform.rotate(
                  angle: math.pi / 4,
                  child: SizedBox(
                      height: 48,
                      width: 48,
                      child: IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: lightPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            layoutController.setSelectedHomePageNavigation =
                                HomePageNavigation.bible;
                          },
                          icon: Transform.rotate(
                              angle: -(math.pi / 4),
                              child: SvgPicture.asset(AppIcons.bible,
                                  height: 20,
                                  width: 20,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn)))))))
        ]));
  }
}
