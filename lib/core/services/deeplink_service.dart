import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:living_way/controllers/controllers.dart' show ContentController;
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/screens.dart' show StoryViewScreen;
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks(); //TODO: Configure for iOS

  void initDeepLinks() {
    _appLinks.uriLinkStream.listen((Uri uri) {
      _processIncomingUri(uri);
    });

    _handleInitialUri();
  }

  Future<void> _handleInitialUri() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();

      if (initialUri != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _processIncomingUri(initialUri);
        });
      }
    } catch (e) {
      logger.e('Failed to get initial uri: $e');
    }
  }

  void _processIncomingUri(Uri uri) {
    logger.i('Received deep link: $uri');
    if (uri.authority == 'story') {
      final String storyId = uri.pathSegments[0];

      _navigateToStory(storyId);
    }
  }

  void _navigateToStory(String storyId) async {
    final context = UIService.navigatorKey.currentContext;

    if (context == null) return;

    int attempts = 3;

    final contentController =
        Provider.of<ContentController>(context, listen: false);

    Story? story;

    for (int attempt = 0; attempt < attempts; attempt++) {
      story = contentController.stories.firstWhereOrNull(
        (story) => story.id == storyId,
      );

      if (story != null) break;

      await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
    }

    if (story == null) {
      logger.e('Story with ID $storyId not found.');
      return;
    }

    final VideoPlayerController controller = VideoPlayerController.networkUrl(
      Uri.parse(story.sourceUrl),
    );
    await controller.initialize();

    UIService.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => StoryViewScreen(
          story: story!,
          controller: controller,
        ),
      ),
    );
  }
}
