import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class BibleNavigator extends StatelessWidget {
  const BibleNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    double fontSize = 16.0;

    return Row(children: [
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
              padding: const EdgeInsets.only(left: 10),
              items: contentController.bible
                  .map((book) =>
                      DropdownMenuItem(value: book, child: Text(book.name)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  contentController.setBook = value;
                  contentController.setChapter = null;
                  contentController.setVerse = null;
                }
              })),
      //FIXME: When the app loads, populate the chapter indexes
      DropdownButton(
          underline: const SizedBox(),
          icon: const SizedBox(),
          value: contentController.chapter ?? 0,
          style: TextStyle(color: lightPrimaryColor, fontSize: fontSize),
          dropdownColor: lightPrimaryPanelColor,
          items: contentController.book?.chapters.map((chapter) {
            final index =
                contentController.book?.chapters.indexOf(chapter) ?? 0;
            return DropdownMenuItem(
                value: index, child: Text((index + 1).toString()));
          }).toList(),
          onChanged: (value) {
            contentController.setChapter = value;
            contentController.setVerse = null;
          }),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(':',
              style: TextStyle(color: lightPrimaryColor, fontSize: fontSize))),
      //FIXME: When the app loads, populate the verse indexes
      DropdownButton(
          underline: const SizedBox(),
          icon: const SizedBox(),
          value: contentController.verse ?? 0,
          style: TextStyle(color: lightPrimaryColor, fontSize: fontSize),
          dropdownColor: lightPrimaryPanelColor,
          items: contentController
              .book?.chapters[contentController.chapter ?? 0]
              .map((verse) {
            final index = contentController
                    .book?.chapters[contentController.chapter ?? 0]
                    .indexOf(verse) ??
                0;
            return DropdownMenuItem(
                value: index, child: Text((index + 1).toString()));
          }).toList(),
          onChanged: (value) {
            contentController.setVerse = value;
          })
    ]);
  }
}
