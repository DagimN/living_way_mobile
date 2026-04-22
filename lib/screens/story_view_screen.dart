import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'MediaScreen/widgets/player_slider.dart';

class StoryViewScreen extends StatefulWidget {
  final String id;
  final VideoPlayerController controller;
  const StoryViewScreen(
      {super.key, required this.id, required this.controller});

  @override
  StoryViewScreenState createState() => StoryViewScreenState();
}

class StoryViewScreenState extends State<StoryViewScreen> {
  double currentSeek = 0;
  bool isClosing = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    widget.controller.seekTo(const Duration(seconds: 0));
    widget.controller.setVolume(1);
    widget.controller.play();

    Future.delayed(const Duration(milliseconds: 3000),
        () => widget.controller.addListener(videoControllerListener));
  }

  void videoControllerListener() {
    if (context.mounted) {
      setState(() {
        currentSeek =
            widget.controller.value.position.inMilliseconds.toDouble();
      });

      if (widget.controller.value.position ==
              widget.controller.value.duration &&
          !isClosing) {
        setState(() {
          isClosing = true;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    widget.controller.removeListener(videoControllerListener);
    widget.controller.seekTo(const Duration(seconds: 0));
    widget.controller.pause();
    widget.controller.setVolume(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return SafeArea(
        child: Scaffold(
            backgroundColor:
                AppTheme(themeController.brightness).backgroundColor,
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
            ),
            body: Material(
              type: MaterialType.transparency,
              child: Hero(
                  tag: 'videoPlayer - ${widget.id}',
                  child: Stack(children: [
                    VideoPlayer(widget.controller),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder()),
                              onPressed: () async {
                                if (widget.controller.value.isPlaying) {
                                  await widget.controller.pause();
                                  setState(() {});
                                  return;
                                }

                                if (!widget.controller.value.isPlaying) {
                                  await widget.controller.play();
                                  setState(() {});
                                  return;
                                }
                              },
                              icon: Icon(widget.controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow)),
                          SizedBox(
                              height: 50,
                              child: PlayerSlider(
                                  end: widget
                                      .controller.value.duration.inMilliseconds
                                      .toDouble(),
                                  value: currentSeek,
                                  onChanged: (value) async {
                                    await widget.controller.seekTo(
                                        Duration(milliseconds: value.toInt()));

                                    setState(() {});
                                  }))
                        ])
                  ])),
            )));
  }
}
