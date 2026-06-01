import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ── User ──────────────────────────────────────────────
  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  static Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // ── Auth ──────────────────────────────────────────────
  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // ── Bible ─────────────────────────────────────────────
  static Future<void> logChapterOpened(String book, int chapter) async {
    await _analytics.logEvent(
      name: 'chapter_opened',
      parameters: {'book': book, 'chapter': chapter},
    );
  }

  // ── Language ──────────────────────────────────────────
  static Future<void> logLanguageChanged(String from, String to) async {
    await _analytics.logEvent(
      name: 'language_changed',
      parameters: {'from': from, 'to': to},
    );
  }

  static Future<void> logEvent(String name,
      {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
