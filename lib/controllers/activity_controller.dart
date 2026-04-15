import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:living_way/core/constants/urls.dart';
import 'package:living_way/core/models/activity_content.dart';
import 'package:living_way/core/services/logging_service.dart';

class ActivityController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  List<ActivityContent> activityList = [];
  int pageIndex = 0;
  bool isFetching = false;

  ActivityController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          (scrollController.position.maxScrollExtent * .7)) {
        //TODO: Add condition for stop fetching when there is no longer any items left
        fetchActivities();
      }
    });
    fetchActivities();
  }

  Future<void> fetchActivities({bool isRefreshing = false}) async {
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
        activityList.clear();
      }

      notifyListeners();

      final response = await dio.get('$url/api/v1/content/activity',
          queryParameters: {"page": pageIndex});

      if (!response.statusCode.isSuccess) return;

      final result = (response.data as List)
          .map((json) => ActivityContent.fromJson(json))
          .toList();

      activityList.addAll(result);
      pageIndex++;
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

      return response.statusCode.isSuccess;
    } catch (e) {
      logger.e(e);
      return false;
    } finally {
      dio.close();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
