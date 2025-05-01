import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:provider/provider.dart';

import 'story_card.dart';

class StoryListView extends StatelessWidget {
  const StoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final stories = contentController.stories;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
        width: screenWidth,
        height: orientation == Orientation.portrait
            ? screenHeight * .30
            : screenWidth * .30,
        child: !contentController.isFetchingTopic || stories.isNotEmpty
            ? stories.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];

                      return StoryCard(
                          id: story,
                          videoUrl:
                              "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                          isViewed:
                              contentController.viewedStories.contains(story),
                          isFirst: index == 0);
                    })
                : const Center(
                    child: Text('No stories yet. Come back later',
                        style: TextStyle(color: Colors.grey)))
            : Center(
                child: CircularProgressIndicator(
                    color: AppTheme(themeController.brightness).primaryColor)));
  }
}
