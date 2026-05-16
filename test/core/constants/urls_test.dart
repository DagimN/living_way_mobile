import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/constants/urls.dart';

void main() {
  group('Urls', () {
    test('API URLs are defined', () {
      expect(Urls.devApiUrl, isNotEmpty);
      expect(Urls.stagingApiUrl, startsWith('https://'));
      expect(Urls.prodApiUrl, startsWith('https://'));
    });

    test('policy and image URLs are defined', () {
      expect(Urls.termsUrl, contains('policies.google.com'));
      expect(Urls.imageApiUrl, startsWith('https://'));
      expect(Urls.unsplashApiUrl, startsWith('https://'));
    });
  });
}
