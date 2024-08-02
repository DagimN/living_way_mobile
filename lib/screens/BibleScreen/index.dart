import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/screens/BibleScreen/widgets/bible_navigator.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen>
    with TickerProviderStateMixin {
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

    return SafeArea(
        child: contentController.bible.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  child: Row(children: [
                                    Text(
                                        '${selectedBook?.name} ${selectedChapter + 1}',
                                        style: const TextStyle(
                                            color: lightPrimaryColor,
                                            fontSize: 24)),
                                    Icon(
                                        isBibleNavigatorVisible
                                            ? Icons.arrow_drop_up_rounded
                                            : Icons.arrow_drop_down_rounded,
                                        color: lightPrimaryColor)
                                  ])),
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
                                    itemBuilder: (context) => contentController.translations
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
                            ])),
                    AnimatedBuilder(
                        animation: CurvedAnimation(
                            parent: animationController,
                            curve: Curves.easeInOutCirc),
                        builder: (context, child) {
                          return Container(
                              width: screenWidth,
                              height: (screenHeight * .075) *
                                  animationController.value,
                              color: lightPrimaryPanelColor,
                              padding: const EdgeInsets.all(10),
                              child: const BibleNavigator());
                        }),
                    Container(
                        width: screenWidth,
                        height: screenHeight * .7,
                        margin: const EdgeInsets.all(20),
                        child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 50),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemCount: selectedBook
                                    ?.chapters[selectedChapter].length ??
                                0,
                            itemBuilder: (context, index) {
                              final verse = selectedBook
                                  ?.chapters[selectedChapter][index];
                              return RichText(
                                  text: TextSpan(children: [
                                WidgetSpan(
                                    child: Text('${index + 1} ',
                                        style: const TextStyle(
                                            color: lightPrimaryColor,
                                            fontSize: 24))),
                                TextSpan(
                                    text: verse,
                                    style: const TextStyle(color: Colors.black))
                              ]));
                            }))
                  ]))
            : const Center(
                child: CircularProgressIndicator(color: lightPrimaryColor)));
  }
}
