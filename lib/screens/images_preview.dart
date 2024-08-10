import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesPreview extends StatelessWidget {
  final List<String> images;
  final int initial;
  const ImagesPreview({super.key, this.initial = 0, required this.images});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent, foregroundColor: Colors.white),
      body: PhotoViewGallery.builder(
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
    );
  }
}
