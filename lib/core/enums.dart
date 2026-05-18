enum SortOptions { mostActive, mostLiked, mostViewed, latest }

enum CategoryFilter { all, ot, nt }

enum AppLocale { en, am }

// ignore: constant_identifier_names
enum Fonts { Futura, Georgia, Helvetica, OpenSans, Quicksand, RobotoSlab }

enum FileType {
  pdf,
  mp4,
  png,
  jpg,
  undefined;

  static fromString(String value) {
    switch (value) {
      case 'pdf':
        return pdf;
      case 'mp4':
        return mp4;
      case 'png':
        return png;
      case 'jpg':
        return jpg;
      default:
        return undefined;
    }
  }
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
