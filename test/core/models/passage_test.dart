import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/book.dart';
import 'package:living_way/core/models/passage.dart';
import 'package:living_way/core/models/translation.dart';

void main() {
  late Book genesis;

  setUp(() {
    genesis = Book(
      index: 0,
      name: 'Genesis',
      chapters: [
        ['Verse 1', 'Verse 2', 'Verse 3'],
        ['Chapter 2 Verse 1'],
      ],
    );
  });

  group('Passage', () {
    test('text returns single verse', () {
      final passage = Passage(book: genesis)
        ..chapter = 0
        ..verse = 1;
      expect(passage.text, 'Verse 2');
    });

    test('text returns verse range', () {
      final passage = Passage(book: genesis)
        ..chapter = 0
        ..verse = 0
        ..toVerse = 2;
      expect(passage.text, 'Verse 1 Verse 2 Verse 3 ');
    });

    test('text returns empty for empty book', () {
      final passage = Passage(book: Book.empty());
      expect(passage.text, '');
    });

    test('label formats chapter and verse', () {
      final passage = Passage(book: genesis)
        ..chapter = 0
        ..verse = 1;
      expect(passage.label, 'Genesis 1:2');
    });

    test('label formats chapter only when verse is null', () {
      final passage = Passage(book: genesis)..chapter = 0;
      passage.verse = null;
      expect(passage.label, 'Genesis 1');
    });

    test('label formats verse range', () {
      final passage = Passage(book: genesis)
        ..chapter = 0
        ..verse = 0
        ..toVerse = 2;
      expect(passage.label, 'Genesis 1:1-2');
    });

    test('labelWithTranslation includes translation name', () {
      final passage = Passage(book: genesis)
        ..chapter = 0
        ..verse = 0
        ..translation = Translation(name: 'NKJV');
      expect(passage.labelWithTranslation, contains('NKJV'));
      expect(passage.labelWithTranslation, contains('Genesis 1:1'));
    });

    test('setting chapter resets verse', () {
      final passage = Passage(book: genesis)
        ..chapter = 0
        ..verse = 2;
      passage.chapter = 1;
      expect(passage.verse, 0);
    });

    test('verses returns chapter verses', () {
      final passage = Passage(book: genesis)..chapter = 0;
      expect(passage.verses, genesis.chapters[0]);
    });

    test('setVerseOfTheDay updates book and indices', () {
      final passage = Passage(book: Book.empty());
      passage.setVerseOfTheDay((genesis, 1, 0, null));
      expect(passage.book.name, 'Genesis');
      expect(passage.chapter, 1);
      expect(passage.verse, 0);
    });
  });
}
