class ActivityContent {
  final String id;
  final String? title;
  final String? body;
  final List<String> images;
  final List<String> content;
  final int minimumAllowedViewImages;
  final List<PollOptions> pollOptions;
  final ContentType type;
  final DateTime timestamp;
  final DateTime? upcomingDate;
  final bool isOngoing;
  final String? externalLink;
  final ContentBanner? banner;

  ActivityContent(
      {this.title,
      this.body,
      this.images = const [],
      this.content = const [],
      this.minimumAllowedViewImages = 5,
      this.pollOptions = const [],
      this.externalLink,
      this.banner,
      this.isOngoing = false,
      this.upcomingDate,
      required this.id,
      required this.type,
      required this.timestamp}) {
    if (minimumAllowedViewImages > 5) {
      throw RangeError('Minimum allowed images should not be more than 5');
    }

    if (externalLink == null && type == ContentType.external) {
      throw ArgumentError(
          "A content with type external should not have the externalLink has null");
    }
  }
}

class ContentBanner {
  String url;
  String? thumbnail;
  String position;

  ContentBanner({required this.position, this.thumbnail, required this.url});
}

class PollOptions {
  String title;
  int votes;

  PollOptions({required this.title, required this.votes});
}

enum ContentType { gallery, poll, article, external, event }
