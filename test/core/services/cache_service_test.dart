import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/services/cache_service.dart';
import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('CacheService', () {
    test('is a singleton', () {
      expect(identical(CacheService.instance, CacheService.instance), isTrue);
    });

    test('writeData and readData for string', () async {
      await CacheService.instance.writeData('test_key', 'hello');
      final value = await CacheService.instance.readData<String>(
        'test_key',
        defaultValue: '',
      );
      expect(value, 'hello');
    });

    test('writeData and readData for int', () async {
      await CacheService.instance.writeData('int_key', 42);
      final value = await CacheService.instance.readData<int>(
        'int_key',
        defaultValue: 0,
      );
      expect(value, 42);
    });

    test('writeData and readData for bool', () async {
      await CacheService.instance.writeData('bool_key', true);
      final value = await CacheService.instance.readData<bool>(
        'bool_key',
        defaultValue: false,
      );
      expect(value, isTrue);
    });

    test('writeData and readData for double', () async {
      await CacheService.instance.writeData('double_key', 0.75);
      final value = await CacheService.instance.readData<double>(
        'double_key',
        defaultValue: 0.0,
      );
      expect(value, 0.75);
    });

    test('writeData and readData for string list', () async {
      await CacheService.instance.writeData('list_key', ['a', 'b']);
      final value = await CacheService.instance.readData<List<String>>(
        'list_key',
        defaultValue: [],
      );
      expect(value, ['a', 'b']);
    });

    test('readData returns default when key missing', () async {
      final value = await CacheService.instance.readData<String>(
        'nonexistent_key_${DateTime.now().millisecondsSinceEpoch}',
        defaultValue: 'default',
      );
      expect(value, 'default');
    });
  });
}
