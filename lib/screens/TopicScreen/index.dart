import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/DevotionScreen/widgets/threads_list_view.dart';
import 'package:living_way/themes/light_theme.dart';

class TopicScreen extends StatelessWidget {
  final Topic topic;
  final ThreadData? subThread;
  const TopicScreen({super.key, required this.topic, this.subThread});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: SingleChildScrollView(
                child: Column(children: [
              Stack(children: [
                topic.backgroundImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: topic.backgroundImageUrl ?? "",
                        height: screenHeight * .3,
                        width: screenWidth,
                        fit: BoxFit.cover)
                    : Image.asset(AppImages.topicBackground,
                        height: screenHeight * .3,
                        width: screenWidth,
                        fit: BoxFit.cover),
                Positioned(
                    top: 50,
                    left: 15,
                    child: IconButton(
                        style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: lightPrimaryPaleColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.white)))
              ]),
              ThreadsListView(
                  topic: topic,
                  doesSubThreadExist: subThread != null,
                  subThread: subThread)
            ]))));
  }
}
