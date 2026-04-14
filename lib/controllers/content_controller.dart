import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/constants/content.dart' as content;
import 'package:living_way/constants/urls.dart';
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/models/book.dart';
import 'package:living_way/models/contacts.dart';
import 'package:living_way/models/staff.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/models/translation.dart';
import 'package:living_way/services/logging_service.dart';
import 'package:living_way/utils/storage_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentController extends ChangeNotifier {
  final TextEditingController commentBoxTextEditingController =
      TextEditingController();
  final ScrollController activityScrollController = ScrollController();
  final ScrollController topicScrollController = ScrollController();
  List<Book> bible = [];
  List<Translation> translations = [
    Translation(
        name: "KJV",
        status: TranslationStatus.available,
        path: 'assets/data/en_kjv.json',
        isDefault: true),
    Translation(
        name: "NASB",
        status: TranslationStatus.available,
        path: 'assets/data/am_nasb.json',
        isDefault: true)
  ];
  List<ActivityContent> activityList = [];
  List<Topic> topicList = [];
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

  Book? book;
  int? chapter;
  int? verse;
  Translation? translation;
  SharedPreferences? sharedPreferences;

  ActivityFilter topicActivityFilter = ActivityFilter.latest;
  ActivityFilter threadActivityFilter = ActivityFilter.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];
  List<ThreadData> threads = content.threads;
  ValueNotifier<GlobalKey?> commentingThreadKeyNotifier = ValueNotifier(null);

  int activityPageIndex = 0;
  int topicPageIndex = 0;
  bool isFetchingActivity = false;
  bool isFetchingTopic = false;
  bool isFetchingStories = true; //FIXME: Revert back to original

  ContentController() {
    loadTranslation(translations.first,
        isDefault: translations.first.isDefault);

    SharedPreferences.getInstance().then((instance) {
      sharedPreferences = instance;

      populateTranslationList(
          (json.decode(instance.getString('translations') ?? "[]") as List)
              .map((translation) => Translation.fromMap(translation))
              .toList());

      viewedStories = instance.getStringList('viewedStories') ?? [];

      notifyListeners();

      fetchTranslations();
    });
    //TODO: Fetch content from cache if can't access the server
    activityScrollController.addListener(activityScrollListener);
    topicScrollController.addListener(topicScrollListener);

    //TODO: Clean up files which are not being used (translations)
    fetchActivities();
    fetchTopics();
  }

  void activityScrollListener() {
    if (activityScrollController.position.pixels >
        (activityScrollController.position.maxScrollExtent * .7)) {
      //TODO: Add condition for stop fetching when there is no longer any items left
      fetchActivities();
    }
  }

  void topicScrollListener() {
    if (topicScrollController.position.pixels >
        (topicScrollController.position.maxScrollExtent * .7)) {
      //TODO: Add condition for stop fetching when there is no longer any items left
      fetchTopics();
    }
  }

  Future<void> fetchActivities({bool isRefreshing = false}) async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      isFetchingActivity = true;
      if (isRefreshing) {
        activityPageIndex = 0;
        activityList.clear();
      }
      notifyListeners();

      final response = await dio.get('$url/api/v1/content/activity',
          queryParameters: {"page": activityPageIndex});

      if (response.statusCode != 200) return;

      final result = (response.data as List)
          .map((json) => ActivityContent.fromJson(json))
          .toList();

      activityList.addAll(result);
      activityPageIndex++;

      notifyListeners();
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 3), () {
        isFetchingActivity = false;
        notifyListeners();
      });
    }
  }

  Future<void> fetchTopics({bool isRefreshing = false}) async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      isFetchingTopic = true;
      if (isRefreshing) {
        topicPageIndex = 0;
        topicList.clear();
      }
      notifyListeners();

      final response = await dio.get('$url/api/v1/content/devotion',
          queryParameters: populateQuery());

      if (response.statusCode != 200) return;

      final result =
          (response.data as List).map((json) => Topic.fromJson(json)).toList();

      topicList.addAll(result);
      topicPageIndex++;

      notifyListeners();
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 3), () {
        isFetchingTopic = false;
        notifyListeners();
      });
    }
  }

  Future<void> updateTopic(Topic updatedTopic) async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.put('$url/api/v1/content/devotion/edit',
          data: {"id": updatedTopic.id, "data": updatedTopic.toJson()});

      if (response.statusCode != 200) return;

      notifyListeners();
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
      isFetchingTopic = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> populateQuery() {
    final filters = <String>[];
    final queryParameters = {
      "page": topicPageIndex,
      "sort": topicActivityFilter.name
    };

    if (categoryFilter != CategoryFilter.all) {
      filters.add(categoryFilter.name);
    }

    filters.addAll(booksFiltered);

    if (filters.isNotEmpty) {
      queryParameters.addEntries([MapEntry('filters', filters)]);
    }

    return queryParameters;
  }

  Future<bool> updatePoll(ActivityContent poll) async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;
    try {
      final response = await dio.put('$url/api/v1/content/activity/edit',
          data: {"id": poll.id, "data": poll.toMap()});

      return response.statusCode == 200;
    } catch (error) {
      logger.e(error);
      return false;
    } finally {
      dio.close();
    }
  }

  Future<void> fetchTranslations() async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;
    try {
      final response = await dio.get('$url/api/v1/content/bible');

      populateTranslationList((response.data['translations'] as List)
          .map((translation) => Translation.fromMap(translation))
          .toList());

      notifyListeners();
      sharedPreferences?.setString(
          'translations',
          json.encode(
              translations.map((translation) => translation.toMap()).toList()));
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
    }
  }

  void populateTranslationList(List<Translation> incomingTranslations) {
    for (final incomingTranslation in incomingTranslations) {
      final index = translations.indexWhere((loadedTranslation) =>
          loadedTranslation.name == incomingTranslation.name);

      if (index != -1 &&
          translations[index].status != TranslationStatus.available) {
        translations.replaceRange(index, index + 1, [incomingTranslation]);
      }

      if (index == -1) {
        translations.add(incomingTranslation);
      }
    }
  }

  Future<void> downloadTranslation(String name) async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;
    try {
      final response = await dio
          .get('$url/api/v1/content/bible', queryParameters: {"name": name});
      final index =
          translations.indexWhere((translation) => translation.name == name);
      final filePath =
          await writeFile('$name.json', json.encode(response.data));
      final updatedTranslation = Translation(
          name: name, path: filePath, status: TranslationStatus.available);

      translation = updatedTranslation;
      translations[index] = updatedTranslation;

      notifyListeners();

      loadTranslation(updatedTranslation,
          isDefault: updatedTranslation.isDefault);

      sharedPreferences?.setString(
          'translations',
          json.encode(
              translations.map((translation) => translation.toMap()).toList()));
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
    }
  }

  Future<void> loadTranslation(Translation translation,
      {bool isDefault = false}) async {
    List data = [];
    if (isDefault) {
      data = await loadJson(translation.path!);
    } else {
      data = json.decode((await readFile(translation.path ?? "")) ?? "[]");
    }

    bible = data
        .map((e) => Book(
            name: e['name'],
            chapters: (e['chapters'] as List)
                .map((chapter) =>
                    (chapter as List).map((verse) => verse.toString()).toList())
                .toList()))
        .toList();

    notifyListeners();
  }

  void viewStory(String storyId) {
    if (!viewedStories.contains(storyId)) {
      viewedStories.add(storyId);

      sharedPreferences?.setStringList('viewedStories', viewedStories);

      notifyListeners();
    }
  }

  set setActivityFilter(ActivityFilter value) {
    topicActivityFilter = value;
    notifyListeners();
  }

  set setThreadFilter(ActivityFilter value) {
    threadActivityFilter = value;
    notifyListeners();
  }

  set setCategoryFilter(CategoryFilter value) {
    categoryFilter = value;
    notifyListeners();
  }

  set setBooksFilter(List<String> books) {
    booksFiltered = books;
    notifyListeners();
  }

  set setCommentingThreadKey(GlobalKey? value) {
    commentingThreadKeyNotifier.value = value;
    notifyListeners();
  }

  set setTranslation(Translation value) {
    translation = value;
    notifyListeners();

    loadTranslation(value, isDefault: value.isDefault);
  }

  set setBook(Book value) {
    book = value;
    notifyListeners();
  }

  set setChapter(int? value) {
    chapter = value;
    notifyListeners();
  }

  set setVerse(int? value) {
    verse = value;
    notifyListeners();
  }
}

enum ActivityFilter { mostActive, mostLiked, mostViewed, latest }

enum CategoryFilter { all, ot, nt }
