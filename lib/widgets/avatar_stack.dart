import 'dart:math';
import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  final GlobalKey containerKey;
  final Widget? icon;
  final int? participantCount;
  final bool isLast;
  const AvatarStack(
      {super.key,
      required this.containerKey,
      this.icon,
      this.participantCount,
      this.isLast = false});
  @override
  Widget build(BuildContext context) {
    int count = min(5, participantCount ?? 0);

    return SizedBox(
        width: 35 + (6.5 * count),
        child: Stack(children: [
          if (participantCount != null)
            ...List.generate(count, (value) {
              double index = ((100 - (20 * value)) / 100);

              return Positioned(
                  left: 45 - (45 * index),
                  child: CircleAvatar(
                      backgroundColor:
                          Colors.grey.withAlpha((index * 255).toInt()),
                      radius: 14));
            }),
          if (icon != null) icon!
        ]));
  }
}
