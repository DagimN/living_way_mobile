import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/DevotionScreen/widgets/topic_card.dart';
import 'package:living_way/themes/light_theme.dart';

class TopicsListview extends StatelessWidget {
  const TopicsListview({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    final topics = <Topic>[
      Topic(title: 'Book of Daniel', viewCount: 18000, isFavorite: true),
      Topic(title: 'Book of Hosea', viewCount: 6000, type: TopicType.audio),
      Topic(title: 'Book of Amos', viewCount: 200, type: TopicType.video),
      Topic(title: 'Book of Zephanniah', viewCount: 200000)
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
                onPressed: () {},
                icon: SvgPicture.asset(AppIcons.filter, height: 24)),
            IconButton(
                style: IconButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {},
                icon: SvgPicture.asset(AppIcons.search, height: 24))
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
