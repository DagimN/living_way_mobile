import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:functional_status_codes/functional_status_codes.dart';

import '../constants/urls.dart';
import '../services/logging_service.dart';
import 'activity/index.dart';
import 'profile.dart';

class UserInteraction {
  String id;
  final Profile user;
  final String targetId;
  final TargetInteraction target;
  dynamic content;
  final InteractionType type;
  final List<Reaction> reactions;
  final bool isAnonymous;
  final bool isPinned;
  final bool isFlagged;
  final List<UserInteraction> subInteractions;
  Map<String, Profile>? voters;
  final DateTime createdAt;

  UserInteraction(
      {required this.id,
      required this.user,
      required this.targetId,
      required this.target,
      required this.content,
      required this.type,
      this.reactions = const [],
      this.isAnonymous = false,
      this.isPinned = false,
      this.isFlagged = false,
      this.subInteractions = const [],
      this.voters = const {},
      required this.createdAt});

  factory UserInteraction.fromMap(Map<String, dynamic> map) {
    final type = InteractionType.fromString(map['type']);
    final dynamic content;
    final voters = Map.fromEntries(
        (map['voters'] as Map<String, dynamic>? ?? {}).entries.map(
              (voter) => MapEntry(
                voter.key,
                Profile.fromJson(voter.value as Map<String, dynamic>),
              ),
            ));

    if (type == InteractionType.poll) {
      content = Poll.fromMap(json.decode(map['content']));

      (content as Poll).options = content.options.map((option) {
        option.voters =
            option.voters.map((voter) => voters[voter]?.id ?? "").toList();
        return option;
      }).toList();
    } else {
      content = map['content'];
    }

    return UserInteraction(
        id: map['id'] ?? map['_id'],
        user: Profile.fromJson(map['userId']),
        targetId: map['targetId'],
        target: TargetInteraction.fromString(map['target']),
        content: content,
        type: type,
        reactions: List.from(map['reactions'])
            .map((reaction) => Reaction.fromJson(reaction))
            .toList(),
        isAnonymous: map['isAnonymous'] ?? false,
        isPinned: map['isPinned'] ?? false,
        isFlagged: map['isFlagged'] ?? false,
        subInteractions: List.from(map['subInteractions'])
            .map((interaction) => UserInteraction.fromMap(interaction))
            .toList(),
        voters: voters,
        createdAt: DateTime.parse(map['createdAt']));
  }

  Map<String, dynamic> toMap() {
    Map<String, String> votersMap = {};

    if (type is Poll) {
      List<PollOptions> pollOptions = (content as Poll).options;

      (content as Poll).options = pollOptions.map((option) {
        option.voters = option.voters.map((voter) {
          final voterIndex = (votersMap.length + 1).toString();
          votersMap[voterIndex] = voter;
          return voterIndex;
        }).toList();

        return option;
      }).toList();
    }

    return {
      "userId": user.id,
      "targetId": targetId,
      "target": target.toString(),
      "content": type is Poll ? (content as Poll).toMap() : content,
      "type": type.name,
      "reactions": reactions.map((reaction) => reaction.toMap()).toList(),
      "isAnonymous": isAnonymous,
      "isPinned": isPinned,
      "isFlagged": isFlagged,
      "subInteractions":
          subInteractions.map((interaction) => interaction.id).toList(),
      "voters": votersMap,
      "createdAt": createdAt.toIso8601String()
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Future<void> recordInteraction({UserInteraction? parent}) async {
    try {
      final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
      const url = appFlavor == "dev"
          ? Urls.devApiUrl
          : appFlavor == "staging"
              ? Urls.stagingApiUrl
              : Urls.prodApiUrl;

      final response = await dio.post('$url/api/v1/interact',
          data: {"data": toMap(), "parent": parent?.id});

      if (!response.statusCode.isSuccess) return;

      id = response.data['interaction']['_id'];
    } catch (error) {
      logger.e(error);
    }

    return;
  }

  Future<void> recordVote(String userId, int optionIndex) async {
    try {
      final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
      const url = appFlavor == "dev"
          ? Urls.devApiUrl
          : appFlavor == "staging"
              ? Urls.stagingApiUrl
              : Urls.prodApiUrl;

      await dio.patch('$url/api/v1/interact/$id',
          data: {"type": "poll", "userId": userId, "optionIndex": optionIndex});
    } catch (error) {
      logger.e(error);
    }
  }

  Future<void> update() async {
    try {
      final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
      const url = appFlavor == "dev"
          ? Urls.devApiUrl
          : appFlavor == "staging"
              ? Urls.stagingApiUrl
              : Urls.prodApiUrl;

      await dio.patch('$url/api/v1/interact/$id',
          data: {"type": type.name, "userId": user.id, "content": content});
    } catch (error) {
      logger.e(error);
    }
  }

  Future<void> delete() async {
    try {
      final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
      const url = appFlavor == "dev"
          ? Urls.devApiUrl
          : appFlavor == "staging"
              ? Urls.stagingApiUrl
              : Urls.prodApiUrl;

      await dio.delete('$url/api/v1/interact/$id');
    } catch (error) {
      logger.e(error);
    }
  }
}

enum TargetInteraction {
  story,
  undefined;

  static TargetInteraction fromString(String value) {
    switch (value) {
      case 'Story':
        return story;
      default:
        return undefined;
    }
  }

  @override
  String toString() {
    switch (this) {
      case story:
        return "Story";
      default:
        return "";
    }
  }
}

enum InteractionType {
  comment,
  reaction,
  chatMessage,
  poll,
  prayerRequest,
  undefined;

  static InteractionType fromString(String value) {
    switch (value) {
      case "comment":
        return comment;
      case "reaction":
        return reaction;
      case "chatMessage":
        return chatMessage;
      case "poll":
        return poll;
      case "prayerRequest":
        return prayerRequest;
      default:
        return undefined;
    }
  }
}

class Reaction {
  Profile user;
  String type;

  Reaction({required this.user, required this.type});

  factory Reaction.fromJson(Map<String, dynamic> map) {
    return Reaction(
        user: Profile.fromJson(map['userId']), type: map['reactionType']);
  }

  Map<String, dynamic> toMap() {
    return {"userId": user.id, "reactionType": type};
  }
}

class Poll {
  String title;
  List<PollOptions> options;

  Poll({required this.title, this.options = const []});

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
        title: map['title'],
        options: List.from(map['options'])
            .map((option) => PollOptions.fromJson(option))
            .toList());
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "options": options.map((option) => option.toJson())
    };
  }
}
