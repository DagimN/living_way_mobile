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
  final String? locationUrl;
  final ContentBanner? banner;

  ActivityContent(
      {this.title,
      this.body,
      this.images = const [],
      this.content = const [],
      this.minimumAllowedViewImages = 5,
      this.pollOptions = const [],
      this.externalLink,
      this.locationUrl,
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

  static ActivityContent fromJson(Map<String, dynamic> json) {
    return ActivityContent(
        id: json['_id'],
        title: json['title'],
        body: json['body'],
        images: ((json['images'] as List?) ?? [])
            .map((image) => image.toString())
            .toList(),
        content: ((json['content'] as List?) ?? [])
            .map((content) => content.toString())
            .toList(),
        minimumAllowedViewImages: json['minimumAllowedViewImages'] ?? 0,
        pollOptions: ((json['pollOptions'] as List?) ?? [])
            .map((poll) => PollOptions.fromJson(poll))
            .toList(),
        externalLink: json['externalLink'],
        locationUrl: json['locationUrl'],
        banner: ContentBanner.fromJson(json['banner']),
        isOngoing: json['isOngoing'] ?? false,
        type: ContentType.fromString(json['type']),
        timestamp: DateTime.parse(json['timestamp'] ?? json['createdAt']),
        upcomingDate: json['upcomingDate'] != null
            ? DateTime.parse(json['upcomingDate'])
            : null);
  }
}

class ContentBanner {
  String url;
  String? thumbnail;
  String position;

  ContentBanner({required this.position, this.thumbnail, required this.url});

  static ContentBanner? fromJson(json) {
    return json != null
        ? ContentBanner(position: json['position'], url: json['url'])
        : null;
  }
}

class PollOptions {
  final String title;
  final List<String> voters;

  PollOptions({required this.title, this.voters = const []});

  static PollOptions fromJson(json) {
    return PollOptions(
        title: json['title'],
        voters:
            (json['voters'] as List).map((voter) => voter.toString()).toList());
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "voters": voters};
  }
}

enum ContentType {
  gallery,
  poll,
  article,
  external,
  event,
  undefined;

  static ContentType fromString(value) {
    switch (value) {
      case "gallery":
        return ContentType.gallery;
      case "poll":
        return ContentType.poll;
      case "article":
        return ContentType.article;
      case "external":
        return ContentType.external;
      case "event":
        return ContentType.event;
      default:
        return ContentType.undefined;
    }
  }
}
