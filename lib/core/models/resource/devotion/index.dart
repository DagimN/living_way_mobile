import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../classes/cacheable.dart';
import 'devotion_item.dart';

part 'index.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 6)
class Devotion extends HiveObject implements Cacheable {
  @HiveField(0)
  final int index;

  @HiveField(1)
  final String topic;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> tags;

  @HiveField(4)
  final List<DevotionItem> items;

  Devotion(
      {required this.index,
      required this.topic,
      required this.description,
      required this.items,
      this.tags = const []});

  @override
  String get cacheKey => index.toString();

  factory Devotion.fromJson(Map<String, dynamic> json) {
    return Devotion(
        index: json['index'],
        topic: json['topic'],
        description: json['description'],
        tags:
            List.from(json['tags'] ?? []).map((tag) => tag.toString()).toList(),
        items: List.from(json['items'] ?? [])
            .map((item) => DevotionItem.fromJson(item))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "topic": topic,
      "description": description,
      "tags": tags,
      "items": items.map((item) => item.toJson())
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
