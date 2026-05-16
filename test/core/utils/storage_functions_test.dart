import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/utils/storage_functions.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform {
  late Directory tempDir;

  @override
  Future<String?> getApplicationDocumentsPath() async => tempDir.path;

  @override
  Future<String?> getTemporaryPath() async => tempDir.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late _FakePathProvider fakePathProvider;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('living_way_test_');
    fakePathProvider = _FakePathProvider()..tempDir = tempDir;
    PathProviderPlatform.instance = fakePathProvider;
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('readFile', () {
    test('returns file contents when file exists', () async {
      final file = File('${tempDir.path}/test.txt');
      await file.writeAsString('hello storage');

      final contents = await readFile(file.path);

      expect(contents, 'hello storage');
    });

    test('returns null when file does not exist', () async {
      final contents = await readFile('${tempDir.path}/missing.txt');
      expect(contents, isNull);
    });
  });

  group('saveTranslationFile', () {
    test('writes translation file and returns path', () async {
      const contents = '{"books":[]}';
      final path = await saveTranslationFile('test_translation.json', contents);

      expect(path, isNotNull);
      expect(File(path!).existsSync(), isTrue);
      expect(await File(path).readAsString(), contents);
    });
  });

  group('cleanResources', () {
    test('deletes files not in contentIds list', () async {
      final contentDir = Directory('${tempDir.path}/library');
      await contentDir.create(recursive: true);
      await File('${contentDir.path}/keep.pdf').create();
      await File('${contentDir.path}/remove.pdf').create();

      await cleanResources(
        contentIds: ['keep'],
        path: '/library',
      );

      expect(File('${contentDir.path}/keep.pdf').existsSync(), isTrue);
      expect(File('${contentDir.path}/remove.pdf').existsSync(), isFalse);
    });
  });

  group('loadJson', () {
    test('loads and decodes asset json', () async {
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);

      final data = await loadJson('assets/data/en_nkjv.json');

      expect(data, isA<List>());
      expect(data, isNotEmpty);
    });
  });
}
