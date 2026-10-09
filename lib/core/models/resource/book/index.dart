import 'package:hive/hive.dart';

part 'index.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 11)
class Book {
  @HiveField(0)
  int index;

  @HiveField(1)
  String name;

  @HiveField(2)
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
