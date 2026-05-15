extension DateTimeExtension on DateTime {
  int get dateInNumbers {
    String year = this.year.toString().replaceAll('20', '');

    return int.parse('$year$month$day$hour');
  }
}
