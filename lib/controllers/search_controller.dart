import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';

class SearchController extends ChangeNotifier {
  SearchController();

  final List<SearchResult> results = [];
  final Map<SearchResultType, String?> sourceErrors = {};
  bool isSearching = false;

  StreamSubscription<SearchResult>? _subscription;
  Timer? _debounce;

  List<BibleSearchResult> get bibleResults =>
      results.whereType<BibleSearchResult>().toList();
  List<ActivitySearchResult> get activityResults =>
      results.whereType<ActivitySearchResult>().toList();
  List<YoutubeSearchResult> get youtubeResults =>
      results.whereType<YoutubeSearchResult>().toList();

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => search(query),
    );
  }

  Future<void> search(String query) async {
    AnalyticsService.logEvent('search_performed', parameters: {'query': query});

    _debounce?.cancel();
    await _subscription?.cancel();

    results.clear();
    sourceErrors.clear();
    final trimmed = query.trim();
    isSearching = trimmed.isNotEmpty;
    notifyListeners();

    if (trimmed.isEmpty) return;

    final merged = StreamGroup.merge<SearchResult>([
      _guarded(BibleController.search(trimmed), SearchResultType.bible),
      _guarded(ActivityController.search(trimmed), SearchResultType.activity),
      _guarded(YouTubeService().search(trimmed), SearchResultType.youtube),
    ]);

    _subscription = merged.listen(
      (result) {
        results.add(result);
        notifyListeners();
      },
      onDone: () {
        isSearching = false;
        notifyListeners();
      },
    );
  }

  void clear() {
    _debounce?.cancel();
    _subscription?.cancel();
    results.clear();
    sourceErrors.clear();
    isSearching = false;
    notifyListeners();
  }

  /// Wraps a single source's stream so an error there doesn't cancel the
  /// merged stream or the other two sources (StreamGroup.merge would
  /// otherwise propagate a single source's error and shut everything down).
  Stream<SearchResult> _guarded(
    Stream<SearchResult> source,
    SearchResultType type,
  ) {
    final controller = StreamController<SearchResult>();
    source.listen(
      controller.add,
      onError: (Object e, StackTrace st) {
        logger.e('Error in $type search stream: $e');
        sourceErrors[type] = e.toString();
        notifyListeners();
      },
      onDone: controller.close,
      cancelOnError: false,
    );
    return controller.stream;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
