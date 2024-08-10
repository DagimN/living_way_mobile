import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Gallery extends StatelessWidget {
  final List<String> images;
  const Gallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final borderRadius = BorderRadius.circular(10);

    return SizedBox(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        child: GridView.custom(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverQuiltedGridDelegate(
                mainAxisSpacing: 0,
                crossAxisCount: 3,
                pattern: [
                  const QuiltedGridTile(1, 2),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1)
                ]),
            childrenDelegate: SliverChildBuilderDelegate(
                childCount: min(5, images.length), (context, index) {
              final isLast = index == 4;
              final remaining = images.length - 5;
              return Stack(fit: StackFit.expand, children: [
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
                            memCacheHeight: (screenHeight * .3).toInt(),
                            maxHeightDiskCache: (screenHeight * .3).toInt()))),
                if (isLast && remaining > 0)
                  Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: borderRadius),
                      child: Center(
                          child: Text('+$remaining',
                              style: const TextStyle(color: Colors.white))))
              ]);
            })));
  }
}
