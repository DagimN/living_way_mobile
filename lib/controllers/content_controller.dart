import 'package:flutter/material.dart';

class ContentController extends ChangeNotifier {
  ActivityFilter? activityFilter;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];

  set setActivityFilter(ActivityFilter? value) {
    activityFilter = value;
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
}

enum ActivityFilter { mostActive, mostLiked, mostViewed }

enum CategoryFilter { all, ot, nt }
