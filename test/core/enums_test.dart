import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/enums.dart';

void main() {
  group('FileType', () {
    test('fromString returns correct types', () {
      expect(FileType.fromString('pdf'), FileType.pdf);
      expect(FileType.fromString('mp4'), FileType.mp4);
      expect(FileType.fromString('png'), FileType.png);
      expect(FileType.fromString('jpg'), FileType.jpg);
      expect(FileType.fromString('unknown'), FileType.undefined);
    });
  });

  group('NotificationCodes', () {
    test('value returns expected integers', () {
      expect(NotificationCodes.verseOfTheDay.value, 1);
      expect(NotificationCodes.activity.value, 2);
      expect(NotificationCodes.recurring.value, 3);
      expect(NotificationCodes.download.value, 4);
      expect(NotificationCodes.general.value, 5);
    });

    test('extendedCode combines value and index', () {
      expect(NotificationCodes.verseOfTheDay.extendedCode(3), 13);
      expect(NotificationCodes.download.extendedCode(42), 442);
    });
  });

  group('SortOptions', () {
    test('has expected values', () {
      expect(SortOptions.values.length, 4);
      expect(SortOptions.latest.name, 'latest');
    });
  });

  group('CategoryFilter', () {
    test('has expected values', () {
      expect(CategoryFilter.values.length, 3);
    });
  });

  group('AppLocale', () {
    test('has en and am', () {
      expect(AppLocale.en.name, 'en');
      expect(AppLocale.am.name, 'am');
    });
  });

  group('Fonts', () {
    test('contains all font families', () {
      expect(Fonts.values.length, 6);
      expect(Fonts.RobotoSlab.name, 'RobotoSlab');
    });
  });
}
