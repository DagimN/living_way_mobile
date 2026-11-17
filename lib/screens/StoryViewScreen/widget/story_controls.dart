import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/MediaScreen/widgets/player_slider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'story_interactions_bottomsheet.dart';
import 'timeline_bottomsheet.dart';

class StoryControls extends StatelessWidget {
  final VideoPlayerController controller;
  final Story story;
  final double currentSeek;
  final Function() onUpdate;
  const StoryControls(
      {super.key,
      required this.controller,
      required this.currentSeek,
      required this.onUpdate,
      required this.story});

  Text _descriptionText(String description) {
    final spans = <InlineSpan>[];
    final urlPattern = RegExp(r'https?://[^\s]+|www\.[^\s]+');
    var lastMatchEnd = 0;

    for (final match in urlPattern.allMatches(description)) {
      final url = match.group(0)!;
      final cleanUrl = url.replaceFirst(RegExp(r'[.,!?;:]+$'), '');
      final punctuation = url.substring(cleanUrl.length);
      if (match.start > lastMatchEnd) {
        spans.add(
            TextSpan(text: description.substring(lastMatchEnd, match.start)));
      }

      final uri = Uri.tryParse(
          cleanUrl.startsWith('www.') ? 'https://$cleanUrl' : cleanUrl);

      spans.add(TextSpan(
          text: cleanUrl,
          style: const TextStyle(
              decoration: TextDecoration.underline, color: Colors.blueAccent),
          recognizer: TapGestureRecognizer()
            ..onTap = uri == null ? null : () => launchUrl(uri)));
      if (punctuation.isNotEmpty) spans.add(TextSpan(text: punctuation));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < description.length) {
      spans.add(TextSpan(text: description.substring(lastMatchEnd)));
    }

    return Text.rich(
      TextSpan(children: spans),
      softWrap: true,
      textAlign: TextAlign.start,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final metadata = story.metadata;
    final interactions = story.interactions
        .where((interaction) => !interaction.isFlagged)
        .toList();

    double screenWidth = MediaQuery.sizeOf(context).width;

    interactions
        .sort((interactionA, interactionB) => interactionB.isPinned ? 1 : -1);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.black45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              if (metadata?.title != null)
                Container(
                  width: screenWidth * .85,
                  padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
                  child: Text(metadata?.title ?? "",
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ),
              if (metadata?.description != null)
                Container(
                  width: screenWidth * .95,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _descriptionText(metadata?.description ?? ""),
                ),
              SizedBox(
                width: screenWidth,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: const CircleBorder()),
                          onPressed: () async {
                            if (controller.value.isPlaying) {
                              await controller.pause();
                              AnalyticsService.logEvent('story_paused');
                              onUpdate();
                              return;
                            }

                            if (!controller.value.isPlaying) {
                              await controller.play();
                              AnalyticsService.logEvent('story_played');
                              onUpdate();
                              return;
                            }
                          },
                          icon: Icon(controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow)),
                      Expanded(
                          child: SizedBox(
                              height: 50,
                              child: PlayerSlider(
                                  end: controller.value.duration.inMilliseconds
                                      .toDouble(),
                                  value: currentSeek,
                                  onChanged: (value) async {
                                    AnalyticsService.logEvent('video_seeked',
                                        parameters: {"value": value});
                                    await controller.seekTo(
                                        Duration(milliseconds: value.toInt()));

                                    onUpdate();
                                  })))
                    ]),
              ),
              SizedBox(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      tooltip: Tr.t("timeline"),
                      style: IconButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder()),
                      onPressed: () => TimelineBottomsheet.show(context,
                          controller: controller,
                          timeline: metadata?.timeline ?? []),
                      icon: const Icon(Icons.format_list_bulleted),
                    ),
                    IconButton(
                      tooltip: Tr.t("share"),
                      style: IconButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder()),
                      onPressed: () async {
                        const url = appFlavor == "dev"
                            ? Urls.devApiUrl
                            : appFlavor == "staging"
                                ? Urls.stagingApiUrl
                                : Urls.prodApiUrl;
                        final String shareUrl =
                            '$url/api/v1/content/story/${story.id}';
                        SharePlus.instance.share(ShareParams(
                            text: 'Check this out on Living Way: $shareUrl'));
                      },
                      icon: const Icon(Icons.share),
                    ),
                    IconButton(
                      tooltip: Tr.t("comment"),
                      style: IconButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder()),
                      onPressed: () => StoryInteractionsBottomsheet.show(
                          context,
                          interactions: interactions),
                      icon: const Icon(Icons.comment),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
