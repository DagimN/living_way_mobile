import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Provider.of<ThemeController>(context);

    return Scaffold(
        backgroundColor: AppTheme(themeController.brightness).backgroundColor,
        body: SafeArea(
            child: Column(children: [
          Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      hintText: Tr.t('common.search'),
                      suffixIcon: Hero(
                          tag: 'search',
                          child: IconButton(
                              icon:
                                  SvgPicture.asset(AppIcons.search, height: 24),
                              onPressed: () {
                                Navigator.pop(context);
                              })))))
        ])));
  }
}
