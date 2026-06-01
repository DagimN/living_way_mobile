import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/core/core.dart';

class LocalizationController extends ChangeNotifier {
  late final LocalizationCache _cache;
  late final RemoteTranslationsLoader _loader;

  LocalizationController() {
    _cache = LocalizationCache();
    _loader = RemoteTranslationsLoader(getStrings: getStrings);
  }

  AppLocale appLocale = AppLocale.en;
  Locale _locale = const Locale('en', 'US');
  List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('am', 'ET')
  ];
  bool isInitialized = false;

  Locale get locale => _locale;
  RemoteTranslationsLoader get loader => _loader;

  Future<void> init() async {
    final appLocaleIndex = await CacheService.instance
        .readData<int>('locale', defaultValue: AppLocale.en.index);
    await fetchFromRemote(null);

    appLocale = AppLocale.values[appLocaleIndex];
    isInitialized = true;
    notifyListeners();

    _locale = appLocale == AppLocale.am
        ? const Locale('am', 'ET')
        : const Locale('en', "US");
    await _cache.init();

    preloadAll(supportedLocales);
  }

  /// Main entry point — returns translation strings for [locale].
  /// Strategy: cache-first, refresh in background if version changed.
  Future<Map<String, dynamic>> getStrings(Locale locale) async {
    try {
      final cached = _cache.getStrings(locale.languageCode);

      if (cached == null) {
        return await fetchFromRemote(locale);
      }

      return cached;
    } catch (e) {
      return await _loadBundledFallback(locale);
    }
  }

  Future<Map<String, dynamic>> _loadBundledFallback(Locale locale) async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/translations/${locale.languageCode}_${locale.countryCode}.json',
      );
      return Map<String, dynamic>.from(jsonDecode(jsonStr) as Map);
    } catch (error) {
      logger.e(error);
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchFromRemote(Locale? locale) async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      final response = await dio.get('$url/api/v1/locales',
          queryParameters: locale != null ? {'q': locale} : null);

      if (locale == null) {
        supportedLocales = List.from(response.data["locales"]).map((item) {
          final locale = item.split('_');

          return Locale(locale[0], locale[1]);
        }).toList();

        notifyListeners();
        return {};
      }

      final strings = Map<String, dynamic>.from(response.data);

      await _cache.save(locale.languageCode, strings);
      return strings;
    } catch (e) {
      logger.e('Failed to fetch translations: $e');
      return locale == null ? {} : await _loadBundledFallback(locale);
    }
  }

  void toggleAppLocale(BuildContext context) async {
    final currentIndex = supportedLocales.indexOf(_locale);
    final newLocale =
        supportedLocales[(currentIndex + 1) % supportedLocales.length];

    appLocale = AppLocale.fromLocale(newLocale);
    _locale = appLocale.locale;

    await context.setLocale(_locale);

    notifyListeners();
    CacheService.instance.writeData<int>('locale', appLocale.index);
  }

  Future<void> forceRefresh(BuildContext context) async {
    _locale = const Locale('en');
    await context.setLocale(_locale);

    await _cache.clear(_locale.languageCode);
    await fetchFromRemote(_locale);

    notifyListeners();
  }

  Future<void> preloadAll(List<Locale> locales) async {
    for (final locale in locales) {
      try {
        await fetchFromRemote(locale);
      } catch (e) {
        logger.e('Failed to preload ${locale.languageCode}: $e');
      }
    }
  }
}
