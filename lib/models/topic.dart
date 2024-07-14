import 'package:living_way/models/thread.dart';

class Topic {
  final String title;
  final int viewCount;
  final int likeCount;
  final bool isFavorite;
  final TopicType type;
  final String? backgroundImageUrl;
  final List<ThreadData> threads;

  Topic(
      {required this.title,
      required this.viewCount,
      required this.likeCount,
      this.backgroundImageUrl,
      this.isFavorite = false,
      this.type = TopicType.discussion,
      this.threads = const []});

  static Topic fromJson(json) {
    return Topic(
        title: json['title'],
        viewCount: json['viewCount'],
        likeCount: json['likeCount'],
        backgroundImageUrl: json['backgroundImageUrl'],
        isFavorite: json['isFavorite'],
        type: TopicType.fromString(json['type']),
        threads: (json['threads'] as List)
            .map((e) => ThreadData.fromJson(e))
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
      "threads": threads.map((thread) => thread.toJson()).toList()
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
