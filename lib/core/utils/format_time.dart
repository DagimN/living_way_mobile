import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/core/core.dart';

String formatDuration(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '$hours:${minutes > 9 ? minutes : '0$minutes'}:${remainingSeconds > 9 ? remainingSeconds : '0$remainingSeconds'}';
  }

  return '${minutes > 9 ? minutes : '0$minutes'}:${remainingSeconds > 9 ? remainingSeconds : '0$remainingSeconds'}';
}

String formatTime(TimeOfDay time, AppLocale locale) {
  int minute = time.minute;
  int hour = 12;

  if (locale == AppLocale.en) {
    if (hour > 12) {
      hour = hour - 12;
    }

    if (hour != 0 && hour <= 12) {
      hour = hour;
    }
  } else {
    if (hour > 12) {
      hour = (hour - 6) % 12;
    }

    if (hour != 0 && hour <= 12) {
      hour = (hour + 6) % 12;
    }

    if (hour == 6) {
      hour = 12;
    }
  }

  if (locale == AppLocale.en) {
    return '$hour:${minute < 10 ? '0$minute' : minute} ${time.period.name.toUpperCase()}';
  }

  if (locale == AppLocale.am) {
    return '$hour:${minute < 10 ? '0$minute' : minute}';
  }

  return '$hour:$minute';
}

String formatDateTime(DateTime timestamp) {
  final currentDate = DateTime.now();
  final isPast = timestamp.compareTo(currentDate) < 0;
  final timeDifference = isPast
      ? currentDate.difference(timestamp)
      : timestamp.difference(currentDate);
  final suffix = isPast ? Tr.t('ago') : Tr.t('left');

  if (timeDifference.inDays < 1) {
    final isPlural = timeDifference.inHours > 1;

    return timeDifference.inHours == 0
        ? '${Tr.t('hourLeft')} $suffix'
        : '${timeDifference.inHours} ${Tr.t('hour${isPlural ? 's' : ''}')} $suffix';
  }

  if (timeDifference.inDays <= 7) {
    final isPlural = timeDifference.inDays > 1;

    return timeDifference.inDays == 7
        ? '${Tr.t('oneWeek')} $suffix'
        : '${timeDifference.inDays} ${Tr.t('day${isPlural ? 's' : ''}')} $suffix';
  }

  if (timeDifference.inDays > 7) {
    return timeDifference.inDays > 365
        ? DateFormat.yMMMMd().format(timestamp)
        : DateFormat('MMM d').format(timestamp);
  }

  return '';
}
