import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class BibleNavigator extends StatelessWidget {
  final Function() toggleBibleNavigator;
  const BibleNavigator({super.key, required this.toggleBibleNavigator});

  @override
  Widget build(BuildContext context) {
    final bibleController = Provider.of<BibleController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final selectedPassage = bibleController.passage;

    double fontSize = 16.0;

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: const Color(0xFF7562AA),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButton(
              underline: const SizedBox(),
              icon: const SizedBox(),
              value: selectedPassage.book,
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF7562AA),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              items: bibleController.bible
                  .map((book) =>
                      DropdownMenuItem(value: book, child: Text(book.name)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  bibleController.setBook = value;
                  bibleController.setChapter = null;
                  bibleController.setVerse = null;
                  layoutController.scrollToTop();
                }
              })),
      DropdownButton(
          underline: const SizedBox(),
          iconEnabledColor: AppTheme(themeController.brightness).primaryColor,
          value: selectedPassage.chapter,
          style: TextStyle(
              color: AppTheme(themeController.brightness).primaryColor,
              fontSize: fontSize),
          dropdownColor: AppTheme(themeController.brightness).primaryPanelColor,
          items: selectedPassage.book.chapters.map((chapter) {
            final index = selectedPassage.book.chapters.indexOf(chapter);
            return DropdownMenuItem(
                value: index, child: Text((index + 1).toString()));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              AnalyticsService.logChapterOpened(
                  selectedPassage.book.name, value + 1);
            }
            bibleController.setChapter = value;
            bibleController.setVerse = null;
            layoutController.scrollToTop();
          }),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(':',
              style: TextStyle(
                  color: AppTheme(themeController.brightness).primaryColor,
                  fontSize: fontSize))),
      DropdownButton(
          underline: const SizedBox(),
          iconEnabledColor: AppTheme(themeController.brightness).primaryColor,
          value: selectedPassage.verse,
          style: TextStyle(
              color: AppTheme(themeController.brightness).primaryColor,
              fontSize: fontSize),
          dropdownColor: AppTheme(themeController.brightness).primaryPanelColor,
          items: selectedPassage.verses.map((verse) {
            final index = selectedPassage.verses.indexOf(verse);
            return DropdownMenuItem(
                value: index, child: Text((index + 1).toString()));
          }).toList(),
          onChanged: (value) {
            layoutController
                .scrollToVerse(layoutController.verseKeys[value ?? 0]);
            bibleController.setVerse = value;
            toggleBibleNavigator();
          })
    ]);
  }
}
