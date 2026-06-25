import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/story_list_view.dart';
import 'widgets/topics_listview.dart';
import 'widgets/updates_viewer.dart';

class DailyFeedScreen extends StatelessWidget {
  const DailyFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final activityController = Provider.of<ActivityController>(context);
    final contentController = Provider.of<ContentController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    List<Activity> upcomingActivities = activityController.activityList
        .where((activity) =>
            ((activity.upcomingDate ?? activity.timestamp).isAfter(
                        DateTime.now().subtract(const Duration(days: 1))) ||
                    activity.isRecurring) &&
                activity.type == ContentType.event ||
            activity.type == ContentType.general)
        .toList();
    List<Activity> updates = activityController.activityList
        .where((activity) =>
            (activity.isOngoing ||
                activity.timestamp.isAfter(DateTime.now())) &&
            activity.banner != null)
        .toList();
    upcomingActivities.sort((activityA, activityB) =>
        activityA.timestamp.compareTo(activityB.timestamp));

    return SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.only(bottom: 100),
        child: SizedBox(
            height: orientation == Orientation.portrait
                ? screenHeight * .9
                : screenHeight * .7,
            child: RefreshIndicator(
              onRefresh: () async {
                AnalyticsService.logEvent('daily_feed_refreshed');
                await contentController.fetchStories(isRefreshing: true);
                await activityController.fetchActivities(isRefreshing: true);
              },
              child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                UpdatesViewer(updates: updates),
                BaseAppBar(
                    title: Text(Tr.t('navigation.home'),
                        style: TextStyle(
                            fontSize: 32,
                            color: AppTheme(themeController.brightness)
                                .accentColor,
                            fontWeight: FontWeight.w400)),
                    actions: const [SearchButton()]),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: upcomingActivities.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final activity = upcomingActivities[index];

                      return TimelineContainer(
                        activity: activity,
                        isLast: index == upcomingActivities.length - 1,
                      );
                    }),
                const Padding(
                    padding: EdgeInsets.all(8.0), child: StoryListView()),
                const TopicsListview(),
                const SizedBox(height: 70)
              ])),
            )));
  }
}
