import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/models/activity_content.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:living_way/core/utils/format_time.dart';
import 'package:living_way/widgets/avatar_stack.dart';
import 'package:provider/provider.dart';

class TimelineContainer extends StatelessWidget {
  final String title;
  final DateTime timestamp;
  final Widget child;
  final ContentType type;
  final bool isOngoing;
  final bool isLast;
  const TimelineContainer(
      {super.key,
      required this.title,
      required this.child,
      required this.type,
      required this.timestamp,
      required this.isOngoing,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    GlobalKey timelineKey = GlobalKey();
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final themeController = Provider.of<ThemeController>(context);

    IconData getIcon() {
      switch (type) {
        case ContentType.external:
          return Icons.link;
        case ContentType.poll:
          return Icons.poll;
        case ContentType.gallery:
          return Icons.photo;
        case ContentType.article:
          return Icons.article;
        case ContentType.general:
          return Icons.radio_button_checked;
        default:
          return Icons.calendar_month;
      }
    }

    return Container(
        key: timelineKey,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarStack(
              containerKey: timelineKey,
              icon: Icon(getIcon(),
                  color: AppTheme(themeController.brightness).primaryColor),
              isLast: isLast),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: orientation == Orientation.portrait
                    ? screenWidth * .75
                    : screenWidth * .85,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: screenWidth * .5,
                          child: Text(title,
                              maxLines: 5,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400))),
                      Tooltip(
                          message: DateFormat("MMMM d, y 'at' h':'m a")
                              .format(timestamp),
                          triggerMode: TooltipTriggerMode.tap,
                          child: Text(
                              !isOngoing
                                  ? formatDateTime(timestamp)
                                  : 'Ongoing',
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  fontWeight:
                                      isOngoing ? FontWeight.bold : null)))
                    ])),
            const SizedBox(height: 12),
            child
          ])
        ]));
  }
}
