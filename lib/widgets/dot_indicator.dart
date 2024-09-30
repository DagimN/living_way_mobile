import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final List<Widget> pages;
  final double dotRadius;
  final void Function()? onDotTap;
  const DotIndicator(
      {super.key,
      required this.pages,
      required this.dotRadius,
      this.onDotTap,
      this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        alignment: Alignment.center,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: pages.map((page) {
              final index = pages.indexOf(page);

              return GestureDetector(
                onTap: onDotTap,
                child: Container(
                    height: dotRadius,
                    width: dotRadius,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: index == currentIndex
                            ? Colors.grey
                            : Colors.grey[300],
                        shape: BoxShape.circle)),
              );
            }).toList())));
  }
}
