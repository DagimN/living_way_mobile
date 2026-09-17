class Book {
  int index;
  String name;
  List<List<String>> chapters;

  Book({required this.index, required this.name, required this.chapters});

  factory Book.empty() => Book(index: 0, name: '', chapters: []);

  factory Book.fromJson(Map<String, dynamic> json) {
    final chapters = (json['chapters'] as List)
        .map((chapter) =>
            (chapter as List).map((verse) => verse.toString()).toList())
        .toList();

    return Book(index: json['index'], name: json['name'], chapters: chapters);
  }
}
