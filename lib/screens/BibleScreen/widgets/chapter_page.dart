import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/app_theme.dart';
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
    final contentController = Provider.of<ContentController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final selectedVerse = contentController.verse;
    final selectedBook =
        contentController.book ?? contentController.bible.firstOrNull;
    final selectedChapter = contentController.chapter ?? 0;

    List<GlobalKey> verseKeys = List.generate(
        selectedBook?.chapters[selectedChapter].length ?? 0,
        (index) => GlobalKey());
    layoutController.setVerseKeys = verseKeys;
    layoutController.setVerseAnimationController = verseHighlightController;

    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                controller: layoutController.scrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.verses.map((verse) {
                      final index = widget.verses.indexOf(verse);

                      return AnimatedBuilder(
                          animation: verseHighlightController,
                          builder: (context, child) {
                            final isSelectedVerse = selectedVerse == index;

                            return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: RichText(
                                    key: verseKeys[index],
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: '${index + 1} ',
                                          style: TextStyle(
                                              fontFamily: themeController
                                                  .selectedFont.name,
                                              color: isSelectedVerse
                                                  ? AppTheme(themeController
                                                          .brightness)
                                                      .primaryColor
                                                  : AppTheme(themeController
                                                          .brightness)
                                                      .primaryColor
                                                      .withAlpha(
                                                          verseHighlightController
                                                              .value
                                                              .toInt()),
                                              fontSize: 80 *
                                                  themeController.textSize)),
                                      TextSpan(
                                          text: verse,
                                          style: TextStyle(
                                              fontSize:
                                                  47 * themeController.textSize,
                                              fontFamily: themeController
                                                  .selectedFont.name,
                                              color: isSelectedVerse
                                                  ? Colors.black
                                                  : Colors.black.withOpacity(
                                                      verseHighlightController
                                                          .value)))
                                    ])));
                          });
                    }).toList()))));
  }
}
