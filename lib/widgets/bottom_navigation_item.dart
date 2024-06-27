import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class BottomNavigationItem extends StatelessWidget {
  final HomePageNavigation homePageNavigation;
  final String icon;
  const BottomNavigationItem(
      {super.key, required this.icon, required this.homePageNavigation});

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final selected =
        layoutController.getSelectedHomePageNavigation == homePageNavigation;

    return Column(children: [
      IconButton(
          onPressed: () {
            layoutController.setSelectedHomePageNavigation = homePageNavigation;
          },
          icon: SvgPicture.asset(icon,
              height: 32,
              colorFilter: ColorFilter.mode(
                  selected ? lightPrimaryColor : lightInactiveColor,
                  BlendMode.srcIn))),
      if (selected)
        Container(
            height: 3,
            width: 7,
            decoration: const BoxDecoration(
                color: lightPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10))))
    ]);
  }
}
