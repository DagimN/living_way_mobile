String formatDuration(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '$hours:${minutes > 9 ? minutes : '0$minutes'}:${remainingSeconds > 9 ? remainingSeconds : '0$remainingSeconds'}';
  }

  return '${minutes > 9 ? minutes : '0$minutes'}:${remainingSeconds > 9 ? remainingSeconds : '0$remainingSeconds'}';
}
