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

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: Column(children: [
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
              ? screenHeight * .7
              : screenWidth * .2,
          child: !activityController.isFetching ||
                  activityController.activityList.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    return await activityController.fetchActivities(
                        isRefreshing: true);
                  },
                  child: ListView.builder(
                      controller: activityController.scrollController,
                      shrinkWrap: true,
                      itemCount: activityController.activityList.length + 1,
                      itemBuilder: (context, index) {
                        final content =
                            activityController.activityList.length > index
                                ? activityController.activityList[index]
                                : ActivityContent(
                                    id: '',
                                    type: ContentType.undefined,
                                    timestamp: DateTime.now());
                        final Widget childWidget;

                        switch (content.type) {
                          case ContentType.gallery:
                            childWidget = Gallery(
                                images: content.images,
                                minimumAllowedImagesForView:
                                    content.minimumAllowedViewImages);
                          case ContentType.article:
                            childWidget = Article(content: content);
                          case ContentType.poll:
                            childWidget = Poll(
                                content: content, userProfile: userProfile);
                          case ContentType.external:
                            childWidget = ExternalLink(content: content);
                          case ContentType.event:
                            childWidget = Event(content: content);
                          default:
                            childWidget = const SizedBox();
                        }

                        return index < activityController.activityList.length
                            ? TimelineContainer(
                                title: content.title ?? '',
                                timestamp:
                                    content.upcomingDate ?? content.timestamp,
                                isOngoing: content.isOngoing,
                                type: content.type,
                                isLast: index ==
                                    activityController.activityList.length - 1,
                                child: childWidget)
                            : Container(
                                height: activityController.activityList.isEmpty
                                    ? screenHeight * .65
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
                                                activityController
                                                        .activityList.isNotEmpty
                                                    ? 'It all started here'
                                                    : "Nothing to show yet.",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppTheme(
                                                            themeController
                                                                .brightness)
                                                        .primaryColor)),
                                            if (activityController
                                                .activityList.isEmpty)
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
    ]));
  }
}
