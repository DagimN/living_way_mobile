import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/bible_quote.dart';

void main() {
  group('BibleQuote', () {
    test('fromJson and toJson round-trip', () {
      final json = {
        'book': 'John',
        'int': 3,
        'verse': 16,
        'index': 1,
      };
      final quote = BibleQuote.fromJson(json);
      expect(quote.book, 'John');
      expect(quote.chapter, 3);
      expect(quote.verse, 16);
      expect(quote.index, 1);
      expect(quote.toJson(), {
        'book': 'John',
        'chapter': 3,
        'verse': 16,
        'index': 1,
      });
    });

    test('constructor sets all fields', () {
      final quote = BibleQuote(book: 'Genesis', chapter: 1, verse: 1);
      expect(quote.book, 'Genesis');
      expect(quote.chapter, 1);
      expect(quote.verse, 1);
      expect(quote.index, isNull);
    });
  });
}
