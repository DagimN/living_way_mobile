import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:living_way/screens/images_preview.dart';

class Gallery extends StatelessWidget {
  final List<String> images;
  final int minimumAllowedImagesForView;
  const Gallery(
      {super.key,
      required this.images,
      required this.minimumAllowedImagesForView});

  List<QuiltedGridTile> generatePattern() {
    int length = min(minimumAllowedImagesForView, images.length);
    switch (length) {
      case 1:
        return [const QuiltedGridTile(1, 1)];
      case 2:
        return [const QuiltedGridTile(1, 1), const QuiltedGridTile(1, 1)];
      case 3:
        return [
          const QuiltedGridTile(1, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 3)
        ];
      case 4:
        return [
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
        ];
      case 5:
        return [
          const QuiltedGridTile(1, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1)
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final borderRadius = BorderRadius.circular(10);
    final itemCount = min(minimumAllowedImagesForView, images.length);

    return SizedBox(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        child: GridView.custom(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverQuiltedGridDelegate(
                mainAxisSpacing: 0,
                crossAxisCount: itemCount <= 3
                    ? itemCount
                    : itemCount == 4
                        ? 2
                        : 3,
                pattern: generatePattern()),
            childrenDelegate: SliverChildBuilderDelegate(childCount: itemCount,
                (context, index) {
              final isLast = index == (minimumAllowedImagesForView - 1);
              final remaining = images.length - minimumAllowedImagesForView;
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ImagesPreview(images: images, initial: index)));
                },
                child: Stack(fit: StackFit.expand, children: [
                  Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                          borderRadius: borderRadius,
                          child: CachedNetworkImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Icon(
                                  Icons.broken_image,
                                  color: Colors.grey[300]),
                              memCacheHeight:
                                  orientation == Orientation.portrait
                                      ? (screenHeight * .4).toInt()
                                      : (screenWidth * .4).toInt(),
                              maxHeightDiskCache:
                                  orientation == Orientation.portrait
                                      ? (screenHeight * .4).toInt()
                                      : (screenWidth * .4).toInt()))),
                  if (isLast && remaining > 0)
                    Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: borderRadius),
                        child: Center(
                            child: Text('+$remaining',
                                style: const TextStyle(color: Colors.white))))
                ]),
              );
            })));
  }
}
