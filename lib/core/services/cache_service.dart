import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  static CacheService get instance => _instance;
  CacheService._internal();

  Future readData<T>(String key, {required T defaultValue}) async {
    final sharedPreferences = SharedPreferencesAsync();
    dynamic data;

    if (T == String) {
      data = await sharedPreferences.getString(key);
    }

    if (T == bool) {
      data = await sharedPreferences.getBool(key);
    }

    if (T == int) {
      data = await sharedPreferences.getInt(key);
    }

    if (T == double) {
      data = await sharedPreferences.getDouble(key);
    }

    if (T == List<String>) {
      data = await sharedPreferences.getStringList(key);
    }

    return data ?? defaultValue;
  }

  Future<void> writeData<T>(String key, T value) async {
    final sharedPreferences = SharedPreferencesAsync();

    if (value is String) await sharedPreferences.setString(key, value);

    if (value is bool) await sharedPreferences.setBool(key, value);

    if (value is int) await sharedPreferences.setInt(key, value);

    if (value is double) await sharedPreferences.setDouble(key, value);

    if (value is List<String>) {
      await sharedPreferences.setStringList(key, value);
    }
  }

  Future<void> deleteData(String key) async {
    final sharedPreferences = SharedPreferencesAsync();

    sharedPreferences.remove(key);
  }

  //TODO: Implement Hive for complex data
}
