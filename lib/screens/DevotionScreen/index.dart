import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/screens/DevotionScreen/widgets/topics_listview.dart';
import 'package:living_way/screens/DevotionScreen/widgets/updates_viewer.dart';
import 'package:living_way/screens/search_screen.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:living_way/widgets/base_app_bar.dart';
import 'package:provider/provider.dart';

class DevotionScreen extends StatelessWidget {
  const DevotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: SizedBox(
            height: orientation == Orientation.portrait
                ? screenHeight * .8
                : screenHeight * .7,
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              const UpdatesViewer(),
              BaseAppBar(
                  title: Text('Today',
                      style: TextStyle(
                          fontSize: 32,
                          color: AppTheme(themeController.brightness).iconColor,
                          fontWeight: FontWeight.w400)), actions: [
                            Hero(
                        tag: 'search',
                        child: IconButton(
                            style:
                                IconButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      pageBuilder: (_, __, ___) =>
                                          const SearchScreen()));
                            },
                            icon: SvgPicture.asset(AppIcons.search,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                    AppTheme(themeController.brightness)
                                        .iconColor,
                                    BlendMode.srcIn))))
                          ]),
              const TopicsListview()
            ]))));
  }
}
