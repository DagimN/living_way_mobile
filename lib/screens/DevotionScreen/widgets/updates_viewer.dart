import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/dot_indicator.dart';
import 'package:provider/provider.dart';

import 'verse_of_the_day.dart';
import 'updates_viewer_expanded.dart';

class UpdatesViewer extends StatefulWidget {
  final List<ActivityContent> updates;
  const UpdatesViewer({super.key, required this.updates});

  @override
  State<UpdatesViewer> createState() => _UpdatesViewerState();
}

class _UpdatesViewerState extends State<UpdatesViewer> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage() async {
    if (!_pageController.hasClients) return;

    final nextIndex = ((_pageController.page?.round() ?? 0) + 1) %
        (widget.updates.length + 1);
    await _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );

    setState(() {
      _currentIndex = nextIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final themeController = Provider.of<ThemeController>(context);
    Brightness brightness = themeController.brightness;
    final images = contentController.images;
    final currentImage =
        CachedNetworkImageProvider(images[DateTime.now().day % images.length]);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    Radius radius = const Radius.circular(16);

    List<Widget> updates = [
      Container(
          width: screenWidth,
          height: orientation == Orientation.portrait
              ? screenHeight * .4
              : screenWidth * .3,
          decoration: BoxDecoration(
              image: DecorationImage(image: currentImage, fit: BoxFit.cover),
              borderRadius:
                  BorderRadius.only(bottomLeft: radius, bottomRight: radius)),
          child: VerseOfTheDay(isEnlarged: false, radius: radius)),
      ...widget.updates.map(
        (update) => Container(
            width: screenWidth,
            height: orientation == Orientation.portrait
                ? screenHeight * .4
                : screenWidth * .3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(update.banner?.url ?? ""),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                    bottomLeft: radius, bottomRight: radius))),
      )
    ];

    return InkWell(
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1000),
                pageBuilder: (_, __, ___) {
                  updates[_currentIndex];
                  return UpdatesViewerExpanded(
                      image: currentImage,
                      child: _currentIndex == 0
                          ? null
                          : Container(
                              width: screenWidth,
                              height: screenHeight,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(widget
                                              .updates[_currentIndex - 1]
                                              .banner
                                              ?.url ??
                                          ""),
                                      fit: BoxFit.contain),
                                  gradient: AppTheme(brightness)
                                      .backgroundGradient)));
                })),
        child: Hero(
            tag: 'updates',
            child: Material(
              type: MaterialType.transparency,
              child: Stack(
                children: [
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight * .4,
                    child: PageView(
                      controller: _pageController,
                      children: updates,
                      onPageChanged: (value) =>
                          setState(() => _currentIndex = value),
                    ),
                  ),
                  if (widget.updates.isNotEmpty)
                    Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: DotIndicator(
                          pages: updates,
                          dotRadius: 7,
                          currentIndex: _currentIndex,
                          animate: widget.updates.isNotEmpty,
                          onAnimationEnd: _changePage,
                        ))
                ],
              ),
            )));
  }
}
