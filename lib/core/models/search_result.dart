import 'activity/index.dart';
import 'passage.dart';

enum SearchResultType { bible, activity, youtube }

sealed class SearchResult {
  final SearchResultType type;
  final String id;
  final String title;
  final String? subtitle;

  const SearchResult({
    required this.type,
    required this.id,
    required this.title,
    this.subtitle,
  });
}

class BibleSearchResult extends SearchResult {
  final Passage passage;

  BibleSearchResult({required this.passage})
      : super(
          type: SearchResultType.bible,
          id: '${passage.book.name}-${passage.chapter}-${passage.verse}',
          title: '${passage.book.name} ${passage.chapter}:${passage.verse}',
          subtitle: passage.text,
        );
}

class ActivitySearchResult extends SearchResult {
  final Activity activity;
  final String? imageUrl;

  ActivitySearchResult({
    required this.activity,
    required super.title,
    this.imageUrl,
  }) : super(
          type: SearchResultType.activity,
          id: activity.id,
          subtitle: activity.body,
        );
}

class YoutubeSearchResult extends SearchResult {
  final String videoId;
  final String? thumbnailUrl;

  YoutubeSearchResult({
    required this.videoId,
    required super.title,
    this.thumbnailUrl,
  }) : super(
          type: SearchResultType.youtube,
          id: videoId,
        );
}
