import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/DevotionScreen/widgets/filter_bottom_sheet.dart';
import 'package:living_way/screens/DevotionScreen/widgets/topic_card.dart';
import 'package:living_way/screens/search_screen.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:provider/provider.dart';

class TopicsListview extends StatelessWidget {
  const TopicsListview({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final topics = contentController.topicList;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text('Topics',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme(themeController.brightness).iconColor)),
              IconButton(
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: AppTheme(themeController.brightness)
                            .backgroundColor,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FilterBottomSheet(
                              activityFilter:
                                  contentController.topicActivityFilter,
                              categoryFilter: contentController.categoryFilter,
                              booksSelected: contentController.booksFiltered);
                        });
                  },
                  icon: SvgPicture.asset(AppIcons.filter,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                          AppTheme(themeController.brightness).iconColor,
                          BlendMode.srcIn))),
              Hero(
                  tag: 'search',
                  child: IconButton(
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) =>
                                    const SearchScreen()));
                      },
                      icon: SvgPicture.asset(AppIcons.search,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                              AppTheme(themeController.brightness).iconColor,
                              BlendMode.srcIn))))
            ]),
            IconButton(
                style: IconButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  contentController.fetchTopics(isRefreshing: true);
                },
                icon: Icon(Icons.refresh,
                    color: AppTheme(themeController.brightness).iconColor))
          ]),
          SizedBox(
              width: screenWidth,
              height: orientation == Orientation.portrait
                  ? screenHeight * .15
                  : screenWidth * .15,
              child: !contentController.isFetchingTopic || topics.isNotEmpty
                  ? topics.isNotEmpty
                      ? ListView.builder(
                          controller: contentController.topicScrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: topics.length + 1,
                          itemBuilder: (context, index) {
                            final topic =
                                contentController.topicList.length > index
                                    ? topics[index]
                                    : Topic(
                                        id: '',
                                        title: '',
                                        viewCount: 0,
                                        likeCount: 0);
                            return topics.length > index
                                ? TopicCard(topic: topic)
                                : contentController.isFetchingTopic
                                    ? Container(
                                        height: 10,
                                        width: 40,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppTheme(
                                                    themeController.brightness)
                                                .primaryColor))
                                    : const SizedBox();
                          })
                      : const Center(
                          child: Text('No topics yet. Come back later',
                              style: TextStyle(color: Colors.grey)))
                  : Center(
                      child: CircularProgressIndicator(
                          color: AppTheme(themeController.brightness)
                              .primaryColor)))
        ]));
  }
}
