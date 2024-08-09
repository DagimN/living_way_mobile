import 'dart:math';
import 'package:flutter/material.dart';

class AvatarStack extends StatefulWidget {
  final GlobalKey containerKey;
  final int participantCount;
  final bool isLast;
  const AvatarStack(
      {super.key,
      required this.containerKey,
      required this.participantCount,
      this.isLast = false});

  @override
  State<AvatarStack> createState() => _AvatarStackState();
}

class _AvatarStackState extends State<AvatarStack> {
  double? threadContainerHeight;
  bool isResetted = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (threadContainerHeight == null && !widget.isLast && mounted) {
        setState(() {
          threadContainerHeight = (widget.containerKey.currentContext!
                  .findRenderObject() as RenderBox)
              .size
              .height;
        });
      }
    });

    int count = min(5, widget.participantCount);

    return SizedBox(
        width: 35 + (6.5 * count),
        height: threadContainerHeight ?? 60,
        child: Stack(children: [
          ...List.generate(count, (value) {
            double index = (100 - (20 * value)) / 100;
            return Positioned(
                left: 45 - (45 * index),
                child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(index),
                    radius: 14));
          }),
          if (!widget.isLast)
            Positioned(
                top: 14,
                left: 12,
                child: Container(
                    height: threadContainerHeight,
                    width: 1,
                    color: Colors.grey))
        ]));
  }
}
