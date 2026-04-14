import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/screens/BibleScreen/widgets/bible_navigator.dart';
import 'package:living_way/screens/BibleScreen/widgets/chapter_page.dart';
import 'package:living_way/screens/BibleScreen/widgets/translation_popup_button.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:living_way/widgets/base_app_bar.dart';
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
    final themeController = Provider.of<ThemeController>(context);
    final selectedBook =
        contentController.book ?? contentController.bible.firstOrNull;
    final selectedChapter = contentController.chapter ?? 0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: contentController.bible.isNotEmpty
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
                                  child: Text(
                                      '${selectedBook?.name} ${selectedChapter + 1}',
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
                ChapterPage(
                    verses: (selectedBook?.chapters[selectedChapter] ?? []))
              ])
            : Center(
                child: CircularProgressIndicator(
                    color: AppTheme(themeController.brightness).primaryColor)));
  }
}
