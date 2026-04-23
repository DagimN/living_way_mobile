import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/models/activity.dart';
import 'package:living_way/screens/ActivityScreen/images_preview.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Event extends StatelessWidget {
  final Activity content;
  const Event({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    ImageProvider? imageProvider;

    return SizedBox(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        child: Stack(children: [
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImagesPreview(imageProvider: imageProvider))),
              child: Container(
                  margin: const EdgeInsets.all(5),
                  //TODO: Refactor cached image into its own widget
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                          //TODO: Add a placeholder fetching animation if the image is not ready yet
                          imageUrl: content.banner?.url ?? "",
                          imageBuilder: (context, provider) {
                            imageProvider = provider;
                            return Image(
                                image: provider,
                                width: screenWidth,
                                fit: BoxFit.cover,
                                errorBuilder: (context, url, error) => Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[300]));
                          },
                          errorWidget: (context, url, error) => Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.grey[300])),
                          height: orientation == Orientation.portrait
                              ? screenHeight * .35
                              : screenWidth * .35,
                          memCacheHeight: orientation == Orientation.portrait
                              ? (screenHeight * .6).toInt()
                              : (screenWidth * .6).toInt(),
                          maxHeightDiskCache:
                              orientation == Orientation.portrait
                                  ? (screenHeight * .6).toInt()
                                  : (screenWidth * .6).toInt())))),
          if (content.locationUrl != null)
            Positioned(
                bottom: 0,
                right: -15,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor:
                            AppTheme(themeController.brightness).primaryColor),
                    onPressed: () {
                      launchUrl(Uri.parse(content.locationUrl ?? ""),
                          mode: LaunchMode.externalApplication);
                    },
                    child: const Icon(Icons.location_pin, color: Colors.white)))
        ]));
  }
}
