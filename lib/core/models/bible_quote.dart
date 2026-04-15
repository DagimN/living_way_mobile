class BibleQuote {
  String book;
  int chapter;
  int verse;
  int? index;

  BibleQuote(
      {required this.book,
      required this.chapter,
      required this.verse,
      this.index});

  static BibleQuote fromJson(json) {
    return BibleQuote(
        book: json['book'],
        chapter: json['int'],
        verse: json['verse'],
        index: json['index']);
  }

  Map<String, dynamic> toJson() {
    return {
      "book": book,
      "chapter": chapter,
      "verse": verse,
      "index": index
    };
  }
}
