import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/screens/MediaScreen/widgets/player_slider.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StoryViewScreen extends StatefulWidget {
  final String id;
  final String videoUrl;
  const StoryViewScreen({super.key, required this.id, required this.videoUrl});

  @override
  StoryViewScreenState createState() => StoryViewScreenState();
}

class StoryViewScreenState extends State<StoryViewScreen> {
  late final controller =
      VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
  double currentSeek = 0;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller.initialize().then((_) {
      setState(() {
        isInitialized = true;
      });
      controller.play();
    });

    controller.addListener(() {
      setState(() {
        currentSeek = controller.value.position.inMilliseconds.toDouble();
      });

      if (controller.value.position == controller.value.duration) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return SafeArea(
        child: Scaffold(
            backgroundColor:
                AppTheme(themeController.brightness).backgroundColor,
            body: Hero(
                tag: 'videoPlayer - ${widget.id}',
                child: Stack(children: [
                  VideoPlayer(controller),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        if (isInitialized)
                          IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder()),
                              onPressed: () async {
                                if (controller.value.isPlaying) {
                                  await controller.pause();
                                  setState(() {});
                                  return;
                                }

                                if (!controller.value.isPlaying) {
                                  await controller.play();
                                  setState(() {});
                                  return;
                                }
                              },
                              icon: Icon(controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow)),
                        if (isInitialized)
                          SizedBox(
                              height: 50,
                              child: PlayerSlider(
                                  end: controller.value.duration.inMilliseconds
                                      .toDouble(),
                                  value: currentSeek,
                                  onChanged: (value) async {
                                    await controller.seekTo(
                                        Duration(milliseconds: value.toInt()));

                                    setState(() {});
                                  }))
                      ])
                ]))));
  }
}
