import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:living_way/screens/ActivityScreen/widgets/article.dart';
import 'package:living_way/screens/ActivityScreen/widgets/event.dart';
import 'package:living_way/screens/ActivityScreen/widgets/external_link.dart';
import 'package:living_way/screens/ActivityScreen/widgets/gallery.dart';
import 'package:living_way/screens/ActivityScreen/widgets/poll.dart';

import '../../classes/cacheable.dart';
import '../profile.dart';

part 'index.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 2)
class Activity extends HiveObject implements Cacheable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? body;

  @HiveField(3)
  final List<String> images;

  @HiveField(4)
  final List<String> content;

  @HiveField(5)
  final int minimumAllowedViewImages;

  @HiveField(6)
  final List<PollOptions> pollOptions;

  @HiveField(7)
  final ContentType type;

  @HiveField(8)
  final DateTime timestamp;

  @HiveField(9)
  final DateTime? upcomingDate;

  @HiveField(10)
  final bool isOngoing;

  @HiveField(11)
  final String? externalLink;

  @HiveField(12)
  final String? locationUrl;

  @HiveField(13)
  final ContentBanner? banner;

  @HiveField(14)
  final bool
      isRecurring; //TODO: Implement scheduled notifications for recurring activities

  Activity(
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

  @override
  String get cacheKey => id;

  static DateTime _getNextOccurrence(DateTime timestamp) {
    int targetWeekday = timestamp.weekday;
    DateTime now = DateTime.now();
    int daysUntilNext = (targetWeekday - now.weekday + 7) % 7;

    return DateTime(now.year, now.month, now.day + daysUntilNext,
        timestamp.hour, timestamp.minute);
  }

  static Activity fromJson(Map<String, dynamic> json) {
    final isRecurring = json['isRecurring'] ?? false;
    DateTime timestamp = DateTime.parse(json['timestamp'] ?? json['createdAt']);

    if (isRecurring) {
      timestamp = timestamp.isAfter(DateTime.now())
          ? timestamp
          : _getNextOccurrence(timestamp);
    }

    return Activity(
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

  IconData get icon {
    switch (type) {
      case ContentType.external:
        return Icons.link;
      case ContentType.poll:
        return Icons.poll;
      case ContentType.gallery:
        return Icons.photo;
      case ContentType.article:
        return Icons.article;
      case ContentType.general:
        return Icons.radio_button_checked;
      default:
        return Icons.calendar_month;
    }
  }

  Widget? getChild({Profile? profile}) {
    switch (type) {
      case ContentType.gallery:
        return Gallery(
            images: images,
            minimumAllowedImagesForView: minimumAllowedViewImages);
      case ContentType.article:
        return Article(content: this);
      case ContentType.poll:
        return Poll(content: this, userProfile: profile);
      case ContentType.external:
        return ExternalLink(content: this);
      case ContentType.event:
        return Event(content: this);
      default:
        return null;
    }
  }
}

@HiveType(typeId: 3)
class ContentBanner {
  @HiveField(0)
  String url;

  @HiveField(1)
  String? thumbnail;

  @HiveField(2)
  String position;

  ContentBanner({required this.position, this.thumbnail, required this.url});

  static ContentBanner? fromJson(json) {
    return json != null
        ? ContentBanner(position: json['position'], url: json['url'])
        : null;
  }
}

@HiveType(typeId: 4)
class PollOptions {
  @HiveField(0)
  final String title;

  @HiveField(1)
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

@HiveType(typeId: 5)
enum ContentType {
  @HiveField(0)
  gallery,

  @HiveField(1)
  poll,

  @HiveField(2)
  article,

  @HiveField(3)
  external,

  @HiveField(4)
  event,

  @HiveField(5)
  general,

  @HiveField(6)
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
