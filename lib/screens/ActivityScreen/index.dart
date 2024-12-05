import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/screens/ActivityScreen/widgets/article.dart';
import 'package:living_way/screens/ActivityScreen/widgets/event.dart';
import 'package:living_way/screens/ActivityScreen/widgets/external_link.dart';
import 'package:living_way/screens/ActivityScreen/widgets/gallery.dart';
import 'package:living_way/screens/ActivityScreen/widgets/poll.dart';
import 'package:living_way/screens/ActivityScreen/widgets/timeline_container.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final userProfile = Provider.of<ProfileController>(context).userProfile;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: const Text('Activities',
                style: TextStyle(
                    fontSize: 32,
                    color: lightPrimaryColor,
                    fontWeight: FontWeight.w300))),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded,
                color: lightPrimaryColor))
      ]),
      SizedBox(
          height: orientation == Orientation.portrait
              ? screenHeight * .74
              : screenWidth * .2,
          child: !contentController.isFetchingActivity ||
                  contentController.activityList.isNotEmpty
              ? ListView.builder(
                  controller: contentController.activityScrollController,
                  shrinkWrap: true,
                  itemCount: contentController.activityList.length + 1,
                  itemBuilder: (context, index) {
                    final content = contentController.activityList[index];
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
                        childWidget =
                            Poll(content: content, userProfile: userProfile);
                      case ContentType.external:
                        childWidget = ExternalLink(content: content);
                      case ContentType.event:
                        childWidget = Event(content: content);
                      default:
                        childWidget = const SizedBox();
                    }

                    return index < contentController.activityList.length
                        ? TimelineContainer(
                            title: content.title ?? '',
                            timestamp:
                                content.upcomingDate ?? content.timestamp,
                            isOngoing: content.isOngoing,
                            type: content.type,
                            isLast: index ==
                                contentController.activityList.length - 1,
                            child: childWidget)
                        : Container(
                            height: contentController.activityList.isEmpty
                                ? screenHeight * .65
                                : null,
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            child: !contentController.isFetchingActivity
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Image.asset(AppImages.activitiesEnd),
                                        //TODO: Add a cursive font
                                        Text(
                                            contentController
                                                    .activityList.isNotEmpty
                                                ? 'It all started here'
                                                : "Nothing to show yet.",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: lightPrimaryColor))
                                      ])
                                : const Center(
                                    child: CircularProgressIndicator(
                                        color: lightPrimaryColor)));
                  })
              : const Center(
                  child: CircularProgressIndicator(color: lightPrimaryColor)))
    ]));
  }
}
