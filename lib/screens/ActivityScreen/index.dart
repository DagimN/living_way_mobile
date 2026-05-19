import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/article.dart';
import 'widgets/event.dart';
import 'widgets/external_link.dart';
import 'widgets/gallery.dart';
import 'widgets/poll.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityController = Provider.of<ActivityController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final userProfile = Provider.of<ProfileController>(context).userProfile;
    final activityList = activityController.activityList;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Column(children: [
      SizedBox(height: screenHeight * .05),
      BaseAppBar(
          title: Container(
              margin: const EdgeInsets.all(10),
              child: Text('Activities',
                  style: TextStyle(
                      fontSize: 32,
                      color: AppTheme(themeController.brightness).primaryColor,
                      fontWeight: FontWeight.w300)))),
      SizedBox(
          height: orientation == Orientation.portrait
              ? screenHeight * .8
              : screenWidth * .2,
          child: !activityController.isFetching || activityList.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
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
                        final Widget? childWidget;

                        switch (activity.type) {
                          case ContentType.gallery:
                            childWidget = Gallery(
                                images: activity.images,
                                minimumAllowedImagesForView:
                                    activity.minimumAllowedViewImages);
                          case ContentType.article:
                            childWidget = Article(content: activity);
                          case ContentType.poll:
                            childWidget = Poll(
                                content: activity, userProfile: userProfile);
                          case ContentType.external:
                            childWidget = ExternalLink(content: activity);
                          case ContentType.event:
                            childWidget = Event(content: activity);
                          default:
                            childWidget = null;
                        }

                        return index < activityList.length
                            ? TimelineContainer(
                                activity: activity,
                                isLast: index == activityList.length - 1,
                                child: childWidget)
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
                                            //TODO: Add a cursive font
                                            Text(
                                                activityList.isNotEmpty
                                                    ? 'It all started here'
                                                    : "Nothing to show yet.",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppTheme(
                                                            themeController
                                                                .brightness)
                                                        .primaryColor)),
                                            if (activityList.isEmpty)
                                              IconButton(
                                                  icon: Icon(Icons.refresh,
                                                      color: AppTheme(
                                                              themeController
                                                                  .brightness)
                                                          .primaryColor),
                                                  onPressed: () {
                                                    activityController
                                                        .fetchActivities(
                                                            isRefreshing: true);
                                                  })
                                          ])
                                    : Center(
                                        child: CircularProgressIndicator(
                                            color: AppTheme(
                                                    themeController.brightness)
                                                .primaryColor)));
                      }))
              : Center(
                  child: CircularProgressIndicator(
                      color:
                          AppTheme(themeController.brightness).primaryColor)))
    ]);
  }
}
