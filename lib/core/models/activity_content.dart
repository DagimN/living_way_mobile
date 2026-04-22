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
  final bool isRecurring; // TODO: Update model in the backend

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
      this.isRecurring = false,
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

  static DateTime _getNextOccurrence(int targetWeekday) {
    DateTime now = DateTime.now();
    int daysUntilNext = (targetWeekday - now.weekday + 7) % 7;

    if (daysUntilNext == 0) daysUntilNext = 7;

    return now.add(Duration(days: daysUntilNext));
  }

  static ActivityContent fromJson(Map<String, dynamic> json) {
    final isRecurring = json['isRecurring'] ?? false;
    DateTime timestamp = DateTime.parse(json['timestamp'] ?? json['createdAt']);

    if (isRecurring) {
      timestamp = _getNextOccurrence(timestamp.weekday);
    }

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
        type: isRecurring
            ? ContentType.general
            : ContentType.fromString(json['type']),
        timestamp: timestamp,
        isRecurring: json['isRecurring'] ?? false,
        upcomingDate: json['upcomingDate'] != null
            ? DateTime.parse(json['upcomingDate'])
            : null);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (title != null) {
      map.addEntries([MapEntry('title', title)]);
    }

    if (body != null) {
      map.addEntries([MapEntry('body', body)]);
    }

    if (images.isNotEmpty) {
      map.addEntries([MapEntry('images', images)]);
    }

    if (content.isNotEmpty) {
      map.addEntries([MapEntry('content', content)]);
    }

    if (minimumAllowedViewImages > 0) {
      map.addEntries(
          [MapEntry('minimumAllowedViewImages', minimumAllowedViewImages)]);
    }

    if (pollOptions.isNotEmpty) {
      map.addEntries([
        MapEntry(
            "pollOptions", pollOptions.map((poll) => poll.toJson()).toList())
      ]);
    }

    if (externalLink != null) {
      map.addEntries([MapEntry('externalLink', externalLink)]);
    }

    if (locationUrl != null) {
      map.addEntries([MapEntry('locationUrl', locationUrl)]);
    }

    if (banner != null) {
      map.addEntries([MapEntry('banner', banner)]);
    }

    if (upcomingDate != null) {
      map.addEntries([MapEntry('upcomingDate', upcomingDate)]);
    }

    map.addEntries([
      MapEntry('isOngoing', isOngoing),
      MapEntry('isRecurring', isRecurring),
      MapEntry('type', type.name),
      MapEntry('timestamp', timestamp.toIso8601String())
    ]);

    return map;
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
  general,
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
      case "general":
        return ContentType.general;
      default:
        return ContentType.undefined;
    }
  }
}
