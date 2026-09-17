import 'dart:convert';

import 'package:living_way/core/core.dart';

class Devotion {
  final String topic;
  final String description;
  final DateTime publishedAt;
  final List<DevotionItem> items;

  Devotion(
      {required this.topic,
      required this.description,
      required this.publishedAt,
      required this.items});

  factory Devotion.fromJson(Map<String, dynamic> json) {
    return Devotion(
        topic: json['topic'],
        description: json['description'],
        publishedAt: DateTime.parse(json['publishedAt']),
        items: List.from(json['items'] ?? [])
            .map((item) => DevotionItem.fromJson(item))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "topic": topic,
      "description": description,
      "publishedAt": publishedAt.toIso8601String(),
      "items": items.map((item) => item.toJson())
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class DevotionItem {
  final String title;
  final String subTitle;
  final Passage passage;
  final DateTime
      assignedDate; //TODO: Implement spoiler filter to not show all the items at once
  final bool isCompleted;

  DevotionItem(
      {required this.title,
      required this.subTitle,
      required this.passage,
      required this.assignedDate,
      this.isCompleted = false});

  factory DevotionItem.fromJson(json) {
    return DevotionItem(
        title: json['title'],
        subTitle: json['subTitle'],
        passage: Passage.fromMap(
            null, json['passage']), //TODO: Load the book when available
        assignedDate: DateTime.parse(json['assignedDate']),
        isCompleted: json['isCompleted'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subTitle": subTitle,
      "passage": passage.toMap(),
      "assignedDate": assignedDate.toIso8601String(),
      "isCompleted": isCompleted
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
