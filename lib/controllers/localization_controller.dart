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
  List<Locale> supportedLocales = const [
    Locale('en', 'US'),
    Locale('am', 'ET')
  ];

  Locale get locale => _locale;
  RemoteTranslationsLoader get loader => _loader;

  Future<void> init() async {
    final appLocaleIndex = await CacheService.instance
        .readData<int>('locale', defaultValue: AppLocale.en.index);
    appLocale = AppLocale.values[appLocaleIndex];
    notifyListeners();

    _locale = appLocale == AppLocale.en
        ? const Locale('en', 'US')
        : const Locale('am', "ET");
    await _cache.init();

    preloadAll(supportedLocales);
  }

  /// Main entry point — returns translation strings for [locale].
  /// Strategy: cache-first, refresh in background if version changed.
  Future<Map<String, dynamic>> getStrings(Locale locale) async {
    try {
      final cached = _cache.getStrings(locale.languageCode);

      if (cached == null) {
        return await _fetchFromRemote(locale.languageCode);
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

  Future<Map<String, dynamic>> _fetchFromRemote(String locale) async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    final response = await dio.get(
      '$url/api/v1/locales/$locale',
    );

    final strings = Map<String, dynamic>.from(
      response.data['strings'] as Map,
    );

    await _cache.save(locale, strings);
    return strings;
  }

  void toggleAppLocale(BuildContext context) async {
    if (appLocale == AppLocale.am) {
      appLocale = AppLocale.en;
      _locale = const Locale('en', 'US');
    } else {
      appLocale = AppLocale.am;
      _locale = const Locale('am', 'ET');
    }

    await context.setLocale(_locale);

    notifyListeners();
    CacheService.instance.writeData<int>('locale', appLocale.index);
  }

  Future<void> forceRefresh(BuildContext context) async {
    _locale = const Locale('en');
    await context.setLocale(_locale);

    await _cache.clear(_locale.languageCode);
    await _fetchFromRemote(_locale.languageCode);

    notifyListeners();
  }

  Future<void> preloadAll(List<Locale> locales) async {
    for (final locale in locales) {
      try {
        await _fetchFromRemote(locale.languageCode);
      } catch (e) {
        logger.e('Failed to preload ${locale.languageCode}: $e');
      }
    }
  }
}
