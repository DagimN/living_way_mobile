import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/screens/MediaScreen/widgets/player_slider.dart';
import 'package:living_way/themes/light_theme.dart';

class AudioMediaPlayer extends StatefulWidget {
  final AudioPlayer player;
  final String? backgroundImageUrl;
  final String audioUrl;
  const AudioMediaPlayer(
      {super.key,
      required this.player,
      required this.audioUrl,
      this.backgroundImageUrl});

  @override
  State<AudioMediaPlayer> createState() => _AudioMediaPlayerState();
}

class _AudioMediaPlayerState extends State<AudioMediaPlayer> {
  bool isPlaying = false;
  double currentSeek = 0;
  double end = 0;

  StreamSubscription<Duration>? seekListener;
  StreamSubscription<Duration>? durationChangeListener;
  StreamSubscription<PlayerState>? audioPlayerListener;

  @override
  void initState() {
    super.initState();
    if(widget.audioUrl.contains("audio")){
      widget.player.setSourceAsset(widget.audioUrl);
    }else{
      widget.player.setSourceUrl(widget.audioUrl);
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
        if (widget.audioUrl.contains("audio")) {
          widget.player.setSourceAsset(widget.audioUrl);
        } else {
          widget.player.setSourceUrl(widget.audioUrl);
        }
        setState(() {
          isPlaying = false;
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
                  color: Colors.grey.withOpacity(0.5))),
          Positioned(
              top: screenHeight * .25,
              left: screenWidth * .45,
              child: IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    isPlaying ? widget.player.pause() : widget.player.resume();

                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                      color: lightPrimaryColor))),
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white))),
          Positioned(
              bottom: -10,
              child: PlayerSlider(
                  end: end,
                  value: currentSeek,
                  onChanged: (value) {
                    widget.player.seek(Duration(milliseconds: value.toInt()));
                    setState(() {
                      currentSeek = value;
                    });
                  }))
        ]));
  }
}
