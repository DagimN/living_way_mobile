import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:living_way/core/constants/content.dart' as content;
import 'package:living_way/core/core.dart';
import 'package:pdfrx/pdfrx.dart';

class ContentController extends ChangeNotifier {
  final contentScrollController = ScrollController();

  List<String> images = [Urls.imageApiUrl];
  List<Story> stories = [];
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
  List<Content> library = [];

  SortOptions threadActivityFilter = SortOptions.latest;
  List<ThreadData> threads = content.threads;

  bool isFetchingStories = false;
  bool isFetchingContents = false;

  int contentPageIndex = 1;
  bool contentHasReachedEnd = false;

  ContentController() {
    _init();
    contentScrollController.addListener(() {
      if (contentScrollController.position.pixels >
              (contentScrollController.position.maxScrollExtent * .7) &&
          !contentHasReachedEnd) {
        fetchContents();
      }
    });
    //TODO: Fetch content from cache if can't access the server
  }

  Future<void> _init() async {
    await loadCache();
    await fetchStories();
    await fetchContents();

    cleanResources(
        contentIds: stories.map((story) => story.id).toList(),
        path: '/stories',
        isTemp: true);
    cleanResources(
        contentIds:
            library.map((content) => '${content.id}-pdf-thumbnail').toList(),
        path: '/content',
        isTemp: true);
    cleanResources(
        contentIds: library.map((content) => content.title).toList());
  }

  Future<void> loadCache() async {
    viewedStories = await CacheService.instance
        .readData<List<String>>('viewedStories', defaultValue: []);
    images = await CacheService.instance
        .readData<List<String>>('images', defaultValue: [Urls.imageApiUrl]);

    final cachedLibrary = List.from(await CacheService.instance
        .readData<List<String>>('library', defaultValue: []));
    for (final contentJson in cachedLibrary) {
      final contentMap = jsonDecode(contentJson);

      int contentIndex =
          library.indexWhere((content) => content.id == contentMap['id']);

      if (contentIndex == -1) {
        library.add(Content.fromJson(jsonDecode(contentJson)));
      } else {
        library[contentIndex].updateFromJson(contentMap);
      }
    }

    final lastImagesFetched = DateTime.parse(await CacheService.instance
        .readData<String>('lastImagesFetched',
            defaultValue: DateTime.now().toString()));

    if (images.length == 1 ||
        DateTime.now().difference(lastImagesFetched).inDays > 7) {
      images = await ImageService.fetchImages(page: Random(15).toString());
      await CacheService.instance.writeData<List<String>>('images', images);
      await CacheService.instance
          .writeData<String>('lastImagesFetched', DateTime.now().toString());
    }

    notifyListeners();
  }

  void viewStory(String storyId) async {
    if (!viewedStories.contains(storyId)) {
      viewedStories.add(storyId);

      await CacheService.instance
          .writeData<List<String>>('viewedStories', viewedStories);

      notifyListeners();
    }
  }

  Future<void> fetchStories({bool isRefreshing = false}) async {
    if (isFetchingStories) return;

    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      isFetchingStories = true;
      if (isRefreshing) {
        stories.clear();
      }

      notifyListeners();

      final response = await dio.get(
        '$url/api/v1/content/story',
      );

      if (!response.statusCode.isSuccess) return;

      final result =
          (response.data as List).map((json) => Story.fromJson(json)).toList();

      stories.addAll(result);
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 1), () {
        isFetchingStories = false;
        notifyListeners();
      });

      _sortStories();
    }
  }

  Future<void> fetchContents({bool isRefreshing = false}) async {
    if (isFetchingContents) return;

    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      isFetchingContents = true;
      if (isRefreshing) {
        contentPageIndex = 1;
        contentHasReachedEnd = false;
        library.clear();
      }

      notifyListeners();

      final response = await dio.get('$url/api/v1/content',
          queryParameters: {"page": contentPageIndex});

      if (!response.statusCode.isSuccess) return;

      final result = (response.data as List)
          .map((json) => Content.fromJson(json))
          .toList();

      library.addOrReplaceAll(result, (oldContent, newContent) {
        return oldContent.id == newContent.id;
      });
      contentPageIndex++;
      contentHasReachedEnd = result.isEmpty;
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 1), () {
        isFetchingContents = false;
        notifyListeners();
      });
    }
  }

  Future<void> _sortStories() async {
    for (final item in stories.indexed) {
      final index = item.$1;
      final story = item.$2;

      stories[index].isViewed = viewedStories.contains(story.id);
    }

    stories.sort(
        (storyA, storyB) => storyB.timestamnp.compareTo(storyA.timestamnp));
    stories.sort((_, storyB) => storyB.isViewed ? -1 : 1);

    notifyListeners();
  }

  void saveLibrary(Content pausedContent,
      {PdfViewerController? pdfController}) {
    final currentPageIndex = pdfController?.pageNumber ?? 1;
    final isContentStarted =
        currentPageIndex != 1 && currentPageIndex != pdfController?.pageCount;

    if (isContentStarted) {
      pausedContent.contentRemaining =
          currentPageIndex / (pdfController?.pageCount ?? 1);
      pausedContent.previouslyLeftOn = currentPageIndex;

      library.addOrReplace(
          pausedContent, (content) => content.id == pausedContent.id);
    }

    if (!isContentStarted) {
      final index =
          library.indexWhere((content) => content.id == pausedContent.id);

      if (index == -1) return;

      library[index].contentRemaining = null;
      library[index].previouslyLeftOn = null;
    }

    CacheService.instance.writeData<List<String>>(
        'library',
        library
            .where((content) => content.filePath != null)
            .map((content) => content.toString())
            .toList());

    notifyListeners();
  }

  set setThreadFilter(SortOptions value) {
    threadActivityFilter = value;
    notifyListeners();
  }
}
