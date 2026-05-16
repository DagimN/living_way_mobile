import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/bible_controller.dart';
import 'package:living_way/core/models/translation.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import '../helpers/api_test_helpers.dart';
import '../helpers/test_helpers.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      Directory.systemTemp.path;

  @override
  Future<String?> getTemporaryPath() async => Directory.systemTemp.path;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initTestEnvironment();
    PathProviderPlatform.instance = _FakePathProvider();
  });

  group('BibleController', () {
    test('fetchTranslations merges API translations', () async {
      final dio = createMockApiDio(routes: {
        '/content/bible': MockResponse(
          statusCode: 200,
          data: {
            'translations': [
              {
                'name': 'ESV',
                'path': '/path/esv.json',
                'status': 'available',
                'isDefault': false,
              },
            ],
          },
        ),
      });

      final controller = BibleController(dio: dio, loadOnInit: false);
      await controller.fetchTranslations();

      expect(
        controller.translations.any((t) => t.name == 'ESV'),
        isTrue,
      );
    });

    test('setBook and setChapter update passage', () async {
      final controller = BibleController(loadOnInit: false);
      await controller.loadTranslation(
        controller.translations.first,
        isDefault: true,
      );

      if (controller.bible.isEmpty) return;

      controller.setBook = controller.bible.first;
      controller.setChapter = 0;
      controller.setVerse = 0;

      expect(controller.passage.book.name, isNotEmpty);
      expect(controller.passage.chapter, 0);
    });

    test('setTranslation updates current translation', () async {
      final controller = BibleController(loadOnInit: false);

      final niv = Translation(
        name: 'NIV',
        status: TranslationStatus.available,
        path: 'assets/data/en_niv.json',
        isDefault: true,
      );

      controller.setTranslation = niv;
      expect(controller.translation.name, 'NIV');
    });
  });
}
