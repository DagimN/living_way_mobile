import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/TopicScreen/widgets/thread.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class TopicScreen extends StatelessWidget {
  final Topic topic;
  const TopicScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
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
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButton<ActivityFilter>(
                          items: const [
                            DropdownMenuItem(
                                value: ActivityFilter.latest,
                                child: Text('Latest')),
                            DropdownMenuItem(
                                value: ActivityFilter.mostActive,
                                child: Text('Most Active')),
                            DropdownMenuItem(
                                value: ActivityFilter.mostLiked,
                                child: Text('Most Liked')),
                            DropdownMenuItem(
                                value: ActivityFilter.mostViewed,
                                child: Text('Most Viewed'))
                          ],
                          underline: Container(
                              height: 1.0,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: lightPrimaryColor,
                                          width: 0.0)))),
                          style: const TextStyle(color: lightPrimaryColor),
                          value: contentController.threadActivityFilter,
                          onChanged: (value) {
                            contentController.setThreadFilter =
                                value ?? ActivityFilter.latest;
                          }))),
              SizedBox(
                  height: screenHeight * .6,
                  child: ListView.builder(
                      itemCount: 9,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          Thread(isLast: index == 8)))
            ])));
  }
}
