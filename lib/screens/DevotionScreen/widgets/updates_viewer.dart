import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:provider/provider.dart';

import 'verse_of_the_day.dart';
import 'updates_viewer_expanded.dart';

class UpdatesViewer extends StatefulWidget {
  const UpdatesViewer({super.key});

  @override
  State<UpdatesViewer> createState() => _UpdatesViewerState();
}

class _UpdatesViewerState extends State<UpdatesViewer> {
  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final images = contentController.images;
    final currentImage =
        CachedNetworkImageProvider(images[DateTime.now().day % images.length]);

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
                    UpdatesViewerExpanded(image: currentImage))),
        child: Builder(builder: (context) {
          return Hero(
              tag: 'updates',
              child: Container(
                  width: screenWidth,
                  height: orientation == Orientation.portrait
                      ? screenHeight * .4
                      : screenWidth * .3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: currentImage, fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          bottomLeft: radius, bottomRight: radius)),
                  child: VerseOfTheDay(isEnlarged: false, radius: radius)));
        }));
  }
}
