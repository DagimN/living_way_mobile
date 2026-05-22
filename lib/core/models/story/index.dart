import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../classes/cacheable.dart';
import '../../services/logging_service.dart';

part 'index.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 1)
class Story extends HiveObject implements Cacheable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sourceUrl;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  bool isViewed = false;
  File? file;

  Story({
    required this.id,
    required this.sourceUrl,
    required this.timestamp,
    this.file,
  }) {
    _loadStory();
  }

  @override
  String get cacheKey => id;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
        id: json['_id'],
        sourceUrl: json['sourceUrl'],
        timestamp: DateTime.parse(json['createdAt']));
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
