import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/bible_navigator.dart';
import 'widgets/chapter_page.dart';
import 'widgets/font_options_bottomsheet_button.dart';
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
    final theme = AppTheme(themeController.brightness);
    final selectedPassage = bibleController.passage;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    void toggleBibleNavigator() {
      isBibleNavigatorVisible
          ? animationController.reverse()
          : animationController.forward();

      setState(() {
        isBibleNavigatorVisible = !isBibleNavigatorVisible;
      });
    }

    return bibleController.bible.isNotEmpty
        ? SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: screenHeight * .05),
              BaseAppBar(
                  title: TextButton(
                      onPressed: toggleBibleNavigator,
                      child: Row(children: [
                        Container(
                            constraints: BoxConstraints(
                                maxWidth: orientation == Orientation.portrait
                                    ? screenWidth * .25
                                    : screenWidth * .15),
                            child: Text(selectedPassage.label.split(":")[0],
                                style: TextStyle(
                                    color: AppTheme(themeController.brightness)
                                        .primaryColor,
                                    fontSize: 20))),
                        Icon(
                            isBibleNavigatorVisible
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded,
                            color: AppTheme(themeController.brightness)
                                .primaryColor)
                      ])),
                  actions: const [
                    TranslationPopupButton(),
                    FontOptionsBottomsheetButton(),
                  ]),
              AnimatedBuilder(
                  animation: CurvedAnimation(
                      parent: animationController, curve: Curves.easeInOutCirc),
                  builder: (context, child) {
                    return Container(
                        width: screenWidth,
                        height: (orientation == Orientation.portrait
                                ? screenHeight * .075
                                : screenWidth * .075) *
                            animationController.value,
                        color: theme.backgroundColor,
                        padding: const EdgeInsets.all(10),
                        child: BibleNavigator(
                          toggleBibleNavigator: toggleBibleNavigator,
                        ));
                  }),
              ChapterPage(verses: (selectedPassage.verses))
            ]),
          )
        : Center(child: CircularProgressIndicator(color: theme.primaryColor));
  }
}
