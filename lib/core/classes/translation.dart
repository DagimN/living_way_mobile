import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Central utility for all translation needs.
/// Import this file wherever you need translations.
class Tr {
  Tr._(); // prevent instantiation

  // ─────────────────────────────────────────────
  // 1. Simple key translation
  //    Usage: Tr.t('app.title')
  // ─────────────────────────────────────────────
  static String t(String key) => key.tr();

  // ─────────────────────────────────────────────
  // 2. Positional argument  →  replaces {}
  //    JSON:  "welcome": "Welcome, {}!"
  //    Usage: Tr.arg('app.welcome', 'Sara')
  //    Output: "Welcome, Sara!"
  // ─────────────────────────────────────────────
  static String arg(String key, String value) => key.tr(args: [value]);

  // ─────────────────────────────────────────────
  // 3. Multiple positional arguments  →  replaces {} in order
  //    JSON:  "profile.bio": "{name} has {count} followers"
  //           (using positional here, not named)
  //    Usage: Tr.args('app.profile.bio', ['Sara', '120'])
  //    Output: "Sara has 120 followers"
  // ─────────────────────────────────────────────
  static String args(String key, List<String> values) => key.tr(args: values);

  // ─────────────────────────────────────────────
  // 4. Named arguments  →  replaces {name}, {count}, etc.
  //    JSON:  "greeting": "Hello, {name}!"
  //    Usage: Tr.named('app.greeting', {'name': 'Sara'})
  //    Output: "Hello, Sara!"
  // ─────────────────────────────────────────────
  static String named(String key, Map<String, String> namedArgs) =>
      key.tr(namedArgs: namedArgs);

  // ─────────────────────────────────────────────
  // 5. Pluralization  →  picks zero/one/other form
  //    JSON:  "items_count": { "zero": "No items",
  //                            "one":  "1 item",
  //                            "other": "{} items" }
  //    Usage: Tr.plural('app.items_count', 5)
  //    Output: "5 items"
  // ─────────────────────────────────────────────
  static String plural(String key, num count) => key.plural(count);

  // ─────────────────────────────────────────────
  // 6. Pluralization with extra named args
  //    JSON:  "messages": { "one": "You have 1 message from {sender}",
  //                         "other": "You have {} messages from {sender}" }
  //    Usage: Tr.pluralNamed('messages', 3, {'sender': 'Abebe'})
  //    Output: "You have 3 messages from Abebe"
  // ─────────────────────────────────────────────
  static String pluralNamed(
    String key,
    num count,
    Map<String, String> namedArgs,
  ) =>
      key.plural(count, namedArgs: namedArgs);

  // ─────────────────────────────────────────────
  // 7. Gender-aware translation
  //    JSON:  "role": { "male": "He is an admin",
  //                     "female": "She is an admin" }
  //    Usage: Tr.gender('role', isMale: true)
  // ─────────────────────────────────────────────
  static String gender(String key, {required bool isMale}) =>
      key.tr(gender: isMale ? 'male' : 'female');

  // ─────────────────────────────────────────────
  // 8. Locale switching
  //    Usage: Tr.setLocale(context, 'am')
  // ─────────────────────────────────────────────
  static Future<void> setLocale(
          BuildContext context, String langCode, String countryCode) =>
      context.setLocale(Locale(langCode, countryCode));

  // ─────────────────────────────────────────────
  // 9. Current locale code
  //    Usage: Tr.currentLocale(context)  →  'en'
  // ─────────────────────────────────────────────
  static String currentLocale(BuildContext context) =>
      context.locale.languageCode;

  // ─────────────────────────────────────────────
  // 10. Safe translate — returns fallback string if key is missing
  //     instead of showing the raw key in production
  //     Usage: Tr.safe('some.key', fallback: 'Default text')
  // ─────────────────────────────────────────────
  static String safe(String key, {required String fallback}) {
    final result = key.tr();
    // easy_localization returns the key itself when missing
    return result == key ? fallback : result;
  }
}
