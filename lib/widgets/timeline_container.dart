import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/avatar_stack.dart';
import 'package:provider/provider.dart';

class TimelineContainer extends StatefulWidget {
  final Activity activity;
  final EdgeInsetsGeometry? margin;
  final bool isLast;
  const TimelineContainer(
      {super.key, required this.activity, this.isLast = false, this.margin});

  @override
  State<TimelineContainer> createState() => _TimelineContainerState();
}

class _TimelineContainerState extends State<TimelineContainer> {
  late final activity = widget.activity;

  void rsvp(Profile? user) async {
    final theme = Provider.of<ThemeController>(context, listen: false).theme;

    if (user == null) {
      UIService.showSnackbar(
          backgroundColor: theme.failedColor,
          message: Tr.t("interactionLoginError"));
      return;
    }

    final isCancelling = activity.rsvp.contains(user.id);
    setState(() {
      if (isCancelling) {
        activity.rsvp.remove(user.id);
      } else {
        activity.rsvp.add(user.id);
      }
    });

    final success = await activity.update();

    if (!success) {
      UIService.showSnackbar(
          backgroundColor: theme.failedColor,
          message: Tr.t("rsvpUpdateFailed"));
      setState(() {
        if (activity.rsvp.contains(user.id)) {
          activity.rsvp.remove(user.id);
        } else {
          activity.rsvp.add(user.id);
        }
      });
    } else {
      UIService.showSnackbar(
          backgroundColor: theme.successColor,
          message: Tr.t(isCancelling ? "rsvpCancelled" : "rsvpConfirmed"));
      // ignore: use_build_context_synchronously
      Provider.of<ActivityController>(context, listen: false)
          .activityList
          .addOrReplace(activity, (item) => item.id == activity.id);
    }
  }

  Future<void> confirmRsvp(Profile? user) async {
    if (user == null) {
      rsvp(user);
      return;
    }

    final isGoing = activity.rsvp.contains(user.id);
    final theme = Provider.of<ThemeController>(context, listen: false).theme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.backgroundColor,
        title: Text(
          Tr.t(isGoing ? "rsvpCancelTitle" : "rsvpGoingTitle"),
          style: TextStyle(color: theme.accentColor),
        ),
        content: Text(
          Tr.named(
            isGoing ? "rsvpCancelMessage" : "rsvpGoingMessage",
            {"event": activity.title ?? Tr.t("rsvpDefaultEventName")},
          ),
          style: TextStyle(color: theme.accentColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              Tr.t(isGoing ? "rsvpKeep" : "notNow"),
              style: TextStyle(color: theme.accentColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              Tr.t(isGoing ? "rsvpCancelAction" : "rsvpGoingConfirmation"),
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      rsvp(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey timelineKey = GlobalKey();
    double screenWidth = MediaQuery.of(context).size.width;

    final theme = Provider.of<ThemeController>(context).theme;
    final profileController = Provider.of<ProfileController>(context);

    final child = activity.getChild(profile: profileController.userProfile);
    final canBeRSVPd = activity.type == ContentType.event &&
        (activity.isOngoing ||
            (activity.upcomingDate?.isAfter(DateTime.now()) ?? false));

    return Container(
        key: timelineKey,
        margin: widget.margin ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Stack(
          children: [
            if (!widget.isLast)
              Positioned(
                  top: 20,
                  bottom: 0,
                  left: 12,
                  child: Container(width: 1, color: Colors.grey)),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AvatarStack(
                  containerKey: timelineKey,
                  icon: Icon(activity.icon, color: theme.primaryColor),
                  isLast: widget.isLast),
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
                      message: DateFormat(
                              "MMMM d, y '${Tr.t('dateAt')}' h':'mm a")
                          .format(activity.upcomingDate ?? activity.timestamp),
                      triggerMode: TooltipTriggerMode.tap,
                      child: Text(
                          !activity.isOngoing
                              ? formatDateTime(
                                  activity.upcomingDate ?? activity.timestamp)
                              : Tr.t('ongoing'),
                          style: TextStyle(
                              fontSize: 8,
                              fontStyle: FontStyle.italic,
                              color: theme.primaryColor,
                              fontWeight: activity.isOngoing
                                  ? FontWeight.bold
                                  : FontWeight.w700))),
                ),
                child ?? const SizedBox(),
                if (canBeRSVPd)
                  ElevatedButton(
                      onPressed: () =>
                          confirmRsvp(profileController.userProfile),
                      child: Text(activity.rsvp
                              .contains(profileController.userProfile?.id)
                          ? Tr.t("rsvpCancelAction")
                          : Tr.t("rsvpGoingButton")))
              ])
            ]),
          ],
        ));
  }
}
