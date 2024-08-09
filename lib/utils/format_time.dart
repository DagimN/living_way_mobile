import 'package:intl/intl.dart';

String formatDuration(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '$hours:${minutes > 9 ? minutes : '0$minutes'}:${remainingSeconds > 9 ? remainingSeconds : '0$remainingSeconds'}';
  }

  return '${minutes > 9 ? minutes : '0$minutes'}:${remainingSeconds > 9 ? remainingSeconds : '0$remainingSeconds'}';
}

String formatDateTime(DateTime timestamp) {
  final currentDate = DateTime.now();
  final isPast = timestamp.compareTo(currentDate) < 0;
  final timeDifference = isPast
      ? currentDate.difference(timestamp)
      : timestamp.difference(currentDate);
  final suffix = isPast ? 'ago' : 'left';

  if (timeDifference.inDays < 1) {
    final isPlural = timeDifference.inHours > 1;

    return timeDifference.inHours == 0
        ? 'Less than an hour $suffix'
        : '${timeDifference.inHours} hr${isPlural ? 's' : ''} $suffix';
  }

  if (timeDifference.inDays <= 7) {
    final isPlural = timeDifference.inDays > 1;

    return timeDifference.inDays == 7
        ? '1 week $suffix'
        : '${timeDifference.inDays} day${isPlural ? 's' : ''} $suffix';
  }

  if (timeDifference.inDays > 7) {
    return timeDifference.inDays > 365
        ? DateFormat.yMMMMd().format(timestamp)
        : DateFormat('MMM d').format(timestamp);
  }

  return '';
}
