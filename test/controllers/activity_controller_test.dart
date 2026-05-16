import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/activity_controller.dart';
import 'package:living_way/core/models/activity.dart';
import '../helpers/api_test_helpers.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('ActivityController', () {
    test('fetchActivities populates list from API', () async {
      final dio = createMockApiDio(routes: {
        '/content/activity': MockResponse(
          statusCode: 200,
          data: [
            sampleActivityJson(id: 'a1', title: 'Event 1'),
            sampleActivityJson(id: 'a2', title: 'Event 2'),
          ],
        ),
      });

      final controller = ActivityController(dio: dio, fetchOnInit: false);
      await controller.fetchActivities();
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      expect(controller.activityList, hasLength(2));
      expect(controller.activityList.first.title, 'Event 1');
      expect(controller.pageIndex, 1);

      controller.dispose();
    });

    test('fetchActivities with refresh clears and reloads list', () async {
      final dio = createMockApiDio(routes: {
        '/content/activity': MockResponse(
          statusCode: 200,
          data: [sampleActivityJson()],
        ),
      });

      final controller = ActivityController(dio: dio, fetchOnInit: false);
      controller.activityList.add(
        Activity(
          id: 'old',
          type: ContentType.general,
          timestamp: DateTime.now(),
        ),
      );

      await controller.fetchActivities(isRefreshing: true);
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      expect(controller.activityList, hasLength(1));
      expect(controller.activityList.first.id, 'act-1');

      controller.dispose();
    });

    test('updatePoll returns true on success', () async {
      final dio = createMockApiDio(routes: {
        '/content/activity/edit': MockResponse(statusCode: 200, data: {}),
      });

      final controller = ActivityController(dio: dio, fetchOnInit: false);
      final poll = Activity(
        id: 'poll-1',
        type: ContentType.poll,
        timestamp: DateTime.now(),
        pollOptions: [PollOptions(title: 'Yes')],
      );

      final updated = await controller.updatePoll(poll);

      expect(updated, isTrue);
      controller.dispose();
    });
  });
}
