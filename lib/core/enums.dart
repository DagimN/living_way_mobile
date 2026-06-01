import 'package:flutter/material.dart';

enum SortOptions { mostActive, mostLiked, mostViewed, latest }

enum CategoryFilter { all, ot, nt }

enum AppLocale {
  en('en', 'US', 'EN'),
  am('am', 'ET', 'አማ'),
  om('om', 'ET', 'ORM'),
  ti('ti', 'ET', 'TIG'),
  so('so', 'ET', 'SOM'),
  sid('sid', 'ET', 'SID'),
  wal('wal', 'ET', 'WOL'),
  afar('afar', 'ET', 'AFAR'),
  gur('gur', 'ET', 'GUR');

  final String languageCode;
  final String countryCode;
  final String label;

  const AppLocale(this.languageCode, this.countryCode, this.label);

  Locale get locale => Locale(languageCode, countryCode);

  static AppLocale fromLocale(Locale locale) {
    return values.firstWhere(
      (e) => e.languageCode == locale.languageCode,
      orElse: () => AppLocale.en,
    );
  }

  static String shortLabel(Locale locale) {
    return fromLocale(locale).label;
  }
}

// ignore: constant_identifier_names
enum Fonts { Futura, Georgia, Helvetica, OpenSans, Quicksand, RobotoSlab }

enum FileType {
  // --- Documents ---
  pdf,
  doc,
  docx,
  txt,

  // --- Images ---
  png,
  jpg,
  jpeg,
  gif,
  webp,
  svg,

  // --- Video ---
  mp4,
  mov,
  avi,
  mkv,
  webm,

  // --- Audio ---
  mp3,
  wav,
  m4a,
  aac,
  ogg,

  undefined;

  static FileType fromString(String value) {
    final cleaned = value.replaceFirst('.', '').trim().toLowerCase();

    switch (cleaned) {
      // Documents
      case 'pdf':
        return pdf;
      case 'doc':
        return doc;
      case 'docx':
        return docx;
      case 'txt':
        return txt;

      // Images
      case 'png':
        return png;
      case 'jpg':
        return jpg;
      case 'jpeg':
        return jpeg;
      case 'gif':
        return gif;
      case 'webp':
        return webp;
      case 'svg':
        return svg;

      // Videos
      case 'mp4':
        return mp4;
      case 'mov':
        return mov;
      case 'avi':
        return avi;
      case 'mkv':
        return mkv;
      case 'webm':
        return webm;

      // Audio
      case 'mp3':
        return mp3;
      case 'wav':
        return wav;
      case 'm4a':
        return m4a;
      case 'aac':
        return aac;
      case 'ogg':
        return ogg;

      default:
        return undefined;
    }
  }

  bool get isVideo => const [mp4, mov, avi, mkv, webm].contains(this);
  bool get isImage => const [png, jpg, jpeg, gif, webp, svg].contains(this);
  bool get isAudio => const [mp3, wav, m4a, aac, ogg].contains(this);
  bool get isDocument => const [pdf, doc, docx, txt].contains(this);
}

enum NotificationCodes {
  verseOfTheDay,
  activity,
  recurring,
  download,
  general,
  prayer;

  int get value {
    switch (this) {
      case verseOfTheDay:
        return 1;
      case activity:
        return 2;
      case recurring:
        return 3;
      case download:
        return 4;
      case general:
        return 5;
      case prayer:
        return 6;
    }
  }

  int extendedCode(int index) {
    return int.parse('$value$index');
  }
}
