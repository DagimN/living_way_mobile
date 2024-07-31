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
                          })
                    ]),
              )
            : const Center(
                child: CircularProgressIndicator(color: lightPrimaryColor)));
  }
}
