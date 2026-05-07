import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:living_way/core/constants/urls.dart';
import 'package:living_way/core/enums.dart';
import 'package:living_way/core/models/topic.dart';
import 'package:living_way/core/services/logging_service.dart';

class DevotionController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final TextEditingController commentBoxTextEditingController =
      TextEditingController();

  List<Topic> topicList = [];
  int pageIndex = 0;
  bool isFetching = false;
  bool hasReachedEnd = false;
  SortOptions sortOption = SortOptions.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];
  ValueNotifier<GlobalKey?> commentingThreadKeyNotifier = ValueNotifier(null);

  DevotionController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >
              (scrollController.position.maxScrollExtent * .7) &&
          !hasReachedEnd) {
        fetchTopics();
      }
    });
    fetchTopics();
  }

  Future<void> fetchTopics({bool isRefreshing = false}) async {
    if (isFetching) return;

    final dio = Dio();
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

      if (!response.statusCode.isSuccess) return;

      final result =
          (response.data as List).map((json) => Topic.fromJson(json)).toList();

      topicList.addAll(result);
      pageIndex++;
      hasReachedEnd = result.isEmpty;
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 1), () {
        isFetching = false;
        notifyListeners();
      });
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
    final dio = Dio();
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
