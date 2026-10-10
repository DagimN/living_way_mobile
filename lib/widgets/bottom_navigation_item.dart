import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigationItem extends StatelessWidget {
  final HomePageNavigation homePageNavigation;
  final String? icon;
  final Icon iconWidegt;
  const BottomNavigationItem(
      {super.key,
      required this.homePageNavigation,
      this.icon,
      this.iconWidegt = const Icon(Icons.home_mini)});

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final theme = Provider.of<ThemeController>(context).theme;
    final selected =
        layoutController.getSelectedHomePageNavigation == homePageNavigation;

    return Column(children: [
      IconButton(
          onPressed: () {
            layoutController.setSelectedHomePageNavigation = homePageNavigation;
          },
          icon: icon != null
              ? SvgPicture.asset(icon!,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                      selected ? theme.primaryColor : theme.inactiveColor,
                      BlendMode.srcIn))
              : Icon(iconWidegt.icon,
                  size: iconWidegt.size,
                  color: selected ? theme.primaryColor : theme.inactiveColor)),
      if (selected)
        Container(
            height: 3,
            width: 7,
            decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))))
    ]);
  }
}
