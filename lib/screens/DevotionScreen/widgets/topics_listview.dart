import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/models/media_metadata.dart';
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
              "https://cdn.pixabay.com/photo/2023/03/30/01/40/daniel-7886652_1280.jpg",
          threads: contentController.threads),
      Topic(
          title: 'ተፈፀመ 2016',
          viewCount: 139,
          likeCount: 10,
          isFavorite: true,
          type: TopicType.video,
          backgroundImageUrl:
              "https://mypastoralponderings.com/wp-content/uploads/2021/04/1617051446892-d4f1fe46-96cd-4ddc-ac51-30b82c367912_-e1617111616909.jpg?w=769",
          threads: contentController.threads,
          playlist: [
            MediaMetadata(
                title: 'ነገረ መስቀል: የእግዚአብሔር ጥበብና ሃይል',
                presenter: 'Yoseph Yisma',
                source: "KLwwB2qUOBg"),
            MediaMetadata(
                title: 'መስቀል ( እርሱ ስለ እኛ )',
                presenter: 'Henock Bekele',
                source: "Mmc0g891eXk"),
            MediaMetadata(
                title: 'መስቀሉና ተግባራዊ ሕይወት',
                presenter: 'Esisha Mengistu',
                source: "n3PNnw8fwJ4")
          ]),
      Topic(
          title: 'For His Glory',
          viewCount: 139,
          likeCount: 10,
          isFavorite: true,
          type: TopicType.audio,
          backgroundImageUrl:
              "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/426074019_7954890431204553_8594967751125902832_n.jpg?stp=dst-jpg_e35&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=zT5H13_Co_MQ7kNvgFEQi6X&edm=AGenrX8BAAAA&ccb=7-5&oh=00_AYC990nx1k9bKc91cV0hUdl6ALPWG8TEjHDFxJsKvgGf2A&oe=66A95BC1&_nc_sid=ed990e",
          threads: contentController.threads,
          playlist: [
            MediaMetadata(
                title: 'Introduction',
                presenter: 'Admas Getachew',
                source: 'audio/Intro.mp3'),
            MediaMetadata(
                title: 'Singleness Part 1',
                presenter: 'Admas Getachew',
                source: 'audio/Singleness_1.mp3'),
            MediaMetadata(
                title: 'Singleness Part 2',
                presenter: 'Keneaa Zekarias',
                source: 'audio/Singleness_2.mp3'),
            MediaMetadata(
                title: 'Singleness Part 3',
                presenter: 'Keneaa Zekarias & Admas Getachew',
                source: 'audio/Singleness_3.mp3'),
            MediaMetadata(
                title: 'Manhood & Womanhood',
                presenter: 'Keneaa Zekarias',
                source: 'audio/Manhood_Womanhood.mp3'),
            MediaMetadata(
                title: 'Manhood',
                presenter: 'Admas Getachew',
                source: 'audio/Manhood.mp3'),
            MediaMetadata(
                title: 'Womanhood Part 1',
                presenter: 'Herani Sahlu',
                source: 'audio/Womanhood_1.mp3'),
            MediaMetadata(
                title: 'Womanhood Part 2',
                presenter: 'Admas Getachew',
                source: 'audio/Womanhood_2.mp3'),
            MediaMetadata(
                title: 'Relationship 1',
                presenter: 'Admas Getachew',
                source: 'audio/Relationship_1.mp3'),
            MediaMetadata(
                title: 'Relationship 2',
                presenter: 'Admas Getachew',
                source: 'audio/Relationship_2.mp3'),
            MediaMetadata(
                title: 'Relationship 3 - ማንን ላግባ?',
                presenter: 'Admas Getachew',
                source: 'audio/Relationship_3.mp3'),
            MediaMetadata(
                title: 'Relationship 4 - በምን እንመዝን?',
                presenter: 'Admas Getachew',
                source: 'audio/Relationship_4.mp3'),
            MediaMetadata(
                title: 'Relationship 5 - ተጨማሪ ምክሮች',
                presenter: 'Admas Getachew',
                source: 'audio/Relationship_5.mp3'),
            MediaMetadata(
                title: 'Relationship 6',
                presenter: 'Admas Getachew',
                source: 'audio/Relationship_6.mp3')
          ]),
      Topic(
          title: 'Book of Hosea',
          viewCount: 6000,
          likeCount: 1000,
          backgroundImageUrl:
              "https://i0.wp.com/www.cruciformcoc.com/wp-content/uploads/2020/08/Hosea.jpg?resize=400%2C400&ssl=1",
          threads: contentController.threads),
      Topic(
          title: 'Book of Amos',
          viewCount: 0,
          likeCount: 10000,
          backgroundImageUrl:
              "https://media.bible.art/ab12395e-bca0-4498-96e9-6669a321bd63-compressed.jpg",
          threads: contentController.threads),
      Topic(
          title: 'Book of Zephanniah',
          viewCount: 200000,
          likeCount: 0,
          backgroundImageUrl:
              "https://media.bible.art/af6dd47b-bffc-4f30-804d-f087f3ba51ce-compressed.jpg",
          threads: contentController.threads)
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
