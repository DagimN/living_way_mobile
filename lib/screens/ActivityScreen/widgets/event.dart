import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/models/activity/index.dart';
import 'package:living_way/screens/ActivityScreen/images_preview.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
          InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImagesPreview(imageProvider: imageProvider))),
              child: Container(
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
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
                          placeholder: (context, url) => Shimmer.fromColors(
                              direction: ShimmerDirection.rtl,
                              baseColor: AppTheme(themeController.brightness)
                                  .backgroundColor,
                              highlightColor: AppTheme(themeController.brightness)
                                  .primaryColor
                                  .withAlpha(120),
                              child: Container(
                                  height: orientation == Orientation.portrait
                                      ? screenHeight * .35
                                      : screenWidth * .35,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppTheme(themeController.brightness)
                                          .backgroundColor))),
                          height: orientation == Orientation.portrait
                              ? screenHeight * .35
                              : screenWidth * .35,
                          memCacheHeight: orientation == Orientation.portrait
                              ? (screenHeight * .6).toInt()
                              : (screenWidth * .6).toInt(),
                          maxHeightDiskCache: orientation == Orientation.portrait ? (screenHeight * .6).toInt() : (screenWidth * .6).toInt())))),
          if (content.locationUrl != null)
            Positioned(
                bottom: 0,
                right: -10,
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
