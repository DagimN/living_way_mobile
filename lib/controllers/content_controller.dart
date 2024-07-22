import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/constants/content.dart' as content;
import 'package:living_way/models/thread.dart';

class ContentController extends ChangeNotifier {
  final TextEditingController commentBoxTextEditingController =
      TextEditingController();
  ActivityFilter topicActivityFilter = ActivityFilter.latest;
  ActivityFilter threadActivityFilter = ActivityFilter.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];
  List<ThreadData> threads = content.threads;
  ValueNotifier<GlobalKey?> commentingThreadKeyNotifier = ValueNotifier(null);

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
}

enum ActivityFilter { mostActive, mostLiked, mostViewed, latest }

enum CategoryFilter { all, ot, nt }
