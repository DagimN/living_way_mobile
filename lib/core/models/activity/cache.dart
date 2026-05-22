import 'package:hive/hive.dart';

import '../../services/hive_service.dart';
import 'index.dart';

class ActivityCache extends HiveService<Activity> {
  ActivityCache() : super(boxName: 'activities');

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(ActivityAdapter().typeId)) {
      Hive.registerAdapter(ActivityAdapter());
    }

    if (!Hive.isAdapterRegistered(ContentBannerAdapter().typeId)) {
      Hive.registerAdapter(ContentBannerAdapter());
    }

    if (!Hive.isAdapterRegistered(PollOptionsAdapter().typeId)) {
      Hive.registerAdapter(PollOptionsAdapter());
    }

    if (!Hive.isAdapterRegistered(ContentTypeAdapter().typeId)) {
      Hive.registerAdapter(ContentTypeAdapter());
    }
  }

  List<Activity> getByDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return getWhere(
      (activity) =>
          !(activity.upcomingDate ?? activity.timestamp).isBefore(start) &&
          !(activity.upcomingDate ?? activity.timestamp).isAfter(end),
    )..sort((activityA, activityB) =>
        (activityB.upcomingDate ?? activityB.timestamp)
            .compareTo((activityA.upcomingDate ?? activityA.timestamp)));
  }

  List<Activity> getAllSorted() {
    return getAll()
      ..sort((activityA, activityB) =>
          (activityB.upcomingDate ?? activityB.timestamp)
              .compareTo((activityA.upcomingDate ?? activityA.timestamp)));
  }

  Future<int> purgeOlderThan(Duration age) async {
    final cutoff = DateTime.now().subtract(age);
    final staleKeys = getWhere((activity) =>
            (activity.upcomingDate ?? activity.timestamp).isBefore(cutoff))
        .map((n) => n.cacheKey)
        .toList();

    if (staleKeys.isEmpty) return 0;

    await deleteAll(staleKeys);
    return staleKeys.length;
  }
}
