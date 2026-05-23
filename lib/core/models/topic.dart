import 'package:living_way/core/models/content.dart';
import 'package:living_way/core/models/thread.dart';

class Topic {
  final String id;
  final String title;
  final TopicType type;
  final List<ThreadData> threads;
  final String? backgroundImageUrl;
  final List<Content> playlist;
  final DateTime timestamp;

  Topic(
      {required this.id,
      required this.title,
      required this.timestamp,
      this.backgroundImageUrl,
      this.threads = const [],
      this.type = TopicType.discussion,
      this.playlist = const []});

  factory Topic.fromJson(json) {
    return Topic(
        id: json['_id'],
        title: json['title'],
        timestamp: DateTime.parse(json['createdAt']),
        backgroundImageUrl: json['backgroundImageUrl'],
        type: TopicType.fromString(json['type'] ?? "discussion"),
        threads: ((json['threads'] as List?) ?? [])
            .map((e) => ThreadData.fromJson(e))
            .toList(),
        playlist: ((json['playlist'] as List?) ?? [])
            .map((e) => Content.fromJson(e))
            .toList());
  }

  factory Topic.empty() {
    return Topic(id: '', title: '', timestamp: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "backgroundImageUrl": backgroundImageUrl,
      "type": type.name,
      "threads": threads.map((thread) => thread.toJson()).toList(),
      "playlist": playlist.map((metadata) => metadata.toJson()).toList(),
      "timestamp": timestamp.toIso8601String()
    };
  }
}

enum TopicType {
  discussion,
  audio,
  video;

  static TopicType fromString(String name) {
    switch (name) {
      case 'audio':
        return TopicType.audio;
      case 'video':
        return TopicType.video;
      default:
        return TopicType.discussion;
    }
  }
}
