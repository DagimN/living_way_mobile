import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
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
      Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: contentController.activityList.length,
              itemBuilder: (context, index) {
                final content = contentController.activityList[index];
                final Widget childWidget;

                switch (content.type) {
                  case ContentType.gallery:
                    childWidget = Gallery(images: content.images);
                  case ContentType.article:
                    childWidget = const Article();
                  case ContentType.poll:
                    childWidget = Poll(content: content);
                  case ContentType.external:
                    childWidget = const ExternalLink();
                  case ContentType.event:
                    childWidget = const Event();
                  default:
                    childWidget = const SizedBox();
                }

                return TimelineContainer(
                    title: content.title ?? '',
                    timestamp: content.upcomingDate ?? content.timestamp,
                    isOngoing: content.isOngoing,
                    type: content.type,
                    isLast: index == contentController.activityList.length - 1,
                    child: childWidget);
              }))
    ]));
  }
}
