import 'package:living_way/models/media_metadata.dart';
import 'package:living_way/models/thread.dart';

class Topic {
  final String title;
  final int viewCount;
  final int likeCount;
  final bool isFavorite;
  final TopicType type;
  final List<ThreadData> threads;
  final String? backgroundImageUrl;
  final List<MediaMetadata> playlist;

  Topic(
      {required this.title,
      required this.viewCount,
      required this.likeCount,
      this.backgroundImageUrl,
      this.isFavorite = false,
      this.threads = const [],
      this.type = TopicType.discussion,
      this.playlist = const []});

  static Topic fromJson(json) {
    return Topic(
        title: json['title'],
        viewCount: json['viewCount'],
        likeCount: json['likeCount'],
        backgroundImageUrl:
            json['backgroundImageUrl'],
        isFavorite: json['isFavorite'] ?? false,
        type: TopicType.fromString(json['type'] ?? "discussion"),
        threads: ((json['threads'] as List?) ?? [])
            .map((e) => ThreadData.fromJson(e))
            .toList(),
        playlist: ((json['playlist'] as List?) ?? [])
            .map((e) => MediaMetadata.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "viewCount": viewCount,
      "likeCount": likeCount,
      "backgroundImageUrl": backgroundImageUrl,
      "isFavorite": isFavorite,
      "type": type.name,
      "threads": threads.map((thread) => thread.toJson()).toList(),
      "playlist": playlist.map((metadata) => metadata.toJson()).toList()
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
