import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/core/extensions/datetime.dart';

class ActivityController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final _activityCache = ActivityCache();
  List<Activity> activityList = [];
  int pageIndex = 0;
  bool isFetching = false;
  bool hasReachedEnd = false;

  ActivityController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >
              (scrollController.position.maxScrollExtent * .7) &&
          !hasReachedEnd) {
        fetchActivities();
      }
    });

    _init();
  }

  Future<void> _init() async {
    await _activityCache.init();
    activityList = _activityCache.getAllSorted();
    _sortActivities();
    fetchActivities();
  }

  Future<void> fetchActivities({bool isRefreshing = false}) async {
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
        activityList.clear();
      }

      notifyListeners();

      final response = await dio.get('$url/api/v1/content/activity',
          queryParameters: {"page": pageIndex});

      if (!response.statusCode.isSuccess) return;

      final result = (response.data as List)
          .map((json) => Activity.fromJson(json))
          .toList();

      activityList.addOrReplaceAll(result, (oldActivity, newActivity) {
        return oldActivity.id == newActivity.id;
      });
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

      scheduleActivityNotifications();
      _sortActivities();
      for (final activity in activityList) {
        await _activityCache.save(activity);
      }
    }
  }

  Future<bool> updatePoll(Activity poll) async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.put('$url/api/v1/content/activity/edit',
          data: {"id": poll.id, "data": poll.toMap()});
      AnalyticsService.logEvent('poll_updated',
          parameters: {'poll_id': poll.id});
      return response.statusCode.isSuccess;
    } catch (e) {
      logger.e(e);
      return false;
    } finally {
      dio.close();
    }
  }

  Future<void> scheduleActivityNotifications() async {
    final events = activityList.where((activity) =>
        activity.type == ContentType.event &&
        (activity.upcomingDate ?? activity.timestamp).isAfter(DateTime.now()));

    for (final activity in events) {
      final upcomingDate = activity.upcomingDate;

      if (upcomingDate != null) {
        final scheduledDateInHours =
            upcomingDate.subtract(const Duration(hours: 1));
        final hourNotificationId = NotificationCodes.activity
            .extendedCode(scheduledDateInHours.dateInNumbers);
        final scheduledDateInDays =
            upcomingDate.subtract(const Duration(days: 1));
        final dayNotificationId = NotificationCodes.activity
            .extendedCode(scheduledDateInDays.dateInNumbers);

        await NotificationService.cancelNotification(hourNotificationId);
        await NotificationService.cancelNotification(dayNotificationId);
        await NotificationService.scheduleNotification(
            id: hourNotificationId,
            title: activity.title,
            body: activity.body,
            imageUrl: activity.banner?.url,
            scheduledDate: scheduledDateInHours);
        await NotificationService.scheduleNotification(
            id: dayNotificationId,
            title: activity.title,
            body: activity.body,
            imageUrl: activity.banner?.url,
            scheduledDate: scheduledDateInDays);
      }

      if (activity.isRecurring) {
        final scheduledDateInHours =
            activity.timestamp.subtract(const Duration(hours: 1));
        final hourNotificationId = NotificationCodes.activity
            .extendedCode(scheduledDateInHours.dateInNumbers);
        final scheduledDateInDays =
            activity.timestamp.subtract(const Duration(days: 1));
        final dayNotificationId = NotificationCodes.activity
            .extendedCode(scheduledDateInDays.dateInNumbers);

        await NotificationService.cancelNotification(hourNotificationId);
        await NotificationService.cancelNotification(dayNotificationId);
        await NotificationService.scheduleNotification(
            id: hourNotificationId,
            title: activity.title,
            body: activity.body,
            imageUrl: activity.banner?.url,
            scheduledDate: scheduledDateInHours);
        await NotificationService.scheduleNotification(
            id: dayNotificationId,
            title: activity.title,
            body: activity.body,
            imageUrl: activity.banner?.url,
            scheduledDate: scheduledDateInDays);
      }
    }
  }

  void _sortActivities() {
    activityList.sort((activityA, activityB) =>
        (activityB.upcomingDate ?? activityB.timestamp)
            .compareTo((activityA.upcomingDate ?? activityA.timestamp)));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
