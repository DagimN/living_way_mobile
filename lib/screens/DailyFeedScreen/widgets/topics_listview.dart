import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'filter_bottom_sheet.dart';
import 'topic_card.dart';

class TopicsListview extends StatelessWidget {
  const TopicsListview({super.key});

  @override
  Widget build(BuildContext context) {
    final devotionController = Provider.of<DevotionController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final topics = devotionController.topicList;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(Tr.t('home.topics'),
                style: TextStyle(
                    fontSize: 16,
                    color: AppTheme(themeController.brightness).iconColor)),
            // IconButton(
            //     style: IconButton.styleFrom(padding: EdgeInsets.zero),
            //     onPressed: () {
            //       showModalBottomSheet(
            //           context: context,
            //           backgroundColor: AppTheme(themeController.brightness)
            //               .backgroundColor,
            //           isScrollControlled: true,
            //           builder: (BuildContext context) {
            //             return FilterBottomSheet(
            //                 sortOption: devotionController.sortOption,
            //                 categoryFilter: devotionController.categoryFilter,
            //                 booksSelected: devotionController.booksFiltered);
            //           });
            //     },
            //     icon: SvgPicture.asset(AppIcons.filter,
            //         height: 24,
            //         colorFilter: ColorFilter.mode(
            //             AppTheme(themeController.brightness).iconColor,
            //             BlendMode.srcIn))),
          ]),
          SizedBox(
              width: screenWidth,
              height: orientation == Orientation.portrait
                  ? screenHeight * .15
                  : screenWidth * .15,
              child: !devotionController.isFetching || topics.isNotEmpty
                  ? topics.isNotEmpty
                      ? ListView.builder(
                          controller: devotionController.scrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: topics.length + 1,
                          itemBuilder: (context, index) {
                            final topic = topics.length > index
                                ? topics[index]
                                : Topic.empty();
                            return topics.length > index
                                ? TopicCard(topic: topic)
                                : devotionController.isFetching
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
                      : Center(
                          child: Text(
                              Tr.safe('home.noTopicsMessage',
                                  fallback: "No topics available"),
                              style: const TextStyle(color: Colors.grey)))
                  : Center(
                      child: CircularProgressIndicator(
                          color: AppTheme(themeController.brightness)
                              .primaryColor)))
        ]));
  }
}
