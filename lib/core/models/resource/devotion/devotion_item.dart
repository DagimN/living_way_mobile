import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

part 'devotion_item.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 7)
class DevotionItem extends ChangeNotifier {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String subTitle;

  @HiveField(3)
  final Passage passage;

  @HiveField(4)
  final DateTime assignedDate;

  DevotionItem(
      {required this.id,
      required this.title,
      required this.subTitle,
      required this.passage,
      required this.assignedDate});

  factory DevotionItem.fromJson(json) {
    return DevotionItem(
        id: json['_id'] ?? json['id'] ?? "",
        title: json['title'],
        subTitle: json['subTitle'],
        passage: Passage.fromMap(null, json['passage']),
        assignedDate: DateTime.parse(json['assignedDate']));
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subTitle": subTitle,
      "passage": passage.toMap(),
      "assignedDate": assignedDate.toIso8601String()
    };
  }

  DevotionItem copyWith({
    String? title,
    String? subTitle,
    Passage? passage,
    DateTime? assignedDate,
    bool? isCompleted,
  }) {
    return DevotionItem(
      id: id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      passage: passage ?? this.passage,
      assignedDate: assignedDate ?? this.assignedDate,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  bool get isDevotionalLocked {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day + 7);
    final target =
        DateTime(assignedDate.year, assignedDate.month, assignedDate.day);

    if (target.year > now.year) return true;
    if (target.year == now.year && target.month > now.month) return true;
    if (target.isAfter(today)) return true;

    return false;
  }

  bool get isDevotionItemCompleted {
    final context = UIService.navigatorKey.currentContext;

    if (context == null) {
      UIService.showSnackbar(
        backgroundColor: Colors.red,
        message: Tr.t("devotionItemUpdateError"),
      );
      return false;
    }

    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    final profile = profileController.userProfile;

    return (profile?.devotionProgress
                .where((devotionId) => devotionId == id)
                .length ??
            0) ==
        1;
  }

  void toggleDevotionItemCompletion() {
    final context = UIService.navigatorKey.currentContext;

    if (context == null) {
      UIService.showSnackbar(
        backgroundColor: Colors.red,
        message: Tr.t("devotionItemUpdateError"),
      );
      return;
    }

    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    final themeController =
        Provider.of<ThemeController>(context, listen: false);
    final profile = profileController.userProfile;
    final theme = AppTheme(themeController.brightness);

    if (profile == null) {
      UIService.showSnackbar(
          backgroundColor: theme.failedColor,
          message: Tr.t('devotionProgressLoginRequired'));
      return;
    }

    if (isDevotionItemCompleted) {
      profile.devotionProgress
          .removeWhere((devotionItemId) => devotionItemId == id);
    } else {
      profile.devotionProgress.add(id);
    }

    final formData = FormData();
    formData.fields.addAll([
      MapEntry('id', profile.id),
      MapEntry('devotionProgress', jsonEncode(profile.devotionProgress)),
    ]);

    profileController.editProfile(formData);
    notifyListeners();
  }
}
