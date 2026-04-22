import 'dart:io';

class Story {
  final String id;
  final String sourceUrl;
  final DateTime timestamnp;
  bool isViewed = false;
  File? file;

  Story({
    required this.id,
    required this.sourceUrl,
    required this.timestamnp,
    this.file,
  });
}
