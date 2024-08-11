import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Event extends StatelessWidget {
  final ActivityContent content;
  const Event({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        child: Stack(children: [
          Container(
              margin: const EdgeInsets.all(5),
              //TODO: Refactor cached image into its own widget
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                      imageUrl: content.banner?.url ?? "",
                      width: screenWidth,
                      height: orientation == Orientation.portrait
                          ? screenHeight * .35
                          : screenWidth * .35,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image, color: Colors.grey[300]),
                      memCacheHeight: orientation == Orientation.portrait
                          ? (screenHeight * .6).toInt()
                          : (screenWidth * .6).toInt(),
                      maxHeightDiskCache: orientation == Orientation.portrait
                          ? (screenHeight * .6).toInt()
                          : (screenWidth * .6).toInt()))),
          if (content.locationUrl != null)
            Positioned(
                bottom: 0,
                right: -15,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: lightPrimaryColor),
                    onPressed: () {
                      launchUrl(Uri.parse(content.locationUrl ?? ""),
                          mode: LaunchMode.externalApplication);
                    },
                    child: const Icon(Icons.location_pin, color: Colors.white)))
        ]));
  }
}
