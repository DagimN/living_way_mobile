import 'package:flutter/material.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:living_way/widgets/base_app_bar.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final settingsNavigation =
        Provider.of<LayoutController>(context).settingsNavigation;
    final themeController = Provider.of<ThemeController>(context);

    return SafeArea(
        child: SingleChildScrollView(
            child: SizedBox(
                height: orientation == Orientation.portrait
                    ? screenHeight * .8
                    : screenWidth * .6,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  BaseAppBar(
                      title: Container(
                          margin: const EdgeInsets.all(10),
                          child: Text('More',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: AppTheme(themeController.brightness)
                                      .primaryColor,
                                  fontWeight: FontWeight.w300)))),
                  const SizedBox(height: 30),
                  Expanded(
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: settingsNavigation.length,
                          itemBuilder: (context, index) {
                            final navigationItem = settingsNavigation[index];
                            return ListTile(
                                onTap: () => Navigator.pushNamed(
                                    context, navigationItem['route'] ?? ''),
                                title: Text(navigationItem['name'] ?? ''),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14));
                          }))
                ]))));
  }
}
