import 'package:flutter/material.dart';

class DotIndicator extends StatefulWidget {
  final int currentIndex;
  final List<Widget> pages;
  final double dotRadius;
  final void Function()? onDotTap;
  final Color activeColor;
  final Color inactiveColor;
  final bool animate;
  final void Function()? onAnimationEnd;
  const DotIndicator(
      {super.key,
      required this.pages,
      required this.dotRadius,
      this.onDotTap,
      this.currentIndex = 0,
      this.activeColor = Colors.white,
      this.inactiveColor = Colors.grey,
      this.animate = false,
      this.onAnimationEnd});

  @override
  State<DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<DotIndicator>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      animationController = AnimationController(
          vsync: this, duration: const Duration(seconds: 10));
      animationController!.repeat();
      animationController!.addListener(animationListener);
    }
  }

  void animationListener() {
    bool isCompleted = animationController!.value >= 0.995;

    if (isCompleted && widget.onAnimationEnd != null) {
      widget.onAnimationEnd!();
    }
  }

  @override
  void dispose() {
    animationController?.removeListener(animationListener);
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        alignment: Alignment.center,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: widget.pages.indexed.map((item) {
              final index = item.$1;
              final isActive = index == widget.currentIndex;

              return GestureDetector(
                onTap: widget.onDotTap,
                child: Stack(
                  children: [
                    Container(
                        height: widget.dotRadius,
                        width:
                            isActive ? widget.dotRadius * 3 : widget.dotRadius,
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: widget.inactiveColor,
                            shape:
                                isActive ? BoxShape.rectangle : BoxShape.circle,
                            borderRadius: isActive
                                ? BorderRadius.circular(widget.dotRadius / 2)
                                : null)),
                    if (isActive && widget.animate && animationController != null)
                      AnimatedBuilder(
                          animation: animationController!,
                          builder: (context, child) {
                            return Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                  height: widget.dotRadius,
                                  width: (widget.dotRadius * 3) *
                                      animationController!.value,
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: widget.activeColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                          widget.dotRadius / 2))),
                            );
                          }),
                  ],
                ),
              );
            }).toList())));
  }
}
