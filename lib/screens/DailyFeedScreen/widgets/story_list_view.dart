import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
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
        child: !contentController.isFetchingStories
            ? stories.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];

                      return StoryCard(story: story, isFirst: index == 0);
                    })
                : Center(
                    child: Text(
                        Tr.safe('noStoriesMessage',
                            fallback: "No stories available"),
                        style: const TextStyle(color: Colors.grey)))
            : Center(
                child: CircularProgressIndicator(
                    color: AppTheme(themeController.brightness).primaryColor)));
  }
}
