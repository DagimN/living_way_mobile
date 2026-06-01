import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class BibleTraverser extends StatefulWidget {
  const BibleTraverser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BibleTraverserState createState() => _BibleTraverserState();
}

class _BibleTraverserState extends State<BibleTraverser>
    with TickerProviderStateMixin {
  late final animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200), value: 1);
  late final widthAnimation =
      Tween(begin: 72.0, end: 144.0).animate(animationController);

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final bibleController = Provider.of<BibleController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final selectedPassage = bibleController.passage;

    final isTraversing = layoutController.getSelectedHomePageNavigation ==
        HomePageNavigation.bible;
    final isFirst = selectedPassage.chapter == 0;
    final isLast =
        selectedPassage.chapter == (selectedPassage.book.chapters.length) - 1;

    layoutController.setBibleTraverserAnimationController = animationController;

    return AnimatedBuilder(
        animation: widthAnimation,
        builder: (context, child) {
          return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  height: 56,
                  width: widthAnimation.value,
                  child: CustomPaint(
                      painter: _DiamondPainter(
                          isTraversing: isTraversing,
                          borderRadius: 9,
                          color: AppTheme(themeController.brightness)
                              .primaryColor),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isTraversing)
                              Expanded(
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        padding: EdgeInsets.zero),
                                    onPressed: () async {
                                      if (!isFirst) {
                                        bibleController.setChapter =
                                            selectedPassage.chapter - 1;
                                        AnalyticsService.logEvent(
                                            'chapter_navigated_back',
                                            parameters: {
                                              'book': selectedPassage.book.name,
                                              'chapter': selectedPassage.chapter
                                            });
                                      }
                                    },
                                    icon: Icon(Icons.arrow_back_ios_rounded,
                                        size: 14,
                                        color: isFirst
                                            ? Colors.grey
                                            : Colors.white)),
                              ),
                            IconButton(
                                style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                onPressed: () {
                                  layoutController
                                          .setSelectedHomePageNavigation =
                                      HomePageNavigation.bible;
                                },
                                icon: SvgPicture.asset(AppIcons.bible,
                                    height: 20,
                                    width: 20,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn))),
                            if (isTraversing)
                              Expanded(
                                  child: IconButton(
                                      style: IconButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      onPressed: () async {
                                        if (!isLast) {
                                          bibleController.setChapter =
                                              selectedPassage.chapter + 1;
                                          AnalyticsService.logEvent(
                                              'chapter_navigated_forward',
                                              parameters: {
                                                'book':
                                                    selectedPassage.book.name,
                                                'chapter':
                                                    selectedPassage.chapter + 2
                                              });
                                        }
                                      },
                                      icon: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: isLast
                                              ? Colors.grey
                                              : Colors.white)))
                          ]))));
        });
  }
}

class _DiamondPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final bool isTraversing;
  _DiamondPainter(
      {required this.borderRadius,
      required this.isTraversing,
      required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final verticalArcFactor = size.width / size.height;
    final horizontalArcFactor = size.height / size.width;

    final paint = Paint()..color = color;
    final path = Path()

      //Top Corner
      ..moveTo((size.width / 2) - borderRadius, borderRadius / 2)
      ..arcToPoint(Offset((size.width / 2) + borderRadius, borderRadius / 2),
          radius: Radius.circular(borderRadius * verticalArcFactor))

      //Right Corner
      ..lineTo(size.width - borderRadius, (size.height / 2) - borderRadius)
      ..arcToPoint(
          Offset(size.width - borderRadius, (size.height / 2) + borderRadius),
          radius: Radius.circular(borderRadius *
              (isTraversing ? horizontalArcFactor : verticalArcFactor)))

      //Bottom Corner
      ..lineTo(
          (size.width / 2) + borderRadius, size.height - (borderRadius / 2))
      ..arcToPoint(
          Offset((size.width / 2) - borderRadius,
              size.height - (borderRadius / 2)),
          radius: Radius.circular(borderRadius * verticalArcFactor))

      //Left Corner
      ..lineTo(borderRadius, (size.height / 2) + borderRadius)
      ..arcToPoint(Offset(borderRadius, (size.height / 2) - borderRadius),
          radius: Radius.circular(borderRadius *
              (isTraversing ? horizontalArcFactor : verticalArcFactor)));

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
