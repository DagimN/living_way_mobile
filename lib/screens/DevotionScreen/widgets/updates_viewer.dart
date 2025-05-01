import 'package:flutter/material.dart';
import 'package:living_way/constants/urls.dart';

import 'verse_of_the_day.dart';
import 'updates_viewer_expanded.dart';

class UpdatesViewer extends StatefulWidget {
  const UpdatesViewer({super.key});

  @override
  State<UpdatesViewer> createState() => _UpdatesViewerState();
}

class _UpdatesViewerState extends State<UpdatesViewer> {
  //FIXME: Optimize Image Loading
  static const image = NetworkImage(Urls.imageApiUrl);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    Radius radius = const Radius.circular(16);

    return InkWell(
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1000),
                pageBuilder: (_, __, ___) =>
                    const UpdatesViewerExpanded(image: image))),
        child: Builder(builder: (context) {
          return Hero(
              tag: 'updates',
              child: Container(
                  width: screenWidth,
                  height: orientation == Orientation.portrait
                      ? screenHeight * .4
                      : screenWidth * .3,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: image, fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          bottomLeft: radius, bottomRight: radius)),
                  child: VerseOfTheDay(isEnlarged: false, radius: radius)));
        }));
  }
}
