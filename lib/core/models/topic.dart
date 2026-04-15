import 'package:living_way/core/models/media_metadata.dart';
import 'package:living_way/core/models/thread.dart';

class Topic {
  final String id;
  final String title;
  final int viewCount;
  final List<String> viewers;
  final int likeCount;
  final List<String> likers;
  final bool isFavorite;
  final TopicType type;
  final List<ThreadData> threads;
  final String? backgroundImageUrl;
  final List<MediaMetadata> playlist;

  Topic(
      {required this.id,
      required this.title,
      required this.viewCount,
      required this.likeCount,
      this.backgroundImageUrl,
      this.isFavorite = false,
      this.likers = const [],
      this.viewers = const [],
      this.threads = const [],
      this.type = TopicType.discussion,
      this.playlist = const []});

  static Topic fromJson(json) {
    return Topic(
        id: json['_id'],
        title: json['title'],
        viewCount: json['viewCount'],
        likers:
            ((json['likers'] as List?) ?? []).map((e) => e.toString()).toList(),
        viewers: ((json['viewers'] as List?) ?? [])
            .map((e) => e.toString())
            .toList(),
        likeCount: json['likeCount'],
        backgroundImageUrl: json['backgroundImageUrl'],
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
      "backgroundImageUrl": backgroundImageUrl,
      "isFavorite": isFavorite,
      "type": type.name,
      "likers": likers.map((liker) => liker.toString()).toList(),
      "viewers": viewers.map((viewer) => viewer.toString()).toList(),
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
