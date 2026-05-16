import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/devotion_controller.dart';
import 'package:living_way/core/enums.dart';
import 'package:living_way/core/models/topic.dart';
import '../helpers/api_test_helpers.dart';

void main() {
  group('DevotionController.populateQuery', () {
    late DevotionController controller;

    setUp(() {
      controller = DevotionController(fetchOnInit: false);
    });

    tearDown(() {
      controller.dispose();
    });

    test('returns page and sort by default', () {
      final query = controller.populateQuery();
      expect(query['page'], 0);
      expect(query['sort'], SortOptions.latest.name);
      expect(query.containsKey('filters'), isFalse);
    });

    test('includes category filter when not all', () {
      controller.setCategoryFilter = CategoryFilter.ot;
      final query = controller.populateQuery();
      expect(query['filters'], contains('ot'));
    });

    test('includes book filters', () {
      controller.setBooksFilter = ['Genesis', 'Exodus'];
      final query = controller.populateQuery();
      expect(query['filters'], containsAll(['Genesis', 'Exodus']));
    });

    test('combines category and book filters', () {
      controller.setCategoryFilter = CategoryFilter.nt;
      controller.setBooksFilter = ['Matthew'];
      final query = controller.populateQuery();
      expect(query['filters'], containsAll(['nt', 'Matthew']));
    });

    test('setSortOption updates sort option', () {
      controller.setSortOption = SortOptions.mostLiked;
      expect(controller.sortOption, SortOptions.mostLiked);
    });

    test('setCommentingThreadKey updates notifier', () {
      final key = GlobalKey();
      controller.setCommentingThreadKey = key;
      expect(controller.commentingThreadKeyNotifier.value, key);
    });
  });

  group('DevotionController.fetchTopics', () {
    test('loads topics from API', () async {
      final dio = createMockApiDio(routes: {
        '/content/devotion': MockResponse(
          statusCode: 200,
          data: [
            sampleTopicJson(id: 't1', title: 'Topic A'),
            sampleTopicJson(id: 't2', title: 'Topic B'),
          ],
        ),
      });

      final controller = DevotionController(dio: dio, fetchOnInit: false);
      await controller.fetchTopics();
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      expect(controller.topicList, hasLength(2));
      expect(controller.topicList.first.title, 'Topic A');

      controller.dispose();
    });

    test('updateTopic replaces topic in list', () async {
      final dio = createMockApiDio(routes: {
        '/content/devotion': MockResponse(
          statusCode: 200,
          data: [sampleTopicJson()],
        ),
        '/content/devotion/edit': MockResponse(statusCode: 200, data: {}),
      });

      final controller = DevotionController(dio: dio, fetchOnInit: false);
      await controller.fetchTopics();
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      final updated = Topic(
        id: 'topic-1',
        title: 'Updated Title',
        viewCount: 10,
        likeCount: 2,
      );

      await controller.updateTopic(updated);

      expect(
        controller.topicList.any((t) => t.title == 'Updated Title'),
        isTrue,
      );

      controller.dispose();
    });
  });
}
