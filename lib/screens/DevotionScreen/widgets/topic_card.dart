import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/MediaScreen/index.dart';
import 'package:living_way/screens/TopicScreen/index.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:living_way/utils/shorten_number.dart';
import 'package:provider/provider.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final userProfile = Provider.of<ProfileController>(context).userProfile;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    BorderRadius borderRadius = BorderRadius.circular(20);
    const Color inactiveIconColor = Color(0xFFBBB593);

    return Container(
        width: orientation == Orientation.portrait
            ? screenWidth * .5
            : screenHeight * .5,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            image: topic.backgroundImageUrl != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        AppTheme(themeController.brightness).inactiveColor,
                        BlendMode.saturation),
                    opacity: 0.3,
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
              if (userProfile != null &&
                  !topic.viewers.contains(userProfile.id)) {
                topic.viewers.add(userProfile.id);
                contentController.updateTopic(topic);
              }

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                switch (topic.type) {
                  case TopicType.audio:
                  case TopicType.video:
                    return MediaScreen(topic: topic);
                  default:
                    return TopicScreen(topic: topic);
                }
              }));
            },
            child: Stack(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    width: orientation == Orientation.portrait
                        ? screenWidth * .3
                        : screenHeight * .3,
                    margin: const EdgeInsets.only(top: 20, left: 16),
                    child: Text(topic.title,
                        style: TextStyle(
                            fontSize: 14,
                            color: topic.backgroundImageUrl != null
                                ? inactiveIconColor
                                : null))),
                Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                width: 2, color: Color(0xFFFFFDF0)))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const Icon(Icons.remove_red_eye_outlined,
                                color: inactiveIconColor),
                            Text(shortenNumber(topic.viewers.length),
                                style: const TextStyle(
                                    color: inactiveIconColor, fontSize: 10))
                          ]),
                          const SizedBox(height: 5),
                          Column(children: [
                            SizedBox(
                                height: 24,
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        padding: EdgeInsets.zero),
                                    icon: Icon(
                                        topic.likers.contains(userProfile?.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: topic.likers
                                                .contains(userProfile?.id)
                                            ? Colors.red
                                            : inactiveIconColor),
                                    onPressed: () async {
                                      if (userProfile != null) {
                                        if (!topic.likers
                                            .contains(userProfile.id)) {
                                          topic.likers.add(userProfile.id);
                                        } else {
                                          topic.likers.remove(userProfile.id);
                                        }

                                        await contentController
                                            .updateTopic(topic);
                                      }
                                    })),
                            if (topic.likers.isNotEmpty)
                              Text(shortenNumber(topic.likers.length),
                                  style: const TextStyle(
                                      color: inactiveIconColor, fontSize: 10))
                          ])
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
