import 'dart:async';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';

class SearchController extends ChangeNotifier {
  final TextEditingController textFieldController = TextEditingController();
  final ScrollController mediaSearchVerticalScrollController =
      ScrollController();
  final ScrollController mediaSearchHorizontalScrollController =
      ScrollController();
  final ScrollController activitiesSearchScrollController = ScrollController();
  final ScrollController activitiesSearchMiniScrollController =
      ScrollController();

  SearchController() {
    mediaSearchVerticalScrollController
        .addListener(mediaSearchVerticalScrollListener);
    mediaSearchHorizontalScrollController
        .addListener(mediaSearchHorizontalScrollListener);

    activitiesSearchScrollController
        .addListener(activitiesSearchScrollListener);
    activitiesSearchMiniScrollController
        .addListener(activitiesSearchMiniScrollListener);
  }

  final List<SearchResult> results = [];
  final Map<SearchResultType, String?> sourceErrors = {};

  bool isSearchingActivities = false;
  bool isSearchingMedia = false;
  bool isSearchingBible = false;
  bool mediaHasReachedEnd = false;
  bool activitiesHasReachedEnd = false;
  int activityResultsPage = 0;

  String? youtubePageToken;
  StreamSubscription<SearchResult>? _subscription;
  Timer? _debounce;

  List<BibleSearchResult> get bibleResults =>
      results.whereType<BibleSearchResult>().toList();
  List<ActivitySearchResult> get activityResults =>
      results.whereType<ActivitySearchResult>().toList();
  List<YoutubeSearchResult> get youtubeResults =>
      results.whereType<YoutubeSearchResult>().toList();

  void mediaSearchVerticalScrollListener() async {
    if (mediaSearchVerticalScrollController.position.pixels >
            (mediaSearchVerticalScrollController.position.maxScrollExtent *
                .7) &&
        !mediaHasReachedEnd &&
        !isSearchingMedia) {
      isSearchingMedia = true;
      notifyListeners();

      final result = await YouTubeService()
          .search(textFieldController.text, pageToken: youtubePageToken);

      final items = result['items'] as List<YoutubeSearchResult>;
      results.addOrReplaceAll(
          items, (existingMedia, newMedia) => existingMedia.id == newMedia.id);
      youtubePageToken = result['pageToken'];
      mediaHasReachedEnd = items.isEmpty;
      isSearchingMedia = false;
      notifyListeners();
    }
  }

  void mediaSearchHorizontalScrollListener() async {
    if (mediaSearchHorizontalScrollController.position.pixels >
            (mediaSearchHorizontalScrollController.position.maxScrollExtent *
                .7) &&
        !mediaHasReachedEnd &&
        !isSearchingMedia) {
      isSearchingMedia = true;
      notifyListeners();

      final result = await YouTubeService()
          .search(textFieldController.text, pageToken: youtubePageToken);

      final items = result['items'] as List<YoutubeSearchResult>;
      results.addOrReplaceAll(
          items, (existingMedia, newMedia) => existingMedia.id == newMedia.id);
      youtubePageToken = result['pageToken'];
      mediaHasReachedEnd = items.isEmpty;
      isSearchingMedia = false;
      notifyListeners();
    }
  }

  void activitiesSearchScrollListener() async {
    if (activitiesSearchScrollController.position.pixels >
            (activitiesSearchScrollController.position.maxScrollExtent * .7) &&
        !activitiesHasReachedEnd &&
        !isSearchingActivities) {
      isSearchingActivities = true;
      notifyListeners();

      final result = await ActivityController.search(textFieldController.text,
          page: activityResultsPage);

      results.addAll(result);
      ++activityResultsPage;
      activitiesHasReachedEnd = result.isEmpty;
      isSearchingActivities = false;
      notifyListeners();
    }
  }

  void activitiesSearchMiniScrollListener() async {
    if (activitiesSearchMiniScrollController.position.pixels >
            (activitiesSearchMiniScrollController.position.maxScrollExtent *
                .7) &&
        !activitiesHasReachedEnd &&
        !isSearchingActivities) {
      isSearchingActivities = true;
      notifyListeners();

      final result = await ActivityController.search(textFieldController.text,
          page: activityResultsPage);

      results.addAll(result);
      ++activityResultsPage;
      activitiesHasReachedEnd = result.isEmpty;
      isSearchingActivities = false;
      notifyListeners();
    }
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 1350),
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
    isSearchingActivities = trimmed.isNotEmpty;
    isSearchingMedia = trimmed.isNotEmpty;
    isSearchingBible = trimmed.isNotEmpty;
    notifyListeners();

    if (trimmed.isEmpty) return;

    _subscription =
        _guarded(BibleController.search(trimmed), SearchResultType.bible)
            .listen(
      (result) {
        results.add(result);
        notifyListeners();
      },
      onDone: () {
        isSearchingBible = false;
        notifyListeners();
      },
    );

    ActivityController.search(query).then((activityResults) {
      results.addAll(activityResults);
      ++activityResultsPage;
      isSearchingActivities = false;

      notifyListeners();
    });

    YouTubeService().search(query).then((mediaResults) {
      final items = mediaResults['items'] as List<YoutubeSearchResult>;

      results.addAll(items);
      youtubePageToken = mediaResults["pageToken"];
      isSearchingMedia = false;

      notifyListeners();
    });
  }

  void clear() {
    _debounce?.cancel();
    _subscription?.cancel();
    results.clear();
    sourceErrors.clear();
    isSearchingActivities = false;
    isSearchingMedia = false;
    isSearchingBible = false;
    textFieldController.clear();
    notifyListeners();
  }

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
