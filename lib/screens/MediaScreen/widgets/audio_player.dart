import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'player_slider.dart';

class AudioMediaPlayer extends StatefulWidget {
  final AudioPlayer player;
  final String? backgroundImageUrl;
  final Content audio;
  const AudioMediaPlayer(
      {super.key,
      required this.player,
      required this.audio,
      this.backgroundImageUrl});

  @override
  State<AudioMediaPlayer> createState() => _AudioMediaPlayerState();
}

class _AudioMediaPlayerState extends State<AudioMediaPlayer> {
  double currentSeek = 0;
  double end = 0;

  StreamSubscription<Duration>? seekListener;
  StreamSubscription<Duration>? durationChangeListener;
  StreamSubscription<PlayerState>? audioPlayerListener;

  @override
  void initState() {
    super.initState();
    if (widget.audio.file != null) {
      widget.player.setSourceDeviceFile(widget.audio.file?.path ?? "");
    } else if (widget.audio.source.contains("audio")) {
      widget.player.setSourceAsset(widget.audio.source);
    } else {
      widget.player.setSourceUrl(widget.audio.source);
    }

    seekListener = widget.player.onPositionChanged.listen((duration) {
      double inMilliSeconds = duration.inMilliseconds.toDouble();

      if (end >= inMilliSeconds) {
        setState(() {
          currentSeek = duration.inMilliseconds.toDouble();
        });
      }
    });
    durationChangeListener = widget.player.onDurationChanged.listen((duration) {
      setState(() {
        end = duration.inMilliseconds.toDouble() - 1;
      });
    });

    audioPlayerListener = widget.player.onPlayerStateChanged.listen((event) {
      if ((event == PlayerState.completed) && mounted) {
        if (widget.audio.file != null) {
          widget.player.setSourceDeviceFile(widget.audio.file?.path ?? "");
        } else if (widget.audio.source.contains("audio")) {
          widget.player.setSourceAsset(widget.audio.source);
        } else {
          widget.player.setSourceUrl(widget.audio.source);
        }
        setState(() {
          currentSeek = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    seekListener?.cancel();
    durationChangeListener?.cancel();
    audioPlayerListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    const Radius radius = Radius.circular(7);

    return ClipRRect(
        borderRadius:
            const BorderRadius.only(bottomLeft: radius, bottomRight: radius),
        child: Stack(children: [
          widget.backgroundImageUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.backgroundImageUrl ?? "",
                  height: screenHeight * .5,
                  width: screenWidth,
                  fit: BoxFit.cover)
              : Image.asset(AppImages.topicBackground,
                  height: screenHeight * .5,
                  width: screenWidth,
                  fit: BoxFit.cover),
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                  width: screenWidth,
                  height: screenHeight * .5,
                  color: Colors.grey.withAlpha(128))),
          Positioned(
              top: screenHeight * .25,
              left: screenWidth * .45,
              child: IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () async {
                    if (widget.player.state == PlayerState.playing) {
                      widget.player.pause();
                      AnalyticsService.logEvent('audio_paused');
                    } else {
                      widget.player.resume();
                      AnalyticsService.logEvent('audio_played');
                    }
                  },
                  icon: Icon(
                      widget.player.state == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                      color:
                          AppTheme(themeController.brightness).primaryColor))),
          Positioned(
              bottom: -10,
              child: PlayerSlider(
                  end: end,
                  value: currentSeek,
                  onChanged: (value) async {
                    widget.player.seek(Duration(milliseconds: value.toInt()));
                    setState(() {
                      currentSeek = value;
                    });
                    AnalyticsService.logEvent('audio_seeked');
                  }))
        ]));
  }
}
