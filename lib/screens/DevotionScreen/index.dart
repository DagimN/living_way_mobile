import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/screens/screens.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/story_list_view.dart';
import 'widgets/topics_listview.dart';
import 'widgets/updates_viewer.dart';

class DevotionScreen extends StatelessWidget {
  const DevotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final activityController = Provider.of<ActivityController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    List<ActivityContent> updates = activityController.activityList
        .where((activity) => activity.isOngoing && activity.banner != null)
        .toList();

    return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: SizedBox(
            height: orientation == Orientation.portrait
                ? screenHeight * .9
                : screenHeight * .7,
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              UpdatesViewer(updates: updates),
              BaseAppBar(
                  title: Text('Home',
                      style: TextStyle(
                          fontSize: 32,
                          color: AppTheme(themeController.brightness).iconColor,
                          fontWeight: FontWeight.w400)),
                  actions: [
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
              const Padding(
                  padding: EdgeInsets.all(8.0), child: StoryListView()),
              const TopicsListview(),
              const SizedBox(height: 70)
            ]))));
  }
}
