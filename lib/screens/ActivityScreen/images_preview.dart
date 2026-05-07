import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ImagesPreview extends StatelessWidget {
  final List<ImageProvider> images;
  final int initial;
  final ImageProvider? imageProvider;
  const ImagesPreview(
      {super.key,
      this.initial = 0,
      this.imageProvider,
      this.images = const []});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white),
        body: imageProvider != null
            ? PhotoView(
                imageProvider: imageProvider,
                minScale: PhotoViewComputedScale.contained)
            : PhotoViewGallery.builder(
                itemCount: images.length,
                pageController: PageController(initialPage: initial),
                loadingBuilder: (context, event) => Container(
                      color: Colors.black,
                      width: screenWidth,
                      height: screenHeight,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                          color: AppTheme(themeController.brightness)
                              .primaryColor),
                    ),
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                      imageProvider: images[index],
                      minScale: PhotoViewComputedScale.contained);
                }));
  }
}
