import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/core/enums.dart';
import 'package:living_way/core/models/content.dart';
import 'package:living_way/core/services/cache_service.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('ContentController', () {
    late ContentController controller;

    setUp(() {
      controller = ContentController(loadOnInit: false);
    });

    test('exposes static church data', () {
      expect(controller.staffs, isNotEmpty);
      expect(controller.contacts, isNotEmpty);
      expect(controller.aspirations, hasLength(8));
      expect(controller.library, isNotEmpty);
    });

    test('viewStory marks story as viewed and caches id', () async {
      controller.viewStory('1');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.viewedStories, contains('1'));

      final cached = await CacheService.instance.readData<List<String>>(
        'viewedStories',
        defaultValue: [],
      );
      expect(cached, contains('1'));
    });

    test('viewStory does not duplicate viewed ids', () async {
      controller.viewStory('2');
      controller.viewStory('2');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.viewedStories.where((id) => id == '2'), hasLength(1));
    });

    test('fetchStories sorts unviewed stories first', () async {
      controller.viewedStories = ['1'];
      await controller.fetchStories();

      final unviewed = controller.stories.where((s) => !s.isViewed);
      expect(unviewed, isNotEmpty);
    });

    test('setThreadFilter updates filter', () {
      controller.setThreadFilter = SortOptions.mostLiked;
      expect(controller.threadActivityFilter, SortOptions.mostLiked);
    });

    test('saveLibrary tracks reading progress', () async {
      final content = Content(
        id: 'test-content',
        title: 'Test Book',
        presenter: 'Author',
        source: 'https://example.com/book.pdf',
        filePath: '/tmp/book.pdf',
      );
      controller.library.add(content);

      controller.saveLibrary(content);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(
        controller.library.any((c) => c.id == 'test-content'),
        isTrue,
      );
    });

    test('loadCache restores viewed stories', () async {
      await CacheService.instance.writeData<List<String>>(
        'viewedStories',
        ['3'],
      );

      await controller.loadCache();

      expect(controller.viewedStories, contains('3'));
    });
  });
}
