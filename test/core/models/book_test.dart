import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/book.dart';

void main() {
  group('Book', () {
    test('fromJson parses book with chapters', () {
      final json = {
        'index': 0,
        'name': 'Genesis',
        'chapters': [
          ['In the beginning', 'And the earth was'],
          ['Let there be light'],
        ],
      };
      final book = Book.fromJson(json);
      expect(book.index, 0);
      expect(book.name, 'Genesis');
      expect(book.chapters, hasLength(2));
      expect(book.chapters[0], ['In the beginning', 'And the earth was']);
    });

    test('empty factory creates empty book', () {
      final book = Book.empty();
      expect(book.index, 0);
      expect(book.name, '');
      expect(book.chapters, isEmpty);
    });
  });
}
