import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/enums.dart';
import 'package:living_way/core/utils/format_time.dart';

void main() {
  group('formatDuration', () {
    test('formats seconds only', () {
      expect(formatDuration(45), '00:45');
      expect(formatDuration(5), '00:05');
    });

    test('formats minutes and seconds', () {
      expect(formatDuration(125), '02:05');
      expect(formatDuration(600), '10:00');
    });

    test('formats hours minutes and seconds', () {
      expect(formatDuration(3661), '1:01:01');
      expect(formatDuration(3600), '1:00:00');
    });

    test('pads single digit minutes in hour format', () {
      expect(formatDuration(3605), '1:00:05');
    });
  });

  group('formatTime', () {
    test('formats English AM time', () {
      final time = const TimeOfDay(hour: 9, minute: 5);
      expect(formatTime(time, AppLocale.en), '9:05 AM');
    });

    test('formats English PM time', () {
      final time = const TimeOfDay(hour: 15, minute: 30);
      expect(formatTime(time, AppLocale.en), '3:30 PM');
    });

    test('formats midnight as 12 AM in English', () {
      final time = const TimeOfDay(hour: 0, minute: 0);
      expect(formatTime(time, AppLocale.en), '12:00 AM');
    });

    test('formats noon as 12 PM in English', () {
      final time = const TimeOfDay(hour: 12, minute: 0);
      expect(formatTime(time, AppLocale.en), '12:00 PM');
    });

    test('formats Amharic locale without period', () {
      final time = const TimeOfDay(hour: 9, minute: 5);
      expect(formatTime(time, AppLocale.am), '3:05');
    });

    test('formats Amharic afternoon time', () {
      final time = const TimeOfDay(hour: 15, minute: 30);
      expect(formatTime(time, AppLocale.am), '9:30');
    });

    test('formats Amharic 6 AM as 12', () {
      final time = const TimeOfDay(hour: 6, minute: 0);
      expect(formatTime(time, AppLocale.am), '12:00');
    });
  });

  group('formatDateTime', () {
    test('returns less than an hour for recent timestamps', () {
      final now = DateTime.now();
      final thirtyMinutesAgo = now.subtract(const Duration(minutes: 30));
      expect(formatDateTime(thirtyMinutesAgo), 'Less than an hour ago');
    });

    test('returns hours ago for past timestamps within a day', () {
      final now = DateTime.now();
      final twoHoursAgo = now.subtract(const Duration(hours: 2));
      expect(formatDateTime(twoHoursAgo), '2 hrs ago');
    });

    test('returns singular hour', () {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      expect(formatDateTime(oneHourAgo), '1 hr ago');
    });

    test('returns days ago within a week', () {
      final now = DateTime.now();
      final threeDaysAgo = now.subtract(const Duration(days: 3));
      expect(formatDateTime(threeDaysAgo), '3 days ago');
    });

    test('returns 1 week ago for exactly 7 days', () {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      expect(formatDateTime(sevenDaysAgo), '1 week ago');
    });

    test('returns future time left suffix', () {
      final now = DateTime.now();
      final inThreeHours = now.add(const Duration(hours: 3, minutes: 5));
      final result = formatDateTime(inThreeHours);
      expect(result, contains('left'));
      expect(result, contains('hr'));
    });
  });
}
