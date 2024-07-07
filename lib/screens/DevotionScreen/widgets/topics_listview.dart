import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/DevotionScreen/widgets/filter_bottom_sheet.dart';
import 'package:living_way/screens/DevotionScreen/widgets/topic_card.dart';
import 'package:living_way/screens/search_screen.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class TopicsListview extends StatelessWidget {
  const TopicsListview({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    final topics = <Topic>[
      Topic(
          title: 'Book of Daniel',
          viewCount: 18000,
          likeCount: 500,
          isFavorite: true,
          backgroundImageUrl:
              "https://cdn.pixabay.com/photo/2023/03/30/01/40/daniel-7886652_1280.jpg"),
      Topic(
          title: 'Book of Hosea',
          viewCount: 6000,
          likeCount: 1000,
          type: TopicType.audio,
          backgroundImageUrl:
              "https://i0.wp.com/www.cruciformcoc.com/wp-content/uploads/2020/08/Hosea.jpg?resize=400%2C400&ssl=1"),
      Topic(
          title: 'Book of Amos',
          viewCount: 0,
          likeCount: 10000,
          type: TopicType.video,
          backgroundImageUrl:
              "https://media.bible.art/ab12395e-bca0-4498-96e9-6669a321bd63-compressed.jpg"),
      Topic(
          title: 'Book of Zephanniah',
          viewCount: 200000,
          likeCount: 0,
          backgroundImageUrl:
              "https://media.bible.art/af6dd47b-bffc-4f30-804d-f087f3ba51ce-compressed.jpg")
    ];

    return Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Column(children: [
          Row(children: [
            const Text('Topics',
                style: TextStyle(fontSize: 16, color: lightPrimaryColor)),
            IconButton(
                style: IconButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return FilterBottomSheet(
                            activityFilter:
                                contentController.topicActivityFilter,
                            categoryFilter: contentController.categoryFilter,
                            booksSelected: contentController.booksFiltered);
                      });
                },
                icon: SvgPicture.asset(AppIcons.filter, height: 24)),
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
                    icon: SvgPicture.asset(AppIcons.search, height: 24)))
          ]),
          SizedBox(
              width: screenWidth,
              height: orientation == Orientation.portrait
                  ? screenHeight * .15
                  : screenWidth * .15,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return TopicCard(topic: topic);
                  }))
        ]));
  }
}
