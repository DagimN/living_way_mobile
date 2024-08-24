import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class BibleNavigator extends StatelessWidget {
  const BibleNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final selectedBook =
        contentController.book ?? contentController.bible.first;
    final selectedChapter = contentController.chapter ?? 0;

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
              value: contentController.book ?? contentController.bible[0],
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF7562AA),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              items: contentController.bible
                  .map((book) =>
                      DropdownMenuItem(value: book, child: Text(book.name)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  contentController.setBook = value;
                  contentController.setChapter = null;
                  contentController.setVerse = null;
                  layoutController.scrollToTop();
                }
              })),
      //TODO: Make button obvious
      DropdownButton(
          underline: const SizedBox(),
          iconEnabledColor: lightPrimaryColor,
          value: contentController.chapter ?? 0,
          style: TextStyle(color: lightPrimaryColor, fontSize: fontSize),
          dropdownColor: lightPrimaryPanelColor,
          items: selectedBook.chapters.map((chapter) {
            final index = selectedBook.chapters.indexOf(chapter);
            return DropdownMenuItem(
                value: index, child: Text((index + 1).toString()));
          }).toList(),
          onChanged: (value) {
            contentController.setChapter = value;
            contentController.setVerse = null;
            layoutController.scrollToTop();
          }),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(':',
              style: TextStyle(color: lightPrimaryColor, fontSize: fontSize))),
      //TODO: Make button obvious
      DropdownButton(
          underline: const SizedBox(),
          iconEnabledColor: lightPrimaryColor,
          value: contentController.verse ?? 0,
          style: TextStyle(color: lightPrimaryColor, fontSize: fontSize),
          dropdownColor: lightPrimaryPanelColor,
          items: selectedBook.chapters[selectedChapter].map((verse) {
            final index = selectedBook.chapters[selectedChapter].indexOf(verse);
            return DropdownMenuItem(
                value: index, child: Text((index + 1).toString()));
          }).toList(),
          onChanged: (value) {
            layoutController
                .scrollToVerse(layoutController.verseKeys[value ?? 0]);
            contentController.setVerse = value;
          })
    ]);
  }
}
