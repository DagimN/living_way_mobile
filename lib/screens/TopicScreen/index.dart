import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../DailyFeedScreen/widgets/threads_list_view.dart';

class TopicScreen extends StatefulWidget {
  final Topic topic;
  final ThreadData? subThread;
  const TopicScreen({super.key, required this.topic, this.subThread});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen>
    with TickerProviderStateMixin {
  final commentController = TextEditingController();
  late final tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<ProfileController>(context).userProfile;
    final themeController = Provider.of<ThemeController>(context);
    final devotionController = Provider.of<DevotionController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            decoration: BoxDecoration(
                gradient:
                    AppTheme(themeController.brightness).backgroundGradient),
            child: Stack(children: [
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
                              backgroundColor:
                                  AppTheme(themeController.brightness)
                                      .primaryPaleColor,
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
              if (devotionController.commentingThreadKeyNotifier.value == null)
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
                                    onSubmitted(devotionController, userProfile)
                                : null,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: userProfile != null
                                        ? () => onSubmitted(
                                            devotionController, userProfile)
                                        : null),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                hintText: Tr.t('commentPlaceholder')))))
            ])));
  }

  void onSubmitted(
      DevotionController devotionController, Profile profile) async {
    if (commentController.text.isEmpty) {
      UIService.showSnackbar(
          backgroundColor: Colors.orangeAccent,
          message: Tr.t('emptyCommentError'));
      return;
    }

    final topic = widget.topic;
    topic.threads.add(ThreadData(
        timestamp: DateTime.now(),
        threadId: const Uuid().v4(),
        commenter: profile.id,
        comment: commentController.text));
    tabController.animateTo(1);
    commentController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    await devotionController.updateTopic(topic);
  }
}
