import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/activity.dart';

void main() {
  group('Activity', () {
    test('fromJson parses gallery activity', () {
      final json = {
        '_id': 'act-1',
        'title': 'Church Event',
        'body': 'Join us Sunday',
        'type': 'gallery',
        'timestamp': '2025-05-16T10:00:00.000Z',
        'images': ['img1.png', 'img2.png'],
        'isOngoing': false,
      };
      final activity = Activity.fromJson(json);
      expect(activity.id, 'act-1');
      expect(activity.title, 'Church Event');
      expect(activity.type, ContentType.gallery);
      expect(activity.images, ['img1.png', 'img2.png']);
    });

    test('fromJson parses poll options', () {
      final json = {
        '_id': 'poll-1',
        'type': 'poll',
        'timestamp': '2025-05-16T10:00:00.000Z',
        'pollOptions': [
          {'title': 'Option A', 'voters': ['v1', 'v2']},
          {'title': 'Option B', 'voters': []},
        ],
      };
      final activity = Activity.fromJson(json);
      expect(activity.type, ContentType.poll);
      expect(activity.pollOptions, hasLength(2));
      expect(activity.pollOptions.first.title, 'Option A');
      expect(activity.pollOptions.first.voters, ['v1', 'v2']);
    });

    test('constructor throws when minimumAllowedViewImages exceeds 5', () {
      expect(
        () => Activity(
          id: '1',
          type: ContentType.gallery,
          timestamp: DateTime.now(),
          minimumAllowedViewImages: 6,
        ),
        throwsRangeError,
      );
    });

    test('constructor throws when external type has null link', () {
      expect(
        () => Activity(
          id: '1',
          type: ContentType.external,
          timestamp: DateTime.now(),
        ),
        throwsArgumentError,
      );
    });

    test('toMap includes only non-empty optional fields', () {
      final activity = Activity(
        id: '1',
        type: ContentType.general,
        timestamp: DateTime(2025, 5, 16),
        title: 'Title',
        body: 'Body',
      );
      final map = activity.toMap();
      expect(map['title'], 'Title');
      expect(map['body'], 'Body');
      expect(map['type'], 'general');
      expect(map['isOngoing'], false);
    });
  });

  group('ContentType', () {
    test('fromString returns correct types', () {
      expect(ContentType.fromString('gallery'), ContentType.gallery);
      expect(ContentType.fromString('poll'), ContentType.poll);
      expect(ContentType.fromString('article'), ContentType.article);
      expect(ContentType.fromString('external'), ContentType.external);
      expect(ContentType.fromString('event'), ContentType.event);
      expect(ContentType.fromString('general'), ContentType.general);
      expect(ContentType.fromString('unknown'), ContentType.undefined);
    });
  });

  group('PollOptions', () {
    test('fromJson and toJson round-trip', () {
      final json = {'title': 'Yes', 'voters': ['u1']};
      final option = PollOptions.fromJson(json);
      expect(option.title, 'Yes');
      expect(option.toJson(), json);
    });
  });

  group('ContentBanner', () {
    test('fromJson returns null for null input', () {
      expect(ContentBanner.fromJson(null), isNull);
    });

    test('fromJson parses banner', () {
      final banner = ContentBanner.fromJson({
        'position': 'top',
        'url': 'https://example.com/banner.png',
      });
      expect(banner?.position, 'top');
      expect(banner?.url, 'https://example.com/banner.png');
    });
  });
}
