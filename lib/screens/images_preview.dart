import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesPreview extends StatelessWidget {
  final List<String> images;
  final int initial;
  final ImageProvider? imageProvider;
  const ImagesPreview(
      {super.key,
      this.initial = 0,
      this.imageProvider,
      this.images = const []});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        body: Stack(children: [
      imageProvider != null
          ? PhotoView(
              imageProvider: imageProvider,
              minScale: PhotoViewComputedScale.contained)
          : PhotoViewGallery.builder(
              itemCount: images.length,
              pageController: PageController(initialPage: initial),
              builder: (context, index) {
                final imageProvider = CachedNetworkImageProvider(images[index],
                    maxHeight: orientation == Orientation.portrait
                        ? screenHeight.toInt()
                        : screenWidth.toInt());
                return PhotoViewGalleryPageOptions(
                    imageProvider: imageProvider,
                    minScale: PhotoViewComputedScale.contained);
              }),
      Positioned(
          top: 24,
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 24)))
    ]));
  }
}
