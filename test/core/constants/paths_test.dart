import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/config/paths.dart';

void main() {
  group('AppIcons', () {
    test('icon paths point to assets/svg', () {
      expect(AppIcons.bible, 'assets/svg/bible.svg');
      expect(AppIcons.home, 'assets/svg/home.svg');
      expect(AppIcons.search, 'assets/svg/search.svg');
    });
  });

  group('AppImages', () {
    test('image paths point to assets', () {
      expect(AppImages.profilePlaceholder,
          'assets/images/profile_placeholder.png');
      expect(AppImages.logoTransparent, 'assets/images/logo_transparent.png');
    });
  });
}
