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

    if (content.isFetching) {
      return Shimmer.fromColors(
          direction: ShimmerDirection.rtl,
          baseColor: AppTheme(themeController.brightness).backgroundColor,
          highlightColor:
              AppTheme(themeController.brightness).primaryColor.withAlpha(120),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                      AppTheme(themeController.brightness).backgroundColor)));
    }

    return Container(
        decoration: BoxDecoration(
            image: content.thumbnailData == null
                ? null
                : DecorationImage(
                    image: Image.memory(content.thumbnailData!).image,
                    fit: BoxFit.cover)));
  }
}
