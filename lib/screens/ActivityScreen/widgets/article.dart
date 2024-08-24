import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/themes/light_theme.dart';

class Article extends StatelessWidget {
  final ActivityContent content;
  const Article({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    const radius = Radius.circular(20);

    return Container(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        height: orientation == Orientation.portrait
            ? screenHeight * .15
            : screenWidth * .15,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(radius),
            border: Border.all(
                color: lightPrimaryColor.withOpacity(0.7), width: 0.3)),
        child: TextButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => SizedBox(
                      height: screenHeight * .9,
                      child: SingleChildScrollView(
                          child: Column(children: [
                        SizedBox(
                            width: screenWidth,
                            height: screenHeight * .32,
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(radius),
                                child: CachedNetworkImage(
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
                                            : (screenWidth * .4).toInt(),
                                    imageUrl: content.banner?.url ?? ""))),
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(content.title ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                        ...content.content.map((value) {
                          bool isImage = value.contains("https://");

                          return isImage
                              ? CachedNetworkImage(
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
                                          : (screenWidth * .4).toInt(),
                                  imageUrl: value)
                              : Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Text(value,
                                      style: const TextStyle(fontSize: 12)));
                        })
                      ]))));
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(radius))),
            //TODO: Implement dynamic banner positioning
            child: Row(children: [
              SizedBox(
                  width: screenWidth * .3,
                  height: 200,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: radius, bottomLeft: radius),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) =>
                              Icon(Icons.broken_image, color: Colors.grey[300]),
                          fit: BoxFit.fill,
                          memCacheHeight: orientation == Orientation.portrait
                              ? (screenHeight * .4).toInt()
                              : (screenWidth * .4).toInt(),
                          maxHeightDiskCache:
                              orientation == Orientation.portrait
                                  ? (screenHeight * .4).toInt()
                                  : (screenWidth * .4).toInt(),
                          imageUrl: content.banner?.url ?? ""))),
              Container(
                  width: screenWidth * .4,
                  margin: const EdgeInsets.all(5),
                  child: Text(content.body ?? "",
                      overflow: TextOverflow.ellipsis, maxLines: 5))
            ])));
  }
}
