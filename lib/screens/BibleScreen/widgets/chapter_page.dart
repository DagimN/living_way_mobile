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

  @override
  Widget build(BuildContext context) {
    final bibleController = Provider.of<BibleController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final selectedPassage = bibleController.passage;

    double screenHeight = MediaQuery.sizeOf(context).height;

    List<GlobalObjectKey> verseKeys = List.generate(
        selectedPassage.verses.length,
        (index) => GlobalObjectKey(
            '${selectedPassage.book.name} ${selectedPassage.chapter} ${index + 1}'));
    layoutController.setVerseKeys = verseKeys;
    layoutController.setVerseAnimationController = verseHighlightController;

    return Container(
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
                                          fontFamily:
                                              themeController.selectedFont.name,
                                          color: isSelectedVerse
                                              ? AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor
                                                  .withAlpha(
                                                      (verseHighlightController
                                                                  .value *
                                                              255)
                                                          .toInt()),
                                          fontSize:
                                              80 * themeController.textSize)),
                                  TextSpan(
                                      text: verse,
                                      style: TextStyle(
                                          fontSize:
                                              47 * themeController.textSize,
                                          fontFamily:
                                              themeController.selectedFont.name,
                                          color: isSelectedVerse
                                              ? Colors.black
                                              : Colors.black.withAlpha(
                                                  (verseHighlightController
                                                              .value *
                                                          255)
                                                      .toInt())))
                                ])));
                      });
                }).toList())));
  }
}
