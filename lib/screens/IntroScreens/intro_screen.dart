import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'pages/page1.dart';
import 'pages/page2.dart';
import 'pages/page3.dart';
import 'pages/page4.dart';
import 'pages/page5.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final localizationController = Provider.of<LocalizationController>(context);
    int index = layoutController.initialIntroductionPageIndex;
    AppLocale appLocale = localizationController.appLocale;

    //FIXME: On this flow the only permitted device orientation should be portrait
    List<Widget> pages = const [Page1(), Page2(), Page3(), Page4(), Page5()];

    return Scaffold(
        appBar: AppBar(
            leading: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  localizationController.toggleAppLocale(context);
                },
                child: Text(appLocale.name.toUpperCase())),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  child: const Text('Skip'))
            ]),
        body: pages[index],
        bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  index > 0
                      ? TextButton(
                          onPressed: () {
                            layoutController.setIntroPageIndex = index - 1;
                          },
                          child: const Text('Back'))
                      : const SizedBox(width: 65),
                  Expanded(
                      child: DotIndicator(
                          currentIndex: index, dotRadius: 7, pages: pages)),
                  (index < pages.length - 1)
                      ? TextButton(
                          onPressed: () {
                            layoutController.setIntroPageIndex = index + 1;
                          },
                          child: const Text('Next'))
                      : TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: const Text('Done'))
                ])));
  }
}
