import 'dart:convert';

import 'package:hive/hive.dart';

part 'index.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 9)
class Translation {
  @HiveField(0)
  String name;

  @HiveField(1)
  TranslationStatus status;

  @HiveField(2)
  String? path;

  @HiveField(3)
  bool isDefault;

  Translation(
      {required this.name,
      this.status = TranslationStatus.undefined,
      this.path,
      this.isDefault = false});

  factory Translation.standard() => Translation(
      name: "NKJV",
      status: TranslationStatus.available,
      path: 'assets/data/en_nkjv.json',
      isDefault: true);

  static Translation? fromMap(json) {
    if (json == null) return null;

    return Translation(
        name: json['name'],
        path: json['path'],
        status: TranslationStatus.fromString(json['status']),
        isDefault: json['isDefault'] ?? false);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "path": path,
      "status": status.name,
      "isDefault": isDefault
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

@HiveType(typeId: 10)
enum TranslationStatus {
  @HiveField(0)
  ready,

  @HiveField(1)
  pending,

  @HiveField(2)
  available,

  @HiveField(3)
  undefined;

  static TranslationStatus fromString(value) {
    switch (value) {
      case "ready":
        return TranslationStatus.ready;
      case "pending":
        return TranslationStatus.pending;
      case "available":
        return TranslationStatus.available;
      default:
        return TranslationStatus.undefined;
    }
  }
}
