import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:provider/provider.dart';

import 'verse_of_the_day.dart';

class UpdatesViewerExpanded extends StatefulWidget {
  final CachedNetworkImageProvider image;
  final Widget? child;
  const UpdatesViewerExpanded({super.key, required this.image, this.child});

  @override
  State<UpdatesViewerExpanded> createState() => _UpdatesViewerExpandedState();
}

class _UpdatesViewerExpandedState extends State<UpdatesViewerExpanded> {
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final layoutController = Provider.of<LayoutController>(context);

    Brightness brightness = themeController.brightness;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          actions: [
            if (!layoutController.showVerseOfTheDayControls)
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme(themeController.brightness).primaryColor),
              )
          ],
        ),
        backgroundColor: AppTheme(brightness).backgroundColor,
        body: RepaintBoundary(
          key: globalKey,
          child: Hero(
              tag: "updates",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  type: MaterialType.transparency,
                  child: widget.child ??
                      Container(
                          width: screenWidth,
                          height: screenHeight,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: widget.image, fit: BoxFit.cover),
                              gradient:
                                  AppTheme(brightness).backgroundGradient),
                          child: VerseOfTheDay(
                              updatesViewerExpandedKey: globalKey,
                              isEnlarged: true)),
                ),
              )),
        ));
  }
}
