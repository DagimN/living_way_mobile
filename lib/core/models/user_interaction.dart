import 'dart:convert';

import 'activity/index.dart';
import 'profile.dart';

class UserInteraction {
  final String id;
  final Profile user;
  final String targetId;
  final TargetInteraction target;
  final dynamic content;
  final InteractionType type;
  final List<Reaction> reactions;
  final bool isAnonymous;
  final bool isPinned;
  final bool isFlagged;
  final List<UserInteraction> subInteractions;
  final Map<String, Profile>? voters;
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
      this.voters,
      required this.createdAt});

  factory UserInteraction.fromMap(Map<String, dynamic> map) {
    final type = InteractionType.fromString(map['type']);
    final dynamic content;
    final voters = (map['voters'] as Map<String, dynamic>? ?? {});

    if (type == InteractionType.poll) {
      content = Poll.fromMap(json.decode(map['content']));
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
        voters: Map.fromEntries(voters.entries.map(
          (voter) => MapEntry(
            voter.key,
            Profile.fromJson(voter.value as Map<String, dynamic>),
          ),
        )),
        createdAt: DateTime.parse(map['createdAt']));
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": user.id,
      "targetId": targetId,
      "target": target.toString(),
      "content": type is Poll ? (content as Poll).toMap() : content,
      "type": type.name,
      "reactions": reactions.map((reaction) => reaction.toMap()),
      "isAnonymous": isAnonymous,
      "isPinned": isPinned,
      "isFlagged": isFlagged,
      "subInteractions": subInteractions.map((interaction) => interaction.id),
      "voters": (voters ?? {})
          .entries
          .map((entry) => {entry.key.toString(): entry.value.id}),
      "createdAt": createdAt.toIso8601String()
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
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
  String reactionType;

  Reaction({required this.user, required this.reactionType});

  factory Reaction.fromJson(Map<String, dynamic> map) {
    return Reaction(
        user: Profile.fromJson(map['userId']),
        reactionType: map['reactionType']);
  }

  Map<String, dynamic> toMap() {
    return {"userId": user.id, "reactionType": reactionType};
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
