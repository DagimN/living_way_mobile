import 'package:hive/hive.dart';

import '../../services/hive_service.dart';
import 'index.dart';

class StoryCache extends HiveService<Story> {
  StoryCache() : super(boxName: 'stories');

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(StoryAdapter().typeId)) {
      Hive.registerAdapter(StoryAdapter());
    }
  }

  List<Story> getByDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return getWhere(
      (story) =>
          !story.timestamp.isBefore(start) && !story.timestamp.isAfter(end),
    )..sort((storyA, storyB) => storyB.timestamp.compareTo(storyA.timestamp));
  }

  List<Story> getAllSorted() {
    return getAll()
      ..sort((storyA, storyB) => storyB.timestamp.compareTo(storyA.timestamp));
  }

  Future<int> purgeOlderThan(Duration age) async {
    final cutoff = DateTime.now().subtract(age);
    final staleKeys = getWhere((story) => story.timestamp.isBefore(cutoff))
        .map((n) => n.cacheKey)
        .toList();

    if (staleKeys.isEmpty) return 0;

    await deleteAll(staleKeys);
    return staleKeys.length;
  }
}
