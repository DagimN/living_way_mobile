import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/screens/story_view_screen.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class StoryCard extends StatefulWidget {
  final String id;
  final String videoUrl;
  //TODO: Create Story Model

  final bool isFirst;
  final bool isViewed;

  const StoryCard(
      {super.key,
      required this.id,
      required this.videoUrl,
      required this.isViewed,
      this.isFirst = false});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  late final controller =
      VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller.initialize().then((_) {
      setState(() {
        isInitialized = true;
      });

      if (widget.isFirst) {
        controller.play();
        controller.setVolume(0);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final contentController = Provider.of<ContentController>(context);

    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Hero(
      tag: 'videoPlayer - ${widget.id}',
      child: Container(
          height: screenHeight * .3,
          width: screenWidth * .35,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: isInitialized
              ? TextButton(
                  onPressed: () {
                    contentController.viewStory(widget.id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoryViewScreen(
                                id: widget.id, videoUrl: widget.videoUrl)));
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Opacity(
                      opacity: widget.isViewed ? 0.5 : 1,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: VideoPlayer(controller))))
              : Shimmer.fromColors(
                  direction: ShimmerDirection.rtl,
                  baseColor:
                      AppTheme(themeController.brightness).backgroundColor,
                  highlightColor: AppTheme(themeController.brightness)
                      .primaryColor
                      .withAlpha(120),
                  child: Container(
                      height: screenHeight * .3,
                      width: screenWidth * .35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppTheme(themeController.brightness)
                              .backgroundColor)))),
    );
  }
}
