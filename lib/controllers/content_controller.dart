import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/constants/content.dart' as content;
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/models/book.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/translation.dart';
import 'package:living_way/utils/load_json.dart';

class ContentController extends ChangeNotifier {
  final TextEditingController commentBoxTextEditingController =
      TextEditingController();
  ActivityFilter topicActivityFilter = ActivityFilter.latest;
  ActivityFilter threadActivityFilter = ActivityFilter.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];
  List<ThreadData> threads = content.threads;
  ValueNotifier<GlobalKey?> commentingThreadKeyNotifier = ValueNotifier(null);
  List<Book> bible = [];
  List<Translation> translations = [
    Translation(name: "KJV", isAvailabe: true),
    Translation(name: "NKJV", downloadUrl: ""),
    Translation(name: "ASV"),
    Translation(name: "NASB")
  ];
  List<ActivityContent> activityList = [
    ActivityContent(
        isOngoing: true,
        type: ContentType.article,
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ActivityContent(
        type: ContentType.article,
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ActivityContent(
        type: ContentType.article,
        timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ActivityContent(
        type: ContentType.external,
        timestamp: DateTime.now().add(const Duration(hours: 1))),
    ActivityContent(
        type: ContentType.gallery,
        timestamp: DateTime.now().add(const Duration(days: 1))),
    ActivityContent(
        type: ContentType.poll,
        timestamp: DateTime.now().add(const Duration(days: 2))),
    ActivityContent(
        type: ContentType.poll,
        timestamp: DateTime.now().add(const Duration(days: 8))),
    ActivityContent(
        type: ContentType.poll,
        timestamp: DateTime.now().add(const Duration(days: 12))),
    ActivityContent(
        type: ContentType.poll,
        timestamp: DateTime.now().add(const Duration(days: 720)))
  ];

  Book? book;
  int? chapter;
  int? verse;
  Translation? translation;

  ContentController() {
    loadJson('assets/data/en_kjv.json').then((data) {
      bible = (data as List)
          .map((e) => Book(
              name: e['name'],
              chapters: (e['chapters'] as List)
                  .map((chapter) => (chapter as List)
                      .map((verse) => verse.toString())
                      .toList())
                  .toList()))
          .toList();
      notifyListeners();
    });
  }

  set setActivityFilter(ActivityFilter value) {
    topicActivityFilter = value;
    notifyListeners();
  }

  set setThreadFilter(ActivityFilter value) {
    threadActivityFilter = value;
    notifyListeners();
  }

  set setCategoryFilter(CategoryFilter value) {
    categoryFilter = value;
    notifyListeners();
  }

  set setBooksFilter(List<String> books) {
    booksFiltered = books;
    notifyListeners();
  }

  set setCommentingThreadKey(GlobalKey? value) {
    commentingThreadKeyNotifier.value = value;
    notifyListeners();
  }

  set setTranslation(Translation value) {
    translation = value;
    notifyListeners();
  }

  set setBook(Book value) {
    book = value;
    notifyListeners();
  }

  set setChapter(int? value) {
    chapter = value;
    notifyListeners();
  }

  set setVerse(int? value) {
    verse = value;
    notifyListeners();
  }
}

enum ActivityFilter { mostActive, mostLiked, mostViewed, latest }

enum CategoryFilter { all, ot, nt }
