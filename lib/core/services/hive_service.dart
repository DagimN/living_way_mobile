import 'package:hive_flutter/hive_flutter.dart';

import '../classes/cache_exception.dart';
import '../classes/cacheable.dart';

abstract class HiveService<T extends Cacheable> {
  final String boxName;

  static final Map<String, Box<dynamic>> _boxes = {};

  HiveService({required this.boxName});

  void registerAdapters();

  Future<void> init() async {
    if (_boxes[boxName]?.isOpen == true) return;
    await Hive.initFlutter();
    registerAdapters();
    _boxes[boxName] = await Hive.openBox<T>(boxName);
  }

  Future<void> dispose() async {
    await _boxes[boxName]?.close();
    _boxes.remove(boxName);
  }

  Box<T> get _openBox {
    final box = _boxes[boxName];
    if (box == null || !box.isOpen) {
      throw CacheException(
        'Box "$boxName" is not open. Did you forget to call init()?',
      );
    }
    return box as Box<T>;
  }

  Future<void> save(T item) async {
    try {
      await _openBox.put(item.cacheKey, item);
    } catch (e) {
      throw CacheException(
        'Failed to save item with key "${item.cacheKey}" in box "$boxName"',
        cause: e,
      );
    }
  }

  Future<void> saveAll(List<T> items) async {
    if (items.isEmpty) return;
    try {
      await _openBox.putAll({for (final item in items) item.cacheKey: item});
    } catch (e) {
      throw CacheException(
        'Failed to batch-save ${items.length} items in box "$boxName"',
        cause: e,
      );
    }
  }

  T? getByKey(String key) => _openBox.get(key);

  List<T> getAll() => _openBox.values.toList();

  List<T> getWhere(bool Function(T item) predicate) =>
      _openBox.values.where(predicate).toList();

  T? firstWhere(bool Function(T item) predicate) {
    try {
      return _openBox.values.firstWhere(predicate);
    } catch (_) {
      return null;
    }
  }

  int get count => _openBox.length;

  bool containsKey(String key) => _openBox.containsKey(key);

  Stream<List<T>> watchAll() => _openBox.watch().map((_) => getAll());

  Stream<T?> watchByKey(String key) => _openBox
      .watch(key: key)
      .map((event) => event.deleted ? null : event.value as T?);

  Future<void> deleteByKey(String key) async {
    try {
      await _openBox.delete(key);
    } catch (e) {
      throw CacheException(
        'Failed to delete item with key "$key" from box "$boxName"',
        cause: e,
      );
    }
  }

  Future<void> deleteAll(List<String> keys) async {
    if (keys.isEmpty) return;
    try {
      await _openBox.deleteAll(keys);
    } catch (e) {
      throw CacheException(
        'Failed to batch-delete ${keys.length} items from box "$boxName"',
        cause: e,
      );
    }
  }

  Future<void> clear() async {
    try {
      await _openBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear box "$boxName"', cause: e);
    }
  }

  Future<void> compact() async {
    try {
      await _openBox.compact();
    } catch (e) {
      throw CacheException('Failed to compact box "$boxName"', cause: e);
    }
  }
}
