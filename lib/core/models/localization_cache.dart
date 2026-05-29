import 'package:hive_flutter/hive_flutter.dart';

class LocalizationCache {
  static const _boxName = 'localization_cache';

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Map<String, dynamic>? getStrings(String locale) {
    final raw = _box.get(locale);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<void> save(
    String locale,
    Map<String, dynamic> strings,
  ) async {
    await _box.put(locale, strings);
  }

  Future<void> clear(String locale) async {
    await _box.delete(locale);
  }

  Future<void> clearAll() async => _box.clear();
}
