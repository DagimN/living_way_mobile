extension DateTimeExtension on DateTime {
  int get dateInNumbers {
    String year = this.year.toString().replaceAll('20', '');

    return int.parse('$year$month$day$hour');
  }

  String get weekdayShort {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (weekday >= 1 && weekday <= 7) {
      return days[weekday - 1];
    }
    return '';
  }

  List<DateTime> get weekDays {
    final startOfToday = DateTime(year, month, day);
    final monday =
        startOfToday.subtract(Duration(days: startOfToday.weekday - 1));

    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }
}
