import "dart:async";

import "package:audioplayers/audioplayers.dart" as audioplayers;
import "package:flutter/material.dart";
import "package:living_way/models/topic.dart";
import "package:living_way/screens/DevotionScreen/widgets/threads_list_view.dart";
import "package:living_way/screens/MediaScreen/widgets/audio_player.dart";
import "package:living_way/screens/MediaScreen/widgets/video_player.dart";
import "package:living_way/themes/light_theme.dart";
import "package:youtube_player_iframe/youtube_player_iframe.dart";
import "package:mini_music_visualizer/mini_music_visualizer.dart";

class MediaScreen extends StatefulWidget {
  final Topic topic;
  const MediaScreen({super.key, required this.topic});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late String currentSource = widget.topic.playlist.first.source;
  final controller = YoutubePlayerController(
      params: const YoutubePlayerParams(mute: false, showControls: true));
  audioplayers.AudioPlayer? player;
  StreamSubscription<YoutubePlayerValue>? youtubePlayerListener;
  StreamSubscription<audioplayers.PlayerState>? audioPlayerListener;

  bool hasStarted = false;
  bool hasStartedPlaying = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    if (widget.topic.type == TopicType.video) {
      youtubePlayerListener = controller.listen((event) async {
        if (event.playerState == PlayerState.playing && mounted) {
          setState(() {
            hasStartedPlaying = true;
            isPlaying = true;
          });
        }

        if (event.playerState != PlayerState.playing && mounted) {
          setState(() {
            isPlaying = false;
          });
        }

        if (event.playerState == PlayerState.ended && mounted) {
          setState(() {
            hasStarted = false;
            hasStartedPlaying = false;
          });
        }
      });
    }

    if (widget.topic.type == TopicType.audio) {
      player = audioplayers.AudioPlayer();
      audioPlayerListener = player?.onPlayerStateChanged.listen((event) {
        if (event == audioplayers.PlayerState.playing && mounted) {
          setState(() {
            isPlaying = true;
          });
        }

        if ((event == audioplayers.PlayerState.paused ||
                event == audioplayers.PlayerState.completed) &&
            mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    audioPlayerListener?.cancel();
    youtubePlayerListener?.cancel();
    player?.dispose();
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
              widget.topic.type == TopicType.video
                  ? VideoPlayer(
                      controller: controller,
                      videoId: currentSource,
                      backgroundImageUrl: widget.topic.backgroundImageUrl)
                  : AudioMediaPlayer(
                      player: player!,
                      audioUrl: widget.topic.playlist.first.source,
                      backgroundImageUrl: widget.topic.backgroundImageUrl),
              DefaultTabController(
                  length: 2,
                  child: Column(children: [
                    const TabBar(tabs: [
                      Tab(child: Text("Playlist")),
                      Tab(child: Text("Threads"))
                    ]),
                    SizedBox(
                        width: screenWidth,
                        height: screenHeight * .5,
                        child: TabBarView(children: [
                          ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 25),
                              itemCount: widget.topic.playlist.length,
                              itemBuilder: (context, index) {
                                final metadata = widget.topic.playlist[index];

                                return ListTile(
                                    title: Text(metadata.title,
                                        style: const TextStyle(fontSize: 14)),
                                    subtitle: Text(metadata.presenter,
                                        style: const TextStyle(fontSize: 12)),
                                    trailing: metadata.source == currentSource
                                        ? SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: MiniMusicVisualizer(
                                                radius: 20,
                                                animate: isPlaying,
                                                color: lightPrimaryColor))
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        hasStarted = true;
                                        hasStartedPlaying = false;
                                        currentSource = metadata.source;
                                      });
                                      controller.loadVideoById(
                                          videoId: metadata.source);
                                    });
                              }),
                          ThreadsListView(
                              doesSubThreadExist: false, topic: widget.topic)
                        ]))
                  ]))
            ]))));
  }
}
