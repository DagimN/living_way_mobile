import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/constants/content.dart';

void main() {
  group('books constant', () {
    test('OT has 39 books', () {
      expect(books['ot'], hasLength(39));
      expect(books['ot']!.first, 'Genesis');
      expect(books['ot']!.last, 'Malachi');
    });

    test('NT has 27 books', () {
      expect(books['nt'], hasLength(27));
      expect(books['nt']!.first, 'Matthew');
      expect(books['nt']!.last, 'Revelation');
    });
  });

  group('threads constant', () {
    test('has sample thread data', () {
      expect(threads, isNotEmpty);
      expect(threads.first.comment, isNotEmpty);
    });
  });

  group('dailyVerses constant', () {
    test('has verse references as tuples', () {
      expect(dailyVerses, hasLength(3));
      expect(dailyVerses.first.$1, isA<int>());
      expect(dailyVerses.first.$2, isA<int>());
      expect(dailyVerses.first.$3, isA<int>());
    });
  });
}
