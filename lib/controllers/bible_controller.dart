import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/core/core.dart';

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
  Translation translation = Translation(
      name: "KJV",
      status: TranslationStatus.available,
      path: 'assets/data/en_kjv.json',
      isDefault: true);

  Passage passage = Passage(book: Book.empty());
  Passage verseOfTheDay = Passage(book: Book.empty());

  BibleController() {
    loadTranslation(translations.first, isDefault: translations.first.isDefault)
        .then((value) {
      final todaysDailyVerse = dailyVerses[Random()
          .nextInt(dailyVerses.length - 1)]; //TODO: Send a push notification

      verseOfTheDay.setVerseOfTheDay((
        bible[todaysDailyVerse.$1],
        todaysDailyVerse.$2,
        todaysDailyVerse.$3,
        todaysDailyVerse.$4
      ));
      verseOfTheDay.translation = translation;
      notifyListeners();
    });

    _initPersistence();
  }

  Future<void> _initPersistence() async {
    final data = await CacheService.instance
        .readData<String>('translations', defaultValue: '[]');
    final list =
        (json.decode(data) as List).map((t) => Translation.fromMap(t)).toList();
    _populateTranslationList(list);

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

      await CacheService.instance.writeData(
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
      await CacheService.instance.writeData(
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

  Future<void> loadTranslation(Translation translation,
      {bool isDefault = false}) async {
    List data = isDefault
        ? await loadJson(translation.path!)
        : json.decode((await readFile(translation.path ?? "")) ?? "[]");
    bible = data.indexed
        .map((book) => Book.fromJson({...book.$2, 'index': book.$1}))
        .toList();

    passage.book = bible[passage.book.index];
    verseOfTheDay.book = bible[verseOfTheDay.book.index];
    passage.translation = translation;
    verseOfTheDay.translation;
    notifyListeners();
  }

  set setTranslation(Translation v) {
    translation = v;
    loadTranslation(v, isDefault: v.isDefault);
    //TODO: Save translation to cache
    notifyListeners();
  }

  set setBook(Book value) {
    passage.book = value;
    notifyListeners();
  }

  set setChapter(int? v) {
    passage.chapter = v;
    notifyListeners();
  }

  set setVerse(int? v) {
    passage.verse = v;
    notifyListeners();
  }

  set setPassage(Passage value) {
    passage = value;
    notifyListeners();
  }
}
