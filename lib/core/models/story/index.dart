import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

part 'index.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 1)
class Story extends HiveObject implements Cacheable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sourceUrl;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  bool isViewed = false;

  @HiveField(4)
  StoryMetadata? metadata;
  File? file;

  Story({
    required this.id,
    required this.sourceUrl,
    required this.timestamp,
    this.metadata,
    this.file,
  }) {
    _loadStory();
  }

  @override
  String get cacheKey => id;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
        id: json['_id'],
        sourceUrl: json['sourceUrl'],
        timestamp: DateTime.parse(json['createdAt']),
        metadata: json['metaData'] != null
            ? StoryMetadata.fromMap(json['metaData'])
            : null);
  }

  Future<void> _loadStory() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final Directory directory = Directory('${tempDir.path}/stories');

      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      final file = File('${tempDir.path}/stories/$id.mp4');

      if (!file.existsSync()) {
        final response = await http.get(Uri.parse(sourceUrl));
        await file.writeAsBytes(response.bodyBytes);
      }

      this.file = file;
    } catch (error) {
      logger.e('$error - on story item $id');
    }
  }
}

@HiveType(typeId: 12)
class StoryMetadata {
  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final String? image;

  @HiveField(3)
  final List<TimelineItem> timeline;

  StoryMetadata(
      {this.title, this.description, this.image, this.timeline = const []});

  factory StoryMetadata.fromMap(map) {
    final timeline = List.from(map['timeline'] ?? [])
        .map((item) => TimelineItem.fromMap(item))
        .toList();

    int timestampInSeconds(String? timestamp) {
      if (timestamp == null) return 1 << 62;

      final parts = timestamp.split(':').map(int.tryParse).toList();
      if (parts.isEmpty || parts.any((part) => part == null)) return 1 << 62;

      return parts.reversed.toList().asMap().entries.fold(
          0,
          (total, part) =>
              total + part.value! * (60 * (part.key == 0 ? 1 : 60)));
    }

    timeline.sort((timelineA, timelineB) =>
        timestampInSeconds(timelineA.timestamp)
            .compareTo(timestampInSeconds(timelineB.timestamp)));

    return StoryMetadata(
        title: map['title'],
        description: map['description'],
        image: map['image'],
        timeline: timeline);
  }
}

@HiveType(typeId: 13)
class TimelineItem {
  @HiveField(0)
  final String? timestamp;

  @HiveField(1)
  final String? reference;

  @HiveField(2)
  final TimelineItemType? type;

  TimelineItem({this.timestamp, this.reference, this.type});

  factory TimelineItem.fromMap(Map<String, dynamic> map) {
    return TimelineItem(
        reference: map['reference'],
        timestamp: map['timestamp'],
        type: TimelineItemType.fromString(map['type']));
  }

  String get label {
    switch (type) {
      case TimelineItemType.link:
        return reference ?? "";
      case TimelineItemType.passage:
        final context = UIService.navigatorKey.currentContext;

        if (reference == null || context == null) return "";

        final bibleController =
            Provider.of<BibleController>(context, listen: false);
        final passage = Passage.fromMap(
            bibleController.bible, jsonDecode(reference ?? "{}"));

        return passage.label;
      case TimelineItemType.route:
        return "";
      default:
        return "";
    }
  }

  void navigate(LayoutController layoutController) async {
    final context = UIService.navigatorKey.currentContext;

    if (reference == null) return;

    if (type == TimelineItemType.passage && context != null) {
      final bibleController =
          Provider.of<BibleController>(context, listen: false);
      final passage =
          Passage.fromMap(bibleController.bible, jsonDecode(reference!));

      bibleController.setBook = passage.book;
      bibleController.setChapter = passage.chapter;
      bibleController.setVerse = passage.verse;
      bibleController.setPassage = passage;

      UIService.pushNamedAndRemoveUntil('/home', (route) => false);

      await Future.delayed(const Duration(milliseconds: 600));

      layoutController.setSelectedHomePageNavigation = HomePageNavigation.bible;

      layoutController.scrollToVerse(passage);

      AnalyticsService.logChapterOpened(passage.book.name, passage.chapter + 1,
          params: {"scenario": "user_navigated_to_verse_from_story"});
    }

    if (type == TimelineItemType.route) {
      UIService.pushNamed(reference!);
      AnalyticsService.logEvent('user_navigated_to_route_from_story');
    }

    if (type == TimelineItemType.link) {
      final uri = Uri.tryParse(reference!);

      if (uri == null) return;

      if (await canLaunchUrl(uri)) {
        launchUrl(uri);
        AnalyticsService.logEvent('user_navigated_to_link_from_story');
      } else {
        UIService.showSnackbar(
            backgroundColor: Colors.red, message: Tr.t('timelineLinkError'));
      }
    }
  }
}

@HiveType(typeId: 14)
enum TimelineItemType {
  @HiveField(0)
  link,

  @HiveField(1)
  passage,

  @HiveField(2)
  route,

  @HiveField(3)
  undefined;

  static TimelineItemType fromString(String value) {
    switch (value) {
      case "Link":
        return link;
      case "Passage":
        return passage;
      case "Route":
        return route;
      default:
        return undefined;
    }
  }

  String get name {
    switch (this) {
      case link:
        return "Link";
      case passage:
        return "Passage";
      case route:
        return "Route";
      default:
        return "";
    }
  }

  IconData get icon {
    switch (this) {
      case TimelineItemType.link:
        return Icons.link;
      case TimelineItemType.passage:
        return Icons.menu_book;
      case TimelineItemType.route:
        return Icons.open_in_new;
      default:
        return Icons.more_horiz;
    }
  }
}
