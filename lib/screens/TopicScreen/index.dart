import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/models/profile.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/DevotionScreen/widgets/threads_list_view.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TopicScreen extends StatefulWidget {
  final Topic topic;
  final ThreadData? subThread;
  const TopicScreen({super.key, required this.topic, this.subThread});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> with TickerProviderStateMixin{
  final commentController = TextEditingController();
  late final tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<ProfileController>(context).userProfile;
    final contentController = Provider.of<ContentController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: Column(children: [
                  Stack(children: [
                    widget.topic.backgroundImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.topic.backgroundImageUrl ?? "",
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
                                backgroundColor: lightPrimaryPaleColor,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)))
                  ]),
                  ThreadsListView(
                      topic: widget.topic,
                      doesSubThreadExist: widget.subThread != null,
                      subThread: widget.subThread)
                ])),
                Positioned(
                    bottom: 0,
                    child: Container(
                        height: 50,
                        width: screenWidth * .93,
                        margin: const EdgeInsets.all(10),
                        child: TextField(
                            controller: commentController,
                            onSubmitted: userProfile != null
                                ? (value) =>
                                    onSubmitted(contentController, userProfile)
                                : null,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: userProfile != null
                                        ? () => onSubmitted(
                                            contentController, userProfile)
                                        : null),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                hintText: "What's on your mind?"))))
              ]
            )));
  }

  void onSubmitted(ContentController contentController, Profile profile) async {
    if (commentController.text.isEmpty) {
      //TODO: Warn user
      return;
    }

    final topic = widget.topic;
    topic.threads.add(ThreadData(
        threadId: const Uuid().v4(),
        commenter: profile.id,
        comment: commentController.text));
    tabController.animateTo(1);
    commentController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    await contentController.updateTopic(topic);
  }
}
