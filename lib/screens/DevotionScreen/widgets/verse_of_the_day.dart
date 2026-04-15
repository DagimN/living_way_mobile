import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:provider/provider.dart';

class VerseOfTheDay extends StatelessWidget {
  final bool isEnlarged;
  final Radius radius;
  const VerseOfTheDay(
      {super.key,
      required this.isEnlarged,
      this.radius = const Radius.circular(16)});

  @override
  Widget build(BuildContext context) {
    final bibleController = Provider.of<BibleController>(context);

    return Container(
        decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius:
                BorderRadius.only(bottomLeft: radius, bottomRight: radius)),
        padding: const EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: isEnlarged
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 36),
                        Text('Verse of the day',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: isEnlarged ? 20 : 16)),
                        Text('James 1:1 NKJV',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: isEnlarged ? 28 : 24))
                      ])),
              Align(
                  alignment: Alignment.center,
                  child: Text(bibleController.bible[58].chapters[0][0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isEnlarged ? 16 : 14))),
              if (!isEnlarged) const SizedBox()
            ]));
  }
}
