import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class BibleScreen extends StatelessWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    return SafeArea(
        child: contentController.bible.isNotEmpty
            ? Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                                value: contentController.book ??
                                    contentController.bible[0],
                                items: contentController.bible
                                    .map((book) => DropdownMenuItem(
                                        value: book, child: Text(book.name)))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    contentController.setBook = value;
                                  }
                                }),
                            Row(children: [
                              PopupMenuButton<String>(
                                  initialValue: contentController.translation ??
                                      contentController.translations.first,
                                  child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                          child: Text(contentController.translation ?? contentController.translations.first,
                                              style: const TextStyle(
                                                  color: lightPrimaryColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10)))),
                                  itemBuilder: (context) => contentController
                                      .translations
                                      .map<PopupMenuItem<String>>(
                                          (translation) => PopupMenuItem(
                                              onTap: () => contentController
                                                  .setTranslation = translation,
                                              child: Text(translation, style: const TextStyle(color: lightPrimaryColor))))
                                      .toList()),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: lightPrimaryColor))
                            ])
                          ])
                    ]))
            : const Center(
                child: CircularProgressIndicator(color: lightPrimaryColor)));
  }
}
