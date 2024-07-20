import "dart:async";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:living_way/config/paths.dart";
import "package:living_way/models/topic.dart";
import "package:living_way/services/logging_service.dart";
import "package:living_way/themes/light_theme.dart";
import "package:living_way/widgets/loader_animation.dart";
import "package:youtube_player_iframe/youtube_player_iframe.dart";

class MediaScreen extends StatefulWidget {
  final Topic topic;
  const MediaScreen({super.key, required this.topic});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with TickerProviderStateMixin {
  late final animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));
  final controller = YoutubePlayerController(
      params: const YoutubePlayerParams(mute: false, showControls: true));
  StreamSubscription<YoutubePlayerValue>? youtubePlayerListener;
  bool hasStarted = false;
  bool hasStartedPlaying = false;

  @override
  void initState() {
    super.initState();
    youtubePlayerListener = controller.listen((event) async {
      if (event.playerState == PlayerState.playing) {
        animationController.forward();
        setState(() {
          hasStartedPlaying = true;
        });
      }

      if (event.playerState == PlayerState.ended) {
        animationController.reverse();
        setState(() {
          hasStarted = false;
          hasStartedPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    youtubePlayerListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: SingleChildScrollView(
                child: Column(children: [
              YoutubePlayerControllerProvider(
                  controller: controller,
                  child: YoutubeValueBuilder(builder: (videoContext, value) {
                    return Stack(children: [
                      widget.topic.backgroundImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: widget.topic.backgroundImageUrl ?? "",
                              height: screenHeight * .5,
                              width: screenWidth,
                              fit: BoxFit.cover)
                          : Image.asset(AppImages.topicBackground,
                              height: screenHeight * .5,
                              width: screenWidth,
                              fit: BoxFit.cover),
                      SizedBox(
                          height: screenHeight * .5,
                          width: screenWidth,
                          child: FutureBuilder(
                              future: videoContext.ytController.playerState,
                              builder: (context, snapshot) {
                                return AnimatedBuilder(
                                    animation: animationController,
                                    builder: (context, child) => Opacity(
                                        opacity: animationController.value,
                                        child: Visibility(
                                            visible: hasStarted &&
                                                snapshot.data !=
                                                    PlayerState.ended,
                                            maintainState: true,
                                            maintainAnimation: true,
                                            maintainSize: true,
                                            maintainSemantics: true,
                                            child: YoutubePlayerScaffold(
                                                controller: controller,
                                                builder: (context, player) {
                                                  return player;
                                                }))));
                              })),
                      if (!hasStarted)
                        Positioned(
                            top: screenHeight * .25,
                            left: screenWidth * .45,
                            child: IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    hasStarted = true;
                                  });
                                  controller.loadVideoById(
                                      videoId: "N1GzWdX8Ok0");
                                },
                                icon: const Icon(Icons.play_arrow,
                                    color: lightPrimaryColor))),
                      FutureBuilder(
                          future: videoContext.ytController.playerState,
                          builder: (context, snapshot) {
                            logger.i(snapshot.data);
                            return hasStarted && !hasStartedPlaying
                                ? const LoaderAnimation()
                                : const SizedBox();
                          }),
                      //FIXME: Loading animation keeps popping up when trying to seek through video
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
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white)))
                    ]);
                  }))
            ]))));
  }
}
