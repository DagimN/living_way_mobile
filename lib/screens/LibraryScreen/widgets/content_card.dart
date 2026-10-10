import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ContentCard extends StatelessWidget {
  final Content content;
  final Function()? onTap;
  const ContentCard({super.key, required this.content, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    return ListenableBuilder(
        listenable: content,
        builder: (context, child) {
          DecorationImage? image;

          if (content.thumbnailData != null) {
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
            return AspectRatio(
              aspectRatio: (content.width ?? 1) / (content.height ?? 1),
              child: Shimmer.fromColors(
                  direction: ShimmerDirection.rtl,
                  baseColor: theme.backgroundColor,
                  highlightColor: theme.primaryColor.withAlpha(120),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme.backgroundColor))),
            );
          }

          return AspectRatio(
            aspectRatio: (content.width ?? 1) / (content.height ?? 1),
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Stack(
                children: [
                  Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme.primaryPanelColor,
                          image: image),
                      child: image == null
                          ? Column(
                              spacing: 4,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.book, color: theme.primaryColor),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    content.title,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          : null),
                  if (content.file == null)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: content.isDownloading
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                value: content.downloadProgress,
                                color: theme.primaryColor,
                                backgroundColor: theme.backgroundColor,
                                strokeCap: StrokeCap.round,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.download,
                                  color: Colors.white, size: 24)),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
