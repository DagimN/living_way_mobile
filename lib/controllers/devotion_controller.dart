import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'bible_controller.dart';

class DevotionController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final TextEditingController commentBoxTextEditingController =
      TextEditingController();
  final _devotionCache = DevotionCache();

  List<Devotion> devotionalList = [];
  Map<String, DevotionItem> _devotionalItemsByDate = {};
  List<Topic> topicList = [];
  int pageIndex = 0;
  bool isFetching = false;
  bool hasReachedEnd = false;
  SortOptions sortOption = SortOptions.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];
  ValueNotifier<GlobalKey?> commentingThreadKeyNotifier = ValueNotifier(null);

  DevotionItem? getItemForDate(DateTime date) {
    return _devotionalItemsByDate[formatDateKey(date)];
  }

  DevotionController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >
              (scrollController.position.maxScrollExtent * .7) &&
          !hasReachedEnd) {
        fetchTopics();
      }
    });

    init();
  }

  Future<void> init() async {
    await _devotionCache.init();
    devotionalList = _devotionCache.getAll();
    mapDevotionalItems(devotionalList);
    fetchTopics();
  }

  Future<void> fetchTopics({bool isRefreshing = false}) async {
    if (isFetching) return;

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      isFetching = true;
      if (isRefreshing) {
        pageIndex = 0;
        hasReachedEnd = false;
        topicList.clear();
      }
      notifyListeners();

      final response = await dio.get('$url/api/v1/content/devotion',
          queryParameters: populateQuery());
      final youtubeResult = await YouTubeService().fetchAllChannelVideos();

      if (!response.statusCode.isSuccess) return;

      final topicData = response.data['topics'] as List;
      final devotionalsData = response.data['devotionals'] as List;

      List<Topic> topicsResult =
          topicData.map((json) => Topic.fromJson(json)).toList();
      List<Devotion> devotionalsResult =
          devotionalsData.map((json) => Devotion.fromJson(json)).toList();

      topicList.addAll(topicsResult);
      topicList.addAll(youtubeResult);
      devotionalList =
          devotionalsResult.isNotEmpty ? devotionalsResult : devotionalList;
      _devotionalItemsByDate.clear();

      mapDevotionalItems(devotionalsResult);

      pageIndex++;
      hasReachedEnd = topicsResult.isEmpty;
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 1), () {
        isFetching = false;
        notifyListeners();
      });

      if (devotionalList.isNotEmpty) {
        _devotionCache.clear();
      }

      for (final devotion in devotionalList) {
        await _devotionCache.save(devotion);
      }

      topicList.sort(
          (topicA, topicB) => topicB.timestamp.compareTo(topicA.timestamp));
      fetchDownloadedFiles();
    }
  }

  Map<String, dynamic> populateQuery() {
    final filters = <String>[];
    final queryParameters = {"page": pageIndex, "sort": sortOption.name};

    if (categoryFilter != CategoryFilter.all) {
      filters.add(categoryFilter.name);
    }

    filters.addAll(booksFiltered);

    if (filters.isNotEmpty) {
      queryParameters.addEntries([MapEntry('filters', filters)]);
    }

    return queryParameters;
  }

  Future<void> updateTopic(Topic updatedTopic) async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.put('$url/api/v1/content/devotion/edit',
          data: {"id": updatedTopic.id, "data": updatedTopic.toJson()});

      if (!response.statusCode.isSuccess) return;

      final index = topicList.indexWhere((t) => t.id == updatedTopic.id);

      if (index != -1) topicList[index] = updatedTopic;

      notifyListeners();
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
    }
  }

  Future<void> fetchDownloadedFiles() async {
    for (final topic
        in topicList.where((topic) => topic.type == TopicType.audio)) {
      for (final content in topic.playlist) {
        final fileName = "${content.title}.${content.fileType?.name}";
        final path = await getFilePath(fileName);

        if (path == null) continue;

        content.file = File(path);
        content.filePath = path;
        content.notify();
      }
    }
  }

  void mapDevotionalItems(List<Devotion> result) {
    final itemsByDate = <String, DevotionItem>{};

    final context = UIService.navigatorKey.currentContext;
    BibleController? bibleController;

    if (context != null) {
      bibleController =
          // ignore: use_build_context_synchronously
          Provider.of<BibleController>(context, listen: false);
    }

    for (final devotion in result) {
      for (final item in devotion.items) {
        itemsByDate.putIfAbsent(
          formatDateKey(item.assignedDate),
          () => item,
        );

        item.passage.book = bibleController != null
            ? bibleController.bible[item.passage.book.index]
            : Book.empty();
        NotificationService.scheduleNotification(
            id: NotificationCodes.devotions
                .extendedCode(item.assignedDate.dateInNumbers),
            title: "Today's devotion - ${item.title}",
            body: item.subTitle,
            scheduledDate: item.assignedDate,
            payload: 'devotion');
      }
    }
    _devotionalItemsByDate = itemsByDate;
    notifyListeners();
  }

  set setSortOption(SortOptions v) {
    sortOption = v;
    fetchTopics(isRefreshing: true);
  }

  set setCategoryFilter(CategoryFilter v) {
    categoryFilter = v;
    fetchTopics(isRefreshing: true);
  }

  set setBooksFilter(List<String> books) {
    booksFiltered = books;
    notifyListeners();
  }

  set setCommentingThreadKey(GlobalKey? value) {
    commentingThreadKeyNotifier.value = value;
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
