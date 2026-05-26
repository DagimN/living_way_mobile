import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    BorderRadius borderRadius = BorderRadius.circular(20);

    return Container(
        width: orientation == Orientation.portrait
            ? screenWidth * .5
            : screenHeight * .5,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            image: topic.backgroundImageUrl != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        topic.backgroundImageUrl ?? ""))
                : null,
            borderRadius: borderRadius,
            gradient: AppTheme(themeController.brightness).topicGradient),
        child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: borderRadius)),
            onPressed: () {
              if (topic.type == TopicType.video) {
                launchUrl(Uri.parse(
                    "https://www.youtube.com/watch?v=${topic.playlist.first.source}"));
                return;
              }

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                switch (topic.type) {
                  case TopicType.audio:
                    return MediaScreen(topic: topic);
                  default:
                    return TopicScreen(topic: topic);
                }
              }));
            },
            child: Stack(fit: StackFit.expand, children: [
              Container(
                  width: orientation == Orientation.portrait
                      ? screenWidth * .5
                      : screenHeight * .5,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(76),
                    borderRadius: borderRadius,
                  )),
              Positioned(
                bottom: 0,
                child: Container(
                    width: orientation == Orientation.portrait
                        ? screenWidth * .45
                        : screenHeight * .45,
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(topic.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: topic.backgroundImageUrl != null
                                ? AppTheme(themeController.brightness)
                                    .inactiveIconColor
                                : null))),
              ),
              if (topic.type != TopicType.discussion)
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                        height: orientation == Orientation.portrait
                            ? screenHeight * .03
                            : screenWidth * .03,
                        width: orientation == Orientation.portrait
                            ? screenWidth * .095
                            : screenHeight * .095,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: AppTheme(themeController.brightness)
                                .secondaryColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        child: SvgPicture.asset(
                            topic.type == TopicType.audio
                                ? AppIcons.audio
                                : AppIcons.video,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn))))
            ])));
  }
}
