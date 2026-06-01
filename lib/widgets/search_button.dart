import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/screens.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Hero(
        tag: 'search',
        child: IconButton(
            style: IconButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () async {
              AnalyticsService.logEvent('search_opened');
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => const SearchScreen()));
            },
            icon: SvgPicture.asset(AppIcons.search,
                height: 24,
                colorFilter: ColorFilter.mode(
                    AppTheme(themeController.brightness).iconColor,
                    BlendMode.srcIn))));
  }
}
