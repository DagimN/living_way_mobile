import 'dart:convert';

import 'package:hive/hive.dart';

import '../../classes/cacheable.dart';

part 'index.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 0)
class Notification extends HiveObject implements Cacheable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final String? payload;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.imageUrl,
    DateTime? createdAt,
    bool? isRead,
  })  : createdAt = createdAt ?? DateTime.now(),
        isRead = false;

  @override
  String get cacheKey => id;

  Notification copyWith({
    String? id,
    String? title,
    String? body,
    String? payload,
    String? imageUrl,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      payload: map['payload'] as String?,
      imageUrl: map['imageUrl'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      isRead: map['isRead'] as bool,
    );
  }

  @override
  String toString() => jsonEncode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Notification && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
