import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../services/logging_service.dart';

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
  }) {
    _loadStory();
  }

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
        id: json['_id'],
        sourceUrl: json['sourceUrl'],
        timestamnp: DateTime.parse(json['createdAt']));
  }

  Future<void> _loadStory() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final Directory directory = Directory('${tempDir.path}/stories');

      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      final file = File('${tempDir.path}/stories/$id.mp4');

      if (!file.existsSync()) {
        final response = await http.get(Uri.parse(sourceUrl));
        await file.writeAsBytes(response.bodyBytes);
      }

      this.file = file;
    } catch (error) {
      logger.e('$error - on story item $id');
    }
  }
}
