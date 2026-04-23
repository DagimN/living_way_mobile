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
