import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/bible_navigator.dart';
import 'widgets/chapter_page.dart';
import 'widgets/translation_popup_button.dart';

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
    final bibleController = Provider.of<BibleController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final selectedPassage = bibleController.passage;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: bibleController.bible.isNotEmpty
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                BaseAppBar(
                    title: TextButton(
                        onPressed: () {
                          isBibleNavigatorVisible
                              ? animationController.reverse()
                              : animationController.forward();

                          setState(() {
                            isBibleNavigatorVisible = !isBibleNavigatorVisible;
                          });
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          orientation == Orientation.portrait
                                              ? screenWidth * .35
                                              : screenWidth * .25),
                                  child: Text(selectedPassage.label,
                                      style: TextStyle(
                                          color: AppTheme(
                                                  themeController.brightness)
                                              .primaryColor,
                                          fontSize: 20))),
                              Icon(
                                  isBibleNavigatorVisible
                                      ? Icons.arrow_drop_up_rounded
                                      : Icons.arrow_drop_down_rounded,
                                  color: AppTheme(themeController.brightness)
                                      .primaryColor)
                            ])),
                    actions: const [TranslationPopupButton()]),
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
                          color: AppTheme(themeController.brightness)
                              .primaryPanelColor,
                          padding: const EdgeInsets.all(10),
                          child: const BibleNavigator());
                    }),
                ChapterPage(verses: (selectedPassage.verses))
              ])
            : Center(
                child: CircularProgressIndicator(
                    color: AppTheme(themeController.brightness).primaryColor)));
  }
}
