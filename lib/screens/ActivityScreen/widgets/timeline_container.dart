import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/utils/format_time.dart';
import 'package:living_way/widgets/avatar_stack.dart';

class TimelineContainer extends StatelessWidget {
  final String title;
  final DateTime timestamp;
  final Widget child;
  final bool isOngoing;
  final bool isLast;
  const TimelineContainer(
      {super.key,
      required this.title,
      required this.child,
      required this.timestamp,
      required this.isOngoing,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    GlobalKey timelineKey = GlobalKey();
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
        key: timelineKey,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarStack(
              containerKey: timelineKey, participantCount: 1, isLast: isLast),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: orientation == Orientation.portrait
                    ? screenWidth * .75
                    : screenWidth * .85,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14)),
                      Tooltip(
                        message: DateFormat("MMMM d, y 'at' h':'m a")
                            .format(timestamp),
                        triggerMode: TooltipTriggerMode.tap,
                        child: Text(
                            !isOngoing ? formatDateTime(timestamp) : 'Ongoing',
                            style: TextStyle(
                                fontSize: 8,
                                fontStyle: FontStyle.italic,
                                fontWeight:
                                    isOngoing ? FontWeight.bold : null)),
                      )
                    ])),
            const SizedBox(height: 24),
            child
          ])
        ]));
  }
}
