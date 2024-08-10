class ActivityContent {
  final String id;
  final String? title;
  final String? body;
  final List<String> images;
  final int minimumAllowedViewImages;
  final List<PollOptions> pollOptions;
  final ContentType type;
  final DateTime timestamp;
  final DateTime? upcomingDate;
  final bool isOngoing;
  final String? externalLink;
  final Banner? banner;

  ActivityContent(
      {this.title,
      this.body,
      this.images = const [],
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
  }
}

class Banner {
  String url;
  String position;

  Banner({required this.position, required this.url});
}

class PollOptions {
  String title;
  int votes;

  PollOptions({required this.title, required this.votes});
}

enum ContentType { gallery, poll, article, external, event }
