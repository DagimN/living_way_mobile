import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityController = Provider.of<ActivityController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final activityList = activityController.activityList;
    final theme = AppTheme(themeController.brightness);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Column(children: [
      SizedBox(height: screenHeight * .05),
      BaseAppBar(
          title: Container(
              margin: const EdgeInsets.all(10),
              child: Text(Tr.t('activities'),
                  style: TextStyle(
                      fontSize: 32,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w300))),
          actions: const [SearchButton()]),
      SizedBox(
          height: orientation == Orientation.portrait
              ? screenHeight * .8
              : screenWidth * .2,
          child: !activityController.isFetching || activityList.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    AnalyticsService.logEvent('activity_pull_to_refresh');
                    return await activityController.fetchActivities(
                        isRefreshing: true);
                  },
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: activityController.scrollController,
                      itemCount: activityList.length + 1,
                      itemBuilder: (context, index) {
                        final activity = activityList.length > index
                            ? activityList[index]
                            : Activity(
                                id: '',
                                type: ContentType.undefined,
                                timestamp: DateTime.now());

                        return index < activityList.length
                            ? TimelineContainer(
                                activity: activity,
                                isLast: index == activityList.length - 1)
                            : Container(
                                height: activityList.isEmpty
                                    ? screenHeight * .55
                                    : null,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 24),
                                child: !activityController.isFetching
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 16),
                                                child: Image.asset(
                                                    AppImages.activitiesEnd)),
                                            Text(
                                                activityList.isNotEmpty
                                                    ? Tr.t('startMessage')
                                                    : Tr.t(
                                                        'noActivitiesMessage'),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: theme.primaryColor)),
                                            if (activityList.isEmpty)
                                              IconButton(
                                                  icon: Icon(Icons.refresh,
                                                      color:
                                                          theme.primaryColor),
                                                  onPressed: () async {
                                                    activityController
                                                        .fetchActivities(
                                                            isRefreshing: true);
                                                    await AnalyticsService
                                                        .logEvent(
                                                            'activity_refresh');
                                                  })
                                          ])
                                    : Center(
                                        child: CircularProgressIndicator(
                                            color: theme.primaryColor)));
                      }))
              : Center(
                  child: CircularProgressIndicator(color: theme.primaryColor)))
    ]);
  }
}
