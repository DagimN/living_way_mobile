import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/models/activity/index.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:living_way/core/utils/format_time.dart';
import 'package:living_way/widgets/avatar_stack.dart';
import 'package:provider/provider.dart';

class TimelineContainer extends StatelessWidget {
  final Activity activity;
  final Widget? child;
  final bool isLast;
  const TimelineContainer(
      {super.key, required this.activity, this.child, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    GlobalKey timelineKey = GlobalKey();
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final themeController = Provider.of<ThemeController>(context);

    IconData getIcon() {
      switch (activity.type) {
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
        child: Stack(
          children: [
            if (!isLast)
              Positioned(
                  top: 20,
                  bottom: 0,
                  left: 12,
                  child: Container(width: 1, color: Colors.grey)),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          (activity.title != null || activity.body != null)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    if (activity.title != null)
                                      SizedBox(
                                          width: screenWidth * .5,
                                          child: Text(activity.title ?? "",
                                              maxLines: 5,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                    if (activity.body != null && child == null)
                                      SizedBox(
                                          width: screenWidth * .5,
                                          child: Text(activity.body ?? "",
                                              maxLines: 5,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                  ],
                                )
                              : const SizedBox(),
                          Tooltip(
                              message: DateFormat("MMMM d, y 'at' h':'mm a")
                                  .format(activity.upcomingDate ??
                                      activity.timestamp),
                              triggerMode: TooltipTriggerMode.tap,
                              child: Text(
                                  !activity.isOngoing
                                      ? formatDateTime(activity.upcomingDate ??
                                          activity.timestamp)
                                      : 'Ongoing',
                                  style: TextStyle(
                                      fontSize: 8,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: activity.isOngoing
                                          ? FontWeight.bold
                                          : null)))
                        ])),
                const SizedBox(height: 12),
                child ?? const SizedBox()
              ])
            ]),
          ],
        ));
  }
}
