/// Marks a model as eligible for on-device Hive caching.
///
/// Any class stored via [HiveService] must implement this interface so the
/// service can retrieve a stable, unique string key for each record.
///
/// ### Example
/// ```dart
/// @HiveType(typeId: 1)
/// class UserModel extends HiveObject implements Cacheable {
///   @HiveField(0)
///   final String id;
///   // ...
///
///   @override
///   String get cacheKey => id;
/// }
/// ```
abstract interface class Cacheable {
  /// A unique, stable string key used as the Hive storage key.
  ///
  /// Must be consistent across app sessions for the same logical record.
  String get cacheKey;
}
