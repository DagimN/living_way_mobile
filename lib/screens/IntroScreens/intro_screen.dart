import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'pages/page1.dart';
import 'pages/page2.dart';
import 'pages/page3.dart';
import 'pages/page4.dart';
import 'pages/page5.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  double _dragOffset = 0;
  double _dragStartX = 0;
  static const double _swipeThreshold = 80;

  void _changePage(int newIndex, {required int currentIndex}) {
    final layoutController =
        Provider.of<LayoutController>(context, listen: false);

    if (newIndex < 0 || newIndex >= 5) {
      return;
    }

    if (newIndex > currentIndex) {
      AnalyticsService.logEvent('intro_next',
          parameters: {'from_page': currentIndex.toString()});
    } else if (newIndex < currentIndex) {
      AnalyticsService.logEvent('intro_back',
          parameters: {'from_page': currentIndex.toString()});
    }

    layoutController.setIntroPageIndex = newIndex;
    setState(() {
      _dragOffset = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final localizationController = Provider.of<LocalizationController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    int index = layoutController.initialIntroductionPageIndex;
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> pages = const [Page1(), Page2(), Page3(), Page4(), Page5()];

    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
            backgroundColor: theme.backgroundColor,
            leading: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () async {
                  AnalyticsService.logEvent('intro_locale_toggled');
                  localizationController.toggleAppLocale(context);
                },
                child: Text(AppLocale.shortLabel(context.locale))),
            actions: [
              TextButton(
                  onPressed: () async {
                    AnalyticsService.logEvent('intro_skipped');
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(Tr.t('common.skip')))
            ]),
        body: GestureDetector(
          onHorizontalDragStart: (details) {
            _dragStartX = details.globalPosition
                .dx; //FIXME: On drag is not being registered on gaps
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragOffset = details.globalPosition.dx - _dragStartX;
            });
          },
          onHorizontalDragEnd: (details) {
            final dragDistance = details.primaryVelocity ?? 0;
            final dragOffset = _dragOffset;

            if (dragOffset.abs() > _swipeThreshold ||
                dragDistance.abs() > 800) {
              if (dragOffset < 0 || dragDistance < 0) {
                if (index < pages.length - 1) {
                  _changePage(index + 1, currentIndex: index);
                } else {
                  setState(() {
                    _dragOffset = 0;
                  });
                }
              } else if (dragOffset > 0 || dragDistance > 0) {
                if (index > 0) {
                  _changePage(index - 1, currentIndex: index);
                } else {
                  setState(() {
                    _dragOffset = 0;
                  });
                }
              }
            } else {
              setState(() {
                _dragOffset = 0;
              });
            }
          },
          child: Stack(
            children: [
              if (index > 0 && _dragOffset != 0)
                Transform.translate(
                  offset: Offset(-screenWidth * 0.95 + _dragOffset * 0.35, 0),
                  child: Opacity(
                    opacity: 0.35 +
                        (1 - _dragOffset.abs() / screenWidth).clamp(0.0, 0.35),
                    child: Transform.scale(
                      scale: 0.9,
                      child: pages[index - 1],
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: Transform.scale(
                  scale: 1 -
                      (_dragOffset.abs() / screenWidth * 0.04).clamp(0.0, 0.04),
                  child: pages[index],
                ),
              ),
              if (index < pages.length - 1 && _dragOffset != 0)
                Transform.translate(
                  offset: Offset(screenWidth * 0.95 + _dragOffset * 0.35, 0),
                  child: Opacity(
                    opacity: 0.35 +
                        (1 - _dragOffset.abs() / screenWidth).clamp(0.0, 0.35),
                    child: Transform.scale(
                      scale: 0.9,
                      child: pages[index + 1],
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomSheet: Container(
            color: theme.backgroundColor,
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  index > 0
                      ? TextButton(
                          onPressed: () async {
                            _changePage(index - 1, currentIndex: index);
                          },
                          child: Text(Tr.t('common.back')))
                      : IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back,
                              color: theme.primaryColor)),
                  Expanded(
                      child: DotIndicator(
                          currentIndex: index, dotRadius: 7, pages: pages)),
                  (index < pages.length - 1)
                      ? TextButton(
                          onPressed: () async {
                            _changePage(index + 1, currentIndex: index);
                          },
                          child: Text(Tr.t('common.next')))
                      : TextButton(
                          onPressed: () async {
                            AnalyticsService.logEvent('intro_completed');
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/signup',
                                (route) => route.settings.name == '/login');
                          },
                          child: Text(Tr.t('common.done')))
                ])));
  }
}
