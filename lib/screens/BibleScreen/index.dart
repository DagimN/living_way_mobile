import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/screens/BibleScreen/widgets/bible_navigator.dart';
import 'package:living_way/screens/BibleScreen/widgets/chapter_page.dart';
import 'package:living_way/screens/BibleScreen/widgets/translation_popup_button.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen>
    with TickerProviderStateMixin {
  final scrollController = ScrollController();
  late AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  bool isBibleNavigatorVisible = false;

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final selectedBook =
        contentController.book ?? contentController.bible.firstOrNull;
    final selectedChapter = contentController.chapter ?? 0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: contentController.bible.isNotEmpty
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                isBibleNavigatorVisible
                                    ? animationController.reverse()
                                    : animationController.forward();

                                setState(() {
                                  isBibleNavigatorVisible =
                                      !isBibleNavigatorVisible;
                                });
                              },
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        constraints: BoxConstraints(
                                            maxWidth: orientation ==
                                                    Orientation.portrait
                                                ? screenWidth * .5
                                                : screenWidth * .25),
                                        child: Text(
                                            '${selectedBook?.name} ${selectedChapter + 1}',
                                            style: const TextStyle(
                                                color: lightPrimaryColor,
                                                fontSize: 20))),
                                    Icon(
                                        isBibleNavigatorVisible
                                            ? Icons.arrow_drop_up_rounded
                                            : Icons.arrow_drop_down_rounded,
                                        color: lightPrimaryColor)
                                  ])),
                          Row(children: [
                            const TranslationPopupButton(),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: lightPrimaryColor))
                          ])
                        ])),
                AnimatedBuilder(
                    animation: CurvedAnimation(
                        parent: animationController,
                        curve: Curves.easeInOutCirc),
                    builder: (context, child) {
                      return Container(
                          width: screenWidth,
                          height: (orientation == Orientation.portrait
                                  ? screenHeight * .075
                                  : screenWidth * .075) *
                              animationController.value,
                          color: lightPrimaryPanelColor,
                          padding: const EdgeInsets.all(10),
                          child: const BibleNavigator());
                    }),
                    ChapterPage(verses: (selectedBook?.chapters[selectedChapter] ?? []))
              ])
            : const Center(
                child: CircularProgressIndicator(color: lightPrimaryColor)));
  }
}
