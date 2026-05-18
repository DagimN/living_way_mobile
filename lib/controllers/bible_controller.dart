import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/core/core.dart';

class BibleController extends ChangeNotifier {
  List<Book> bible = [];
  List<Translation> translations = [
    Translation(
        name: "NKJV",
        status: TranslationStatus.available,
        path: 'assets/data/en_nkjv.json',
        isDefault: true),
    Translation(
        name: "AM54",
        status: TranslationStatus.available,
        path: 'assets/data/am_am54.json',
        isDefault: true),
    Translation(
        name: "NASV",
        status: TranslationStatus.available,
        path: 'assets/data/am_nasv.json',
        isDefault: true),
    Translation(
        name: "NIV",
        status: TranslationStatus.available,
        path: 'assets/data/en_niv.json',
        isDefault: true)
  ];
  Translation translation = Translation(
      name: "NKJV",
      status: TranslationStatus.available,
      path: 'assets/data/en_nkjv.json',
      isDefault: true);

  Passage passage = Passage(book: Book.empty());
  Passage verseOfTheDay = Passage(book: Book.empty());

  BibleController() {
    loadTranslation(translations.first, isDefault: translations.first.isDefault)
        .then((value) {
      scheduleVersesOfTheDay();

      notifyListeners();
    });

    _initPersistence();
  }

  Future<void> _initPersistence() async {
    final data = await CacheService.instance
        .readData<String>('translations', defaultValue: '[]');
    final currentTranslation = await CacheService.instance.readData<String>(
        'currentTranslation',
        defaultValue: translation.toString());

    final list =
        (json.decode(data) as List).map((t) => Translation.fromMap(t)).toList();
    _populateTranslationList(list);

    fetchTranslations();

    translation = Translation.fromMap(json.decode(currentTranslation));
    loadTranslation(translation, isDefault: translation.isDefault)
        .then((value) => scheduleVersesOfTheDay());

    cleanResources(
        contentIds:
            translations.map((translation) => translation.name).toList(),
        path: '/translations');
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
          await saveTranslationFile('$name.json', json.encode(response.data));
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

  void scheduleVersesOfTheDay() async {
    //TODO: Improve randomization logic
    //BUG: Multile passages are being displayed on the same day
    for (int i = 0; i < 7; i++) {
      final notificationId = NotificationCodes.verseOfTheDay.extendedCode(i);
      await NotificationService.cancelNotification(notificationId);

      final currentDate = DateTime.now();
      final scheduledDate = DateTime(
          currentDate.year, currentDate.month, currentDate.day + i, 8, 0);
      final dailyVerse =
          dailyVerses[(scheduledDate.day + i) % dailyVerses.length];
      final passage = Passage(book: bible[dailyVerse.$1])
        ..chapter = dailyVerse.$2
        ..verse = dailyVerse.$3
        ..toVerse = dailyVerse.$4;
      passage.translation = translation;

      if (i == 0) {
        verseOfTheDay = passage;
      }

      await NotificationService.scheduleNotification(
          id: notificationId,
          title: 'Verse of the Day',
          body: '${passage.text} ${passage.labelWithTranslation}',
          scheduledDate: scheduledDate,
          payload: 'verseOfTheDay');
    }
  }

  set setTranslation(Translation v) {
    translation = v;
    loadTranslation(v, isDefault: v.isDefault)
        .then((value) => scheduleVersesOfTheDay());
    CacheService.instance.writeData<String>('currentTranslation', v.toString());
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
