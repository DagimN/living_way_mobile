import "dart:async";
import "package:audioplayers/audioplayers.dart" as audioplayers;
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:living_way/controllers/controllers.dart";
import "package:living_way/core/core.dart";
import "package:mini_music_visualizer/mini_music_visualizer.dart";
import "package:path_provider/path_provider.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

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
  final commentController = TextEditingController();

  bool isLoading = false;
  bool isPlaying = false;
  bool hasStarted = false;
  bool hasStartedPlaying = false;

  audioplayers.AudioPlayer? player;
  StreamSubscription<audioplayers.PlayerState>? audioPlayerListener;

  @override
  void initState() {
    super.initState();

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
    player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
        extendBody: widget.topic.type == TopicType.audio,
        extendBodyBehindAppBar: widget.topic.type == TopicType.audio,
        appBar: AppBar(
          backgroundColor: widget.topic.type == TopicType.video
              ? Colors.black
              : Colors.transparent,
          leading: IconButton(
              style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor:
                      AppTheme(themeController.brightness).primaryPaleColor,
                  foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            if (widget.topic.type == TopicType.video)
              IconButton(
                  icon:
                      const Icon(FontAwesomeIcons.youtube, color: Colors.white),
                  onPressed: () async {
                    AnalyticsService.logEvent('youtube_link_opened',
                        parameters: {
                          'topic_id': widget.topic.id,
                          'video_id': widget.topic.playlist.first.source
                        });
                    launchUrl(Uri.parse(
                        "'https://www.youtube.com/watch?v=${widget.topic.playlist.first.source}'"));
                  })
          ],
        ),
        body: Container(
            color: widget.topic.type == TopicType.video ? Colors.black : null,
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(children: [
                  widget.topic.type == TopicType.video
                      ? VideoPlayer(
                          videoId: currentSource,
                        )
                      : AudioMediaPlayer(
                          player: player!,
                          audio: widget.topic.playlist.first,
                          backgroundImageUrl: widget.topic.backgroundImageUrl),
                  if (widget.topic.type == TopicType.audio)
                    SizedBox(
                      height: screenHeight * .5,
                      child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 100),
                          itemCount: widget.topic.playlist.length,
                          itemBuilder: (context, index) {
                            final content = widget.topic.playlist[index];

                            return ListenableBuilder(
                                listenable: content,
                                builder: (context, child) {
                                  return ListTile(
                                      title: Text(content.title,
                                          style: const TextStyle(fontSize: 14)),
                                      subtitle: Text(content.presenter,
                                          style: const TextStyle(fontSize: 12)),
                                      trailing: content.source == currentSource
                                          ? isLoading
                                              ? SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: CircularProgressIndicator(
                                                      color: AppTheme(
                                                              themeController
                                                                  .brightness)
                                                          .primaryColor))
                                              : SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: MiniMusicVisualizer(
                                                      radius: 20,
                                                      animate: isPlaying,
                                                      color: AppTheme(
                                                              themeController
                                                                  .brightness)
                                                          .primaryColor))
                                          : !content.isDownloading
                                              ? content.file == null
                                                  ? SizedBox(
                                                      height: 25,
                                                      width: 25,
                                                      child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: const Icon(
                                                              Icons.download),
                                                          onPressed: () async {
                                                            final tempDir =
                                                                await getTemporaryDirectory();
                                                            AnalyticsService
                                                                .logEvent(
                                                                    'audio_download_started',
                                                                    parameters: {
                                                                  'content_id':
                                                                      content.id
                                                                });
                                                            content
                                                                .downloadContent(
                                                              dir: tempDir,
                                                              downloadToPublic:
                                                                  true,
                                                            );
                                                          }),
                                                    )
                                                  : const SizedBox()
                                              : SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: content
                                                        .downloadProgress,
                                                    color: AppTheme(
                                                            themeController
                                                                .brightness)
                                                        .primaryColor,
                                                    backgroundColor: AppTheme(
                                                            themeController
                                                                .brightness)
                                                        .primaryColor
                                                        .withAlpha(76),
                                                    strokeCap: StrokeCap.round,
                                                  ),
                                                ),
                                      onTap: () async {
                                        setState(() {
                                          hasStarted = true;
                                          hasStartedPlaying = false;
                                          currentSource = content.source;
                                          isLoading = true;
                                        });
                                        if (content.file != null) {
                                          await player?.setSourceDeviceFile(
                                              content.file?.path ?? "");
                                        }

                                        (content.source.contains("audio"))
                                            ? await player
                                                ?.setSourceAsset(content.source)
                                            : await player
                                                ?.setSourceUrl(content.source);

                                        await player?.resume();

                                        setState(() {
                                          isLoading = false;
                                          hasStartedPlaying = true;
                                        });
                                      });
                                });
                          }),
                    ),
                ]))));
  }
}
