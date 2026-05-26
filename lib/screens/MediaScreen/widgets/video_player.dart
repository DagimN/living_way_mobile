import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String videoId;

  const VideoPlayer({
    super.key,
    required this.videoId,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final YoutubePlayerController _controller;

  bool _isPlayerReady = false;
  bool _isPlaying = false;
  bool _showControls = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        hideControls: true,
        hideThumbnail: true,
        mute: false,
        forceHD: false,
        enableCaption: false,
        showLiveFullscreenButton: false,
        useHybridComposition: true,
      ),
    )..addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final value = _controller.value;
    setState(() {
      _isPlaying = value.isPlaying;
      _currentPosition = value.position;
      _totalDuration = value.metaData.duration;
    });
  }

  void _onPlayerTap() {
    setState(() => _showControls = !_showControls);
    _resetHideTimer();
  }

  void _resetHideTimer() {
    _hideControlsTimer?.cancel();
    if (_showControls) {
      _hideControlsTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _showControls = false);
      });
    }
  }

  void _keepControlsVisible() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _seekBy(int seconds) {
    final target = Duration(
      seconds: (_currentPosition.inSeconds + seconds)
          .clamp(0, _totalDuration.inSeconds),
    );
    _controller.seekTo(target);
    _keepControlsVisible();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
  }

  double get _progressValue {
    if (_totalDuration.inSeconds == 0) return 0;
    return (_currentPosition.inSeconds / _totalDuration.inSeconds)
        .clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final primaryColor = AppTheme(theme.brightness).primaryColor;
    final size = MediaQuery.of(context).size;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        onReady: () {
          setState(() => _isPlayerReady = true);
          _controller.setPlaybackRate(1.0);
        },
      ),
      builder: (context, player) {
        return SizedBox(
          height: size.height * 0.9,
          width: size.width,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                      height: size.height * .8,
                      width: size.width,
                      child: player),
                  IgnorePointer(
                    child: SizedBox(
                      height: size.height * .7,
                      width: size.width,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: IgnorePointer(
                      child: Container(
                          height: size.height * .1,
                          width: size.width,
                          color: Colors.black),
                    ),
                  ),
                  if (!_isPlayerReady)
                    Positioned.fill(
                      child: CachedNetworkImage(
                          imageUrl:
                              'https://img.youtube.com/vi/${widget.videoId}/maxresdefault.jpg',
                          fit: BoxFit.contain),
                    ),
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _onPlayerTap,
                      child: AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: _buildPlayerOverlay(primaryColor),
                      ),
                    ),
                  ),
                  if (!_isPlayerReady)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
              _buildSeekBar(primaryColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerOverlay(Color primaryColor) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black54,
            Colors.transparent,
            Colors.transparent,
            Colors.black54
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.replay_10, color: Colors.white),
              onPressed: () => _seekBy(-10),
            ),
            const SizedBox(width: 24),
            IconButton(
              iconSize: 56,
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
              ),
              onPressed: () {
                _isPlaying ? _controller.pause() : _controller.play();
                _keepControlsVisible();
              },
            ),
            const SizedBox(width: 24),
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.forward_10, color: Colors.white),
              onPressed: () => _seekBy(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeekBar(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            _formatDuration(_currentPosition),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          Expanded(
            child: Slider(
              value: _progressValue,
              onChanged: _isPlayerReady
                  ? (value) {
                      _controller.seekTo(Duration(
                        seconds: (value * _totalDuration.inSeconds).toInt(),
                      ));
                      _keepControlsVisible();
                    }
                  : null,
              activeColor: primaryColor,
              inactiveColor: Colors.white24,
              thumbColor: primaryColor,
            ),
          ),
          Text(
            _formatDuration(_totalDuration),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }
}
