import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/themes/light_theme.dart';
import 'dart:math' as math;

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                        IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(AppIcons.devotion,
                                height: 32)),
                        IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(AppIcons.testimonial,
                                height: 32)),
                        const SizedBox(width: 50),
                        IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(AppIcons.activity,
                                height: 32)),
                        IconButton(
                            onPressed: () {},
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
                          onPressed: () {},
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
