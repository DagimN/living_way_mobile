import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class VerseOfTheDay extends StatelessWidget {
  final bool isEnlarged;
  final Radius radius;
  final GlobalKey? updatesViewerExpandedKey;
  const VerseOfTheDay(
      {super.key,
      required this.isEnlarged,
      this.updatesViewerExpandedKey,
      this.radius = const Radius.circular(16)});

  @override
  Widget build(BuildContext context) {
    final bibleController = Provider.of<BibleController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final verseOfTheDay = bibleController.verseOfTheDay;
    final showVerseOfTheDayControls =
        layoutController.showVerseOfTheDayControls;

    double screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius:
              BorderRadius.only(bottomLeft: radius, bottomRight: radius)),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isEnlarged) const SizedBox(),
          Column(
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
                          FittedBox(
                            child: Text(
                                Tr.safe('verseOfTheDay',
                                    fallback: "Verse of the Day"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isEnlarged ? 20 : 16)),
                          ),
                          FittedBox(
                            child: Text(verseOfTheDay.labelWithTranslation,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isEnlarged ? 28 : 24)),
                          )
                        ])),
                Container(
                    constraints: BoxConstraints(
                        maxHeight: isEnlarged
                            ? screenHeight * .7
                            : screenHeight * .15),
                    child: SingleChildScrollView(
                      primary: true,
                      child: Text(verseOfTheDay.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isEnlarged ? 16 : 14)),
                    )),
                if (!isEnlarged) const SizedBox()
              ]),
          if (isEnlarged)
            !showVerseOfTheDayControls
                ? const SizedBox(height: 50)
                : Row(children: [
                    Expanded(
                        child: IconButton(
                            onPressed: () async {
                              AnalyticsService.logEvent(
                                  'verse_of_the_day_shared');
                              SharePlus.instance.share(ShareParams(
                                text:
                                    '${verseOfTheDay.text}\n\n${verseOfTheDay.labelWithTranslation}',
                                subject: Tr.safe('verseOfTheDay',
                                    fallback: "Verse of the Day"),
                                title: verseOfTheDay.labelWithTranslation,
                              ));
                            },
                            icon:
                                const Icon(Icons.share, color: Colors.white))),
                    Expanded(
                        child: IconButton(
                            onPressed: () async {
                              if (updatesViewerExpandedKey != null) {
                                layoutController.setShowVerseOfTheDayControls =
                                    false;

                                await ImageService.captureAndSaveImage(
                                    context, updatesViewerExpandedKey!);
                                AnalyticsService.logEvent(
                                    'verse_of_the_day_downloaded');

                                layoutController.setShowVerseOfTheDayControls =
                                    true;
                              }
                            },
                            icon: const Icon(Icons.download,
                                color: Colors.white))),
                    Expanded(
                        child: IconButton(
                            onPressed: () async {
                              final todaysVerse =
                                  Passage(book: verseOfTheDay.book);
                              todaysVerse.chapter = verseOfTheDay.chapter;
                              todaysVerse.verse = verseOfTheDay.verse;

                              Navigator.pop(context);
                              layoutController.setSelectedHomePageNavigation =
                                  HomePageNavigation.bible;
                              bibleController.setPassage = todaysVerse;
                              AnalyticsService.logEvent(
                                  'verse_of_the_day_navigated');

                              Future.delayed(
                                  const Duration(seconds: 2),
                                  () => layoutController.scrollToVerse(
                                      layoutController
                                          .verseKeys[verseOfTheDay.verse]));
                            },
                            icon: const Icon(Icons.forward,
                                color: Colors.white))),
                  ])
        ],
      ),
    );
  }
}
