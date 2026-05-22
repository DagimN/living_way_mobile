import 'package:hive/hive.dart';

import '../../services/hive_service.dart';
import 'index.dart';

class NotificationCache extends HiveService<Notification> {
  NotificationCache() : super(boxName: 'notifications');

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(NotificationAdapter().typeId)) {
      Hive.registerAdapter(NotificationAdapter());
    }
  }

  List<Notification> getByDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return getWhere(
      (notification) =>
          !notification.createdAt.isBefore(start) &&
          !notification.createdAt.isAfter(end),
    )..sort((notificationA, notificationB) =>
        notificationB.createdAt.compareTo(notificationA.createdAt));
  }

  List<Notification> getAllSorted() {
    return getAll()
      ..sort((notificationA, notificationB) =>
          notificationB.createdAt.compareTo(notificationA.createdAt));
  }

  List<Notification> search(String query) {
    final lower = query.toLowerCase();
    return getWhere(
      (n) =>
          n.title.toLowerCase().contains(lower) ||
          n.body.toLowerCase().contains(lower),
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<int> purgeOlderThan(Duration age) async {
    final cutoff = DateTime.now().subtract(age);
    final staleKeys =
        getWhere((notification) => notification.createdAt.isBefore(cutoff))
            .map((n) => n.cacheKey)
            .toList();

    if (staleKeys.isEmpty) return 0;

    await deleteAll(staleKeys);
    return staleKeys.length;
  }
}
