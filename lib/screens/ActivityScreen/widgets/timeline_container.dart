import 'package:flutter/material.dart';
import 'package:living_way/widgets/avatar_stack.dart';

class TimelineContainer extends StatelessWidget {
  final String title;
  final DateTime timestamp;
  final Widget child;
  final bool isLast;
  const TimelineContainer(
      {super.key,
      required this.title,
      required this.child,
      required this.timestamp,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    GlobalKey timelineKey = GlobalKey();

    return Container(
        key: timelineKey,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarStack(
              containerKey: timelineKey, participantCount: 1, isLast: isLast),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              Text(timestamp.toString(), style: const TextStyle(fontSize: 8))
            ]),
            const SizedBox(height: 24),
            child
          ])
        ]));
  }
}
