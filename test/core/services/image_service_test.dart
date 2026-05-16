import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/constants/urls.dart';
import 'package:living_way/core/services/image_service.dart';
import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('ImageService.fetchImages', () {
    test('returns image urls on success', () async {
      final dio = Dio(BaseOptions(baseUrl: Urls.unsplashApiUrl));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'results': [
                    {
                      'urls': {'regular': 'https://example.com/photo1.jpg'},
                    },
                    {
                      'urls': {'regular': 'https://example.com/photo2.jpg'},
                    },
                  ],
                },
              ),
            );
          },
        ),
      );

      final images = await ImageService.fetchImages(dio: dio);

      expect(images, hasLength(2));
      expect(images.first, contains('example.com'));
    });

    test('returns fallback on API error', () async {
      final dio = Dio(BaseOptions(baseUrl: Urls.unsplashApiUrl));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 500,
                data: 'Error',
              ),
            );
          },
        ),
      );

      final images = await ImageService.fetchImages(dio: dio);

      expect(images, [Urls.imageApiUrl]);
    });
  });
}
