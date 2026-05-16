import 'package:dio/dio.dart';
import 'package:living_way/core/constants/urls.dart';

/// Base URL used in tests (`appFlavor` is null outside flavor builds).
const testApiBaseUrl = Urls.prodApiUrl;

/// Creates a [Dio] instance that resolves requests via interceptors.
Dio createMockApiDio({
  Map<String, MockResponse> routes = const {},
}) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        for (final entry in routes.entries) {
          if (options.uri.path.contains(entry.key)) {
            final mock = entry.value;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: mock.statusCode,
                data: mock.data,
              ),
            );
            return;
          }
        }
        handler.reject(
          DioException(
            requestOptions: options,
            message: 'No mock for ${options.method} ${options.uri}',
          ),
        );
      },
    ),
  );
  return dio;
}

class MockResponse {
  final int statusCode;
  final dynamic data;

  const MockResponse({required this.statusCode, this.data});
}

Map<String, dynamic> sampleProfileJson({
  String id = 'user-1',
  String firstName = 'John',
  String lastName = 'Doe',
  String email = 'john@example.com',
}) =>
    {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': null,
      'isAnonymous': false,
      'tokenId': 'token-1',
      'passwordExists': true,
    };

Map<String, dynamic> sampleActivityJson({
  String id = 'act-1',
  String title = 'Sunday Service',
}) =>
    {
      '_id': id,
      'title': title,
      'type': 'general',
      'timestamp': DateTime.now().toIso8601String(),
    };

Map<String, dynamic> sampleTopicJson({
  String id = 'topic-1',
  String title = 'Faith Talk',
}) =>
    {
      '_id': id,
      'title': title,
      'viewCount': 10,
      'likeCount': 2,
    };
