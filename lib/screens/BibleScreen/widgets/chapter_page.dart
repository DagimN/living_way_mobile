import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class ChapterPage extends StatefulWidget {
  final List<String> verses;
  const ChapterPage({super.key, required this.verses});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage>
    with TickerProviderStateMixin {
  late AnimationController verseHighlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.3,
      value: 1);

  double _dragOffset = 0;
  double _dragStartX = 0;
  static const double _swipeThreshold = 90;

  void _navigateChapter(bool forward, LayoutController layoutController) {
    final bibleController =
        Provider.of<BibleController>(context, listen: false);
    final selectedPassage = bibleController.passage;
    final targetChapter = selectedPassage.chapter + (forward ? 1 : -1);

    AnalyticsService.logChapterOpened(selectedPassage.book.name, targetChapter,
        params: {
          "usedSwipeToTurn": true,
        });

    if (targetChapter < 0 ||
        targetChapter >= selectedPassage.book.chapters.length) {
      setState(() {
        _dragOffset = 0;
      });
      return;
    }

    layoutController.bibleScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );

    bibleController.setChapter = targetChapter;
    setState(() {
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bibleController = Provider.of<BibleController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);
    final selectedPassage = bibleController.passage;

    double screenHeight = MediaQuery.sizeOf(context).height;

    List<GlobalObjectKey> verseKeys = List.generate(
        selectedPassage.verses.length,
        (index) => GlobalObjectKey(
            '${selectedPassage.book.name} ${selectedPassage.chapter} ${index + 1}'));
    layoutController.setVerseKeys = verseKeys;
    layoutController.setVerseAnimationController = verseHighlightController;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        setState(() {
          _dragStartX = details.globalPosition.dx;
          _dragOffset = 0;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset = details.globalPosition.dx - _dragStartX;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragOffset.abs() > _swipeThreshold) {
          _navigateChapter(_dragOffset < 0, layoutController);
        } else {
          setState(() {
            _dragOffset = 0;
          });
        }
      },
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          height: screenHeight * .8,
          child: SingleChildScrollView(
            controller: layoutController.bibleScrollController,
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.verses.map((verse) {
                final index = widget.verses.indexOf(verse);

                return AnimatedBuilder(
                  animation: verseHighlightController,
                  builder: (context, child) {
                    final isSelectedVerse = selectedPassage.verse == index;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: RichText(
                        key: verseKeys[index],
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${index + 1} ',
                            style: TextStyle(
                              fontFamily: themeController.selectedFont.name,
                              color: isSelectedVerse
                                  ? AppTheme(themeController.brightness)
                                      .primaryColor
                                  : AppTheme(themeController.brightness)
                                      .primaryColor
                                      .withAlpha(
                                          (verseHighlightController.value * 255)
                                              .toInt()),
                              fontSize: 80 * themeController.textSize,
                            ),
                          ),
                          TextSpan(
                            text: verse,
                            style: TextStyle(
                              fontSize: 47 * themeController.textSize,
                              fontFamily: themeController.selectedFont.name,
                              color: isSelectedVerse
                                  ? theme.accentColor
                                  : theme.accentColor.withAlpha(
                                      (verseHighlightController.value * 255)
                                          .toInt()),
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
