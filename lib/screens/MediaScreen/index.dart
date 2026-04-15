import "dart:async";
import "package:audioplayers/audioplayers.dart" as audioplayers;
import "package:flutter/material.dart";
import "package:living_way/controllers/controllers.dart";
import "package:living_way/core/core.dart";
import "package:living_way/screens/DevotionScreen/widgets/threads_list_view.dart";
import "package:provider/provider.dart";
import "package:uuid/uuid.dart";
import "package:youtube_player_iframe/youtube_player_iframe.dart";
import "package:mini_music_visualizer/mini_music_visualizer.dart";

import "widgets/audio_player.dart";
import "widgets/video_player.dart";

class MediaScreen extends StatefulWidget {
  final Topic topic;

  const MediaScreen({super.key, required this.topic});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with TickerProviderStateMixin {
  late String currentSource = widget.topic.playlist.first.source;
  late final tabController = TabController(length: 2, vsync: this);
  final controller = YoutubePlayerController(
      params: const YoutubePlayerParams(mute: false, showControls: true));
  final commentController = TextEditingController();

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
    final userProfile = Provider.of<ProfileController>(context).userProfile;
    final themeController = Provider.of<ThemeController>(context);
    final devotionController = Provider.of<DevotionController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient:
                    AppTheme(themeController.brightness).backgroundGradient),
            child: Stack(children: [
              SingleChildScrollView(
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
                      TabBar(controller: tabController, tabs: const [
                        Tab(child: Text("Playlist")),
                        Tab(child: Text("Threads"))
                      ]),
                      SizedBox(
                          width: screenWidth,
                          height: screenHeight * .5,
                          child:
                              TabBarView(controller: tabController, children: [
                            ListView.builder(
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.fromLTRB(5, 0, 5, 100),
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
                                                  color: AppTheme(
                                                          themeController
                                                              .brightness)
                                                      .primaryColor))
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          hasStarted = true;
                                          hasStartedPlaying = false;
                                          currentSource = metadata.source;
                                        });

                                        widget.topic.type == TopicType.video
                                            ? controller.loadVideoById(
                                                videoId: metadata.source)
                                            : (metadata.source
                                                    .contains("audio"))
                                                ? player?.setSourceAsset(
                                                    metadata.source)
                                                : player?.setSourceUrl(
                                                    metadata.source);
                                      });
                                }),
                            ThreadsListView(
                                doesSubThreadExist: false, topic: widget.topic)
                          ]))
                    ]))
              ])),
              //FIXME: Refactor for DRY
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
                                hintText: "What's on your mind?"))))
            ])));
  }

  void onSubmitted(
      DevotionController devotionController, Profile profile) async {
    if (commentController.text.isEmpty) {
      //TODO: Warn user
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
