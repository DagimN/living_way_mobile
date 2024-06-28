import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/utils/shorten_number.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    const Color inactiveIconColor = Color(0xFFBBB593);

    return Container(
        width: orientation == Orientation.portrait
            ? screenWidth * .5
            : screenHeight * .5,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: lightTopicGradient),
        child: Stack(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                width: orientation == Orientation.portrait
                    ? screenWidth * .3
                    : screenHeight * .3,
                margin: const EdgeInsets.only(top: 20, left: 16),
                child: Text(topic.title, style: const TextStyle(fontSize: 14))),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 2, color: Color(0xFFFFFDF0)))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        const Icon(Icons.remove_red_eye_outlined,
                            color: inactiveIconColor),
                        Text(shortenNumber(topic.viewCount),
                            style: const TextStyle(
                                color: inactiveIconColor, fontSize: 10))
                      ]),
                      IconButton(
                          icon: Icon(
                              topic.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: topic.isFavorite
                                  ? Colors.red
                                  : inactiveIconColor),
                          onPressed: () {})
                    ]))
          ]),
          if (topic.type != TopicType.discussion)
            Positioned(
                bottom: 0,
                child: Container(
                    height: orientation == Orientation.portrait
                        ? screenHeight * .03
                        : screenWidth * .03,
                    width: orientation == Orientation.portrait
                        ? screenWidth * .095
                        : screenHeight * .095,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: lightPrimaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    child: SvgPicture.asset(
                        topic.type == TopicType.audio
                            ? AppIcons.audio
                            : AppIcons.video,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn))))
        ]));
  }
}
