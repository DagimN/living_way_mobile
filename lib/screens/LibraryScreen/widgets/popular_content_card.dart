import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PopularContentCard extends StatelessWidget {
  final Content content;
  const PopularContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return ListenableBuilder(
        listenable: content,
        builder: (context, child) {
          DecorationImage? image;

          if (content.thumbnail != null) {
            image = DecorationImage(
              image: CachedNetworkImageProvider(content.thumbnail!),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                image = null;
                content.thumbnail = null;
                content.notify();
              },
            );
          } else if (content.thumbnailData != null) {
            image = DecorationImage(
                image: Image.memory(content.thumbnailData!,
                        width: double.infinity, height: double.infinity)
                    .image,
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  image = null;
                  content.thumbnailData = null;
                  content.notify();
                });
          }

          if (content.isFetching) {
            return Shimmer.fromColors(
                direction: ShimmerDirection.rtl,
                baseColor: AppTheme(themeController.brightness).backgroundColor,
                highlightColor: AppTheme(themeController.brightness)
                    .primaryColor
                    .withAlpha(120),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppTheme(themeController.brightness)
                            .backgroundColor)));
          }

          return Stack(
            children: [
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppTheme(themeController.brightness)
                          .primaryPanelColor,
                      image: image),
                  child: image == null
                      ? Icon(Icons.book,
                          color:
                              AppTheme(themeController.brightness).primaryColor)
                      : null),
              if (content.filePath == null)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: content.isDownloading
                      ? SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            value: content.downloadProgress,
                            color: AppTheme(themeController.brightness)
                                .primaryColor,
                            backgroundColor:
                                AppTheme(themeController.brightness)
                                    .backgroundColor,
                            strokeCap: StrokeCap.round,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppTheme(themeController.brightness)
                                .primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.download,
                              color: Colors.white, size: 24)),
                ),
            ],
          );
        });
  }
}
