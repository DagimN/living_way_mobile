import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/topic.dart';

void main() {
  group('Topic', () {
    test('fromJson parses all fields', () {
      final json = {
        '_id': 'topic-1',
        'title': 'Faith Discussion',
        'viewCount': 100,
        'likeCount': 25,
        'likers': ['user1'],
        'viewers': ['user2', 'user3'],
        'backgroundImageUrl': 'https://example.com/bg.png',
        'isFavorite': true,
        'type': 'audio',
        'threads': [],
        'playlist': [],
      };
      final topic = Topic.fromJson(json);
      expect(topic.id, 'topic-1');
      expect(topic.title, 'Faith Discussion');
      expect(topic.viewCount, 100);
      expect(topic.likeCount, 25);
      expect(topic.likers, ['user1']);
      expect(topic.viewers, ['user2', 'user3']);
      expect(topic.backgroundImageUrl, 'https://example.com/bg.png');
      expect(topic.isFavorite, isTrue);
      expect(topic.type, TopicType.audio);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        '_id': 'topic-2',
        'title': 'Simple Topic',
        'viewCount': 0,
        'likeCount': 0,
      };
      final topic = Topic.fromJson(json);
      expect(topic.likers, isEmpty);
      expect(topic.viewers, isEmpty);
      expect(topic.isFavorite, isFalse);
      expect(topic.type, TopicType.discussion);
      expect(topic.threads, isEmpty);
    });

    test('toJson serializes fields', () {
      final topic = Topic(
        id: 'id',
        title: 'Title',
        viewCount: 1,
        likeCount: 2,
        type: TopicType.video,
      );
      final json = topic.toJson();
      expect(json['title'], 'Title');
      expect(json['type'], 'video');
      expect(json['isFavorite'], false);
    });
  });

  group('TopicType', () {
    test('fromString returns correct type', () {
      expect(TopicType.fromString('audio'), TopicType.audio);
      expect(TopicType.fromString('video'), TopicType.video);
      expect(TopicType.fromString('discussion'), TopicType.discussion);
      expect(TopicType.fromString('unknown'), TopicType.discussion);
    });
  });
}
