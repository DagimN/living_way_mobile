import 'dart:convert';

import 'book.dart';
import 'translation.dart';

class Passage {
  Book book;
  Translation? translation;
  int? _chapter;
  int? _verse;
  int? _toVerse;

  Passage({required this.book});

  int get chapter => _chapter ?? 0;
  int get verse => _verse ?? 0;

  set chapter(int? value) {
    _chapter = value;
    _verse = 0;
  }

  set verse(int? value) {
    _verse = value;
  }

  set toVerse(int? value) {
    _toVerse = value;
  }

  void setVerseOfTheDay((Book, int, int, int?) value) {
    book = value.$1;
    _chapter = value.$2;
    _verse = value.$3;
    _toVerse = value.$4;
  }

  String get text {
    try {
      if (book.chapters.isNotEmpty) {
        if (_toVerse != null) {
          String text = '';

          for (int from = _verse ?? 0; from <= _toVerse!; from++) {
            text += '${book.chapters[_chapter ?? 0][from]} ';
          }

          return text;
        }

        return book.chapters[_chapter ?? 0][_verse ?? 0];
      }

      return '';
    } catch (error) {
      return '';
    }
  }

  String get label {
    final chapter = (_chapter ?? 0) + 1;
    final verse = (_verse ?? 0) + 1;

    if (_verse == null) {
      return '${book.name} $chapter';
    }

    if (_toVerse == null) {
      return '${book.name} $chapter:$verse';
    }

    return '${book.name} $chapter:$verse-$_toVerse';
  }

  String get labelWithTranslation {
    final chapter = (_chapter ?? 0) + 1;
    final verse = (_verse ?? 0) + 1;
    final toVerse = (_toVerse ?? 0) + 1;

    if (_toVerse == null) {
      return '${book.name} $chapter:$verse  ${translation?.name ?? ""}';
    }

    return '${book.name} $chapter:$verse-$toVerse  ${translation?.name ?? ""}';
  }

  List<String> get verses {
    return book.chapters.isEmpty ? [] : book.chapters[chapter];
  }

  factory Passage.fromMap(List<Book> bible, Map map) {
    final bookIndex = map['bookIndex'] as int;
    final passage = Passage(book: bible[bookIndex])
      ..chapter = map['chapter']
      ..verse = map['verse']
      ..toVerse = map['toVerse'];
    passage.translation = Translation.fromMap(map['translation']);

    return passage;
  }

  Map<String, dynamic> toMap() {
    return {
      "bookIndex": book.index,
      "translation": translation?.toMap(),
      "chapter": _chapter,
      "verse": _verse,
      "toVerse": _toVerse
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
