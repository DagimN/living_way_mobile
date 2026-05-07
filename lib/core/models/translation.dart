import 'dart:convert';

class Translation {
  String name;
  TranslationStatus status;
  String? path;
  bool isDefault;

  Translation(
      {required this.name,
      this.status = TranslationStatus.undefined,
      this.path,
      this.isDefault = false});

  static Translation fromMap(json) {
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

enum TranslationStatus {
  ready,
  pending,
  available,
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
