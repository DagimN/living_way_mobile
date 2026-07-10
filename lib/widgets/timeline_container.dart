import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/avatar_stack.dart';
import 'package:provider/provider.dart';

class TimelineContainer extends StatelessWidget {
  final Activity activity;
  final EdgeInsetsGeometry? margin;
  final bool isLast;
  const TimelineContainer(
      {super.key, required this.activity, this.isLast = false, this.margin});

  @override
  Widget build(BuildContext context) {
    GlobalKey timelineKey = GlobalKey();
    double screenWidth = MediaQuery.of(context).size.width;

    final themeController = Provider.of<ThemeController>(context);
    final profileController = Provider.of<ProfileController>(context);
    final theme = AppTheme(themeController.brightness);
    final child = activity.getChild(profile: profileController.userProfile);

    return Container(
        key: timelineKey,
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                  icon: Icon(activity.icon, color: theme.primaryColor),
                  isLast: isLast),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                (activity.title != null || activity.body != null)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          if (activity.title != null)
                            SizedBox(
                                width: screenWidth * .8,
                                child: Text(activity.title ?? "",
                                    maxLines: 5,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: theme.primaryColor))),
                          if (activity.body != null)
                            SizedBox(
                                width: screenWidth * .8,
                                child: Text(activity.body ?? "",
                                    maxLines: 5,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: child == null
                                            ? theme.accentColor
                                            : theme.primaryColor))),
                        ],
                      )
                    : const SizedBox(),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 12),
                  child: Tooltip(
                      message: DateFormat("MMMM d, y 'at' h':'mm a")
                          .format(activity.upcomingDate ?? activity.timestamp),
                      triggerMode: TooltipTriggerMode.tap,
                      child: Text(
                          !activity.isOngoing
                              ? formatDateTime(
                                  activity.upcomingDate ?? activity.timestamp)
                              : Tr.t('messages.ongoing'),
                          style: TextStyle(
                              fontSize: 8,
                              fontStyle: FontStyle.italic,
                              color: theme.primaryColor,
                              fontWeight: activity.isOngoing
                                  ? FontWeight.bold
                                  : FontWeight.w700))),
                ),
                child ?? const SizedBox()
              ])
            ]),
          ],
        ));
  }
}
