import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/core/constants/urls.dart';
import 'package:living_way/core/models/book.dart';
import 'package:living_way/core/models/translation.dart';
import 'package:living_way/core/services/logging_service.dart';
import 'package:living_way/core/utils/storage_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleController extends ChangeNotifier {
  List<Book> bible = [];
  List<Translation> translations = [
    Translation(
        name: "KJV",
        status: TranslationStatus.available,
        path: 'assets/data/en_kjv.json',
        isDefault: true),
    Translation(
        name: "AM54",
        status: TranslationStatus.available,
        path: 'assets/data/am_nasb.json',
        isDefault: true)
  ];

  Book? book;
  int? chapter;
  int? verse;
  Translation? translation;
  SharedPreferences? sharedPreferences;

  BibleController() {
    loadTranslation(translations.first,
        isDefault: translations.first.isDefault);
    _initPersistence();
  }

  Future<void> _initPersistence() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final data = sharedPreferences?.getString('translations');
    if (data != null) {
      final list = (json.decode(data) as List)
          .map((t) => Translation.fromMap(t))
          .toList();
      _populateTranslationList(list);
    }
    fetchTranslations();
  }

  void _populateTranslationList(List<Translation> incomingTranslations) {
    for (final translation in incomingTranslations) {
      final index = translations
          .indexWhere((translation) => translation.name == translation.name);

      if (index != -1 &&
          translations[index].status != TranslationStatus.available) {
        translations[index] = translation;
      }

      if (index == -1) {
        translations.add(translation);
      }
    }

    notifyListeners();
  }

  Future<void> fetchTranslations() async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.get('$url/api/v1/content/bible');
      final list = (response.data['translations'] as List)
          .map((t) => Translation.fromMap(t))
          .toList();

      _populateTranslationList(list);

      sharedPreferences?.setString(
          'translations',
          json.encode(
              translations.map((translation) => translation.toMap()).toList()));
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
    }
  }

  Future<void> downloadTranslation(String name) async {
    final dio = Dio();
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio
          .get('$url/api/v1/content/bible', queryParameters: {"name": name});
      final index =
          translations.indexWhere((translation) => translation.name == name);
      final filePath =
          await writeFile('$name.json', json.encode(response.data));
      final updatedTranslation = Translation(
          name: name, path: filePath, status: TranslationStatus.available);

      translation = updatedTranslation;
      translations[index] = updatedTranslation;

      loadTranslation(updatedTranslation,
          isDefault: updatedTranslation.isDefault);
      sharedPreferences?.setString(
          'translations',
          json.encode(
              translations.map((translation) => translation.toMap()).toList()));

      notifyListeners();
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
    }
  }

  Future<void> loadTranslation(Translation t, {bool isDefault = false}) async {
    List data = isDefault
        ? await loadJson(t.path!)
        : json.decode((await readFile(t.path ?? "")) ?? "[]");
    bible = data
        .map((e) => Book(
            name: e['name'],
            chapters: (e['chapters'] as List)
                .map((c) => (c as List).map((v) => v.toString()).toList())
                .toList()))
        .toList();
    notifyListeners();
  }

  set setTranslation(Translation v) {
    translation = v;
    loadTranslation(v, isDefault: v.isDefault);
    notifyListeners();
  }

  set setBook(Book v) {
    book = v;
    notifyListeners();
  }

  set setChapter(int? v) {
    chapter = v;
    notifyListeners();
  }

  set setVerse(int? v) {
    verse = v;
    notifyListeners();
  }
}
