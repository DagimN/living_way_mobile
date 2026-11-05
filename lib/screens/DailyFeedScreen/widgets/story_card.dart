import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/StoryViewScreen/index.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class StoryCard extends StatefulWidget {
  final Story story;
  final bool isFirst;

  const StoryCard({super.key, required this.story, this.isFirst = false});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  VideoPlayerController? controller;
  bool isInitialized = false;
  bool thumbnailHasError = false;

  void initializeVideoController() {
    if (controller == null) {
      controller = widget.story.file != null
          ? VideoPlayerController.file(widget.story.file!)
          : VideoPlayerController.networkUrl(Uri.parse(widget.story.sourceUrl));
      controller?.initialize().then((_) {
        setState(() {
          isInitialized = true;
        });

        if (widget.isFirst) {
          controller?.play();
          controller?.setVolume(0);
        }
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final contentController = Provider.of<ContentController>(context);

    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    initializeVideoController();

    return Material(
      type: MaterialType.transparency,
      child: Hero(
        tag: 'videoPlayer - ${widget.story.id}',
        child: Container(
            height: screenHeight * .3,
            width: screenWidth * .35,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: controller != null && isInitialized
                ? TextButton(
                    onPressed: () async {
                      contentController.viewStory(widget.story.id);
                      AnalyticsService.logEvent('story_clicked',
                          parameters: {'story_id': widget.story.id});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryViewScreen(
                                  story: widget.story,
                                  controller: controller!)));
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Opacity(
                        opacity: widget.story.isViewed ? 0.5 : 1,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: widget.story.metadata?.image != null &&
                                    !thumbnailHasError
                                ? CachedNetworkImage(
                                    imageUrl: widget.story.metadata!.image!,
                                    height: screenHeight * .3,
                                    fit: BoxFit.cover,
                                    errorListener: (value) => setState(() {
                                      thumbnailHasError = true;
                                    }),
                                  )
                                : VideoPlayer(controller!))))
                : Shimmer.fromColors(
                    direction: ShimmerDirection.rtl,
                    baseColor: theme.backgroundColor,
                    highlightColor: theme.primaryColor.withAlpha(120),
                    child: Container(
                        height: screenHeight * .3,
                        width: screenWidth * .35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: theme.backgroundColor)))),
      ),
    );
  }
}
