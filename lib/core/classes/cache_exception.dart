/// Thrown by [HiveService] when a storage operation fails.
class CacheException implements Exception {
  final String message;
  final Object? cause;

  const CacheException(this.message, {this.cause});

  @override
  String toString() =>
      'CacheException: $message${cause != null ? ' (cause: $cause)' : ''}';
}
