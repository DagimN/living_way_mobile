import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/core/core.dart';
import 'package:video_player/video_player.dart';

import 'widget/story_controls.dart';
import 'widget/timeline_item_navigator.dart';

class StoryViewScreen extends StatefulWidget {
  final Story story;
  final VideoPlayerController controller;
  const StoryViewScreen(
      {super.key, required this.story, required this.controller});

  @override
  StoryViewScreenState createState() => StoryViewScreenState();
}

class StoryViewScreenState extends State<StoryViewScreen> {
  double currentSeek = 0;
  bool isClosing = false;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    widget.controller.seekTo(const Duration(seconds: 0));
    widget.controller.setVolume(1);
    widget.controller.addListener(videoControllerListener);
    widget.controller.play();
  }

  void videoControllerListener() {
    try {
      if (mounted) {
        final position = widget.controller.value.position;
        setState(() {
          currentSeek = position.inMilliseconds.toDouble();
        });

        if (position == widget.controller.value.duration && !isClosing) {
          setState(() {
            isClosing = true;
          });
          Navigator.pop(context);
        }
      }
    } catch (error) {
      logger.e(error);
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    widget.controller.seekTo(const Duration(seconds: 0));
    widget.controller.pause();
    widget.controller.removeListener(videoControllerListener);
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.story.metadata;

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Material(
              type: MaterialType.transparency,
              child: Hero(
                  tag: 'videoPlayer - ${widget.story.id}',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (_) {
                      _hideTimer?.cancel();
                      setState(() => _showControls = true);
                    },
                    onTapUp: (_) {
                      _startHideTimer();
                    },
                    onTapCancel: () {
                      _startHideTimer();
                    },
                    child: Stack(children: [
                      Center(
                        child: AspectRatio(
                            aspectRatio: widget.controller.value.aspectRatio,
                            child: VideoPlayer(widget.controller)),
                      ),
                      if (metadata != null)
                        Positioned(
                          top: 16,
                          right: 12,
                          child: SafeArea(
                              child: TimelineItemNavigator(
                                  metadata: metadata,
                                  currentSeek: currentSeek)),
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: _showControls ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: IgnorePointer(
                              ignoring: !_showControls,
                              child: StoryControls(
                                  controller: widget.controller,
                                  currentSeek: currentSeek,
                                  onUpdate: () => setState(() {}),
                                  story: widget.story)),
                        ),
                      )
                    ]),
                  )),
            )));
  }
}
