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
        id: '1',
        isOngoing: true,
        type: ContentType.event,
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ActivityContent(
        id: '2',
        type: ContentType.article,
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ActivityContent(
        id: '3',
        type: ContentType.article,
        timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ActivityContent(
        id: '4',
        type: ContentType.external,
        timestamp: DateTime.now().add(const Duration(hours: 1))),
    ActivityContent(
        id: '5',
        type: ContentType.gallery,
        timestamp: DateTime.now().add(const Duration(days: 1))),
    ActivityContent(
        id: '6',
        type: ContentType.poll,
        title: 'When will you be available?',
        pollOptions: [
          PollOptions(title: '10:00 AM', votes: 28),
          PollOptions(title: '10:30 AM', votes: 8),
          PollOptions(title: '11:00 AM', votes: 40),
          PollOptions(title: '12:00 PM', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 2))),
    ActivityContent(
        id: '7',
        type: ContentType.poll,
        title: 'What shall we study?',
        pollOptions: [
          PollOptions(title: 'Daniel', votes: 28),
          PollOptions(title: 'Hosea', votes: 8),
          PollOptions(title: 'Amos', votes: 40),
          PollOptions(title: 'Micah', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 8))),
    ActivityContent(
        id: '8',
        type: ContentType.poll,
        title: "How old are you?",
        pollOptions: [
          PollOptions(title: 'less than 18', votes: 28),
          PollOptions(title: '18 - 30', votes: 8),
          PollOptions(title: '31 - 50', votes: 40),
          PollOptions(title: '51 +', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 12))),
    ActivityContent(
        id: '9',
        type: ContentType.event,
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
