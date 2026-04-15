import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/core/constants/content.dart' as content;
import 'package:living_way/core/core.dart';

class ContentController extends ChangeNotifier {
  List<String> images = [Urls.imageApiUrl];
  List<String> stories = ['1', '2', '3', '4', '5', '6'];
  List<String> viewedStories = [];
  List<Staff> staffs = [
    Staff(
        name: 'Admas Getachew',
        position: 'Pastor',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FAdmas_9d5634fa95.jpg&w=1920&q=100"),
    Staff(
        name: 'Keneaa Zekarias',
        position: 'Pastor',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2F08_j1_9b017be72c.jpg&w=1920&q=100"),
    Staff(
        name: 'Henock Bekele',
        position: 'Pastor',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2Fhenock_01_be02bb6828.jpg&w=1920&q=100"),
    Staff(
        name: 'Elias Seyoum',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2Felias_seyoum_01_9b2c436491.jpg&w=1920&q=100"),
    Staff(
        name: 'Herani Sahlu',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FHerani_ac8d4aa110.jpg&w=1920&q=100"),
    Staff(
        name: 'Burakie Sahle',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FBurakae_7ad25f53fa.jpg&w=1920&q=100"),
    Staff(
        name: 'Halleluya Fikre',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FHalle_ce5a7ff718.jpg&w=1920&q=100"),
    Staff(
        name: 'Misikir Genene',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FMesikir_068861e0d3.jpg&w=1920&q=100"),
    Staff(
        name: 'Henock Mesfin',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2Fhenock_misfin_01_37108eac59.jpg&w=1920&q=100")
  ];
  List<String> aspirations = [
    "Centered in Christ",
    "Focused on evangelism",
    "Driven by disciple-making",
    "Suitable for community life to flourish",
    "Friendly to newcomers",
    "A place where believers grow in to maturity",
    "Broad in ministry, so that believers able to exercise their gift",
    "Live out the Gospel practically"
  ];
  List<Contacts> contacts = [
    Contacts(
        title: 'Phone Numbers',
        addressList: ['+251901777774', '+251901777775'],
        type: ContactType.phone),
    Contacts(
        title: 'Email Address',
        addressList: [
          'Info@livingwayethiopia.org',
          'livingwayethiopia@gmail.com'
        ],
        type: ContactType.email),
    Contacts(
        title: "Address",
        addressList: [
          "https://www.google.com/maps/place/Living+Way+Church,+Addis+Ababa,+Ethiopia/@9.0089674,38.7593991,17z/data=!3m1!4b1!4m6!3m5!1s0x164b85f25d21998b:0xbd3d2162cc867442!8m2!3d9.0089621!4d38.761974!16s%2Fg%2F11r9tz5ls6?entry=ttu"
        ],
        type: ContactType.location),
    Contacts(
        title: "Social Media",
        addressList: [
          'https://twitter.com/livingwayethiop',
          "https://www.facebook.com/LivingWayChurch1",
          "https://www.instagram.com/livingway_church",
          "https://www.youtube.com/channel/UC7QcE6EYm7PCQjN3fVlRoXg"
        ],
        type: ContactType.social)
  ];

  SortOptions threadActivityFilter = SortOptions.latest;
  List<ThreadData> threads = content.threads;

  bool isFetchingStories = true; //FIXME: Revert back to original

  ContentController() {
    _init();
    //TODO: Fetch content from cache if can't access the server

    //TODO: Clean up files which are not being used (translations)
  }

  Future<void> _init() async {
    viewedStories = await CacheService.instance
        .readData<List<String>>('viewedStories', defaultValue: []);
    images = await CacheService.instance
        .readData<List<String>>('images', defaultValue: []);
    final lastImagesFetched = DateTime.parse(await CacheService.instance
        .readData<String>('lastImagesFetched',
            defaultValue: DateTime.now().toString()));

    if (images.isEmpty ||
        DateTime.now().difference(lastImagesFetched).inDays > 7) {
      images = await ImageService.fetchImages(page: Random(15).toString());
      await CacheService.instance.writeData<List<String>>('images', images);
      await CacheService.instance
          .writeData<String>('lastImagesFetched', DateTime.now().toString());
    }

    notifyListeners();
  }

  void viewStory(String storyId) {
    if (!viewedStories.contains(storyId)) {
      viewedStories.add(storyId);

      CacheService.instance
          .writeData<List<String>>('viewedStories', viewedStories);

      notifyListeners();
    }
  }

  set setThreadFilter(SortOptions value) {
    threadActivityFilter = value;
    notifyListeners();
  }
}
