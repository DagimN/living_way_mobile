import 'resource/passage/index.dart';

class ThreadData {
  String threadId;
  String commenter;
  String comment;
  List<String> likers;
  List<Passage> quotes;
  List<ThreadData> subThreads;
  DateTime timestamp;

  ThreadData(
      {required this.threadId,
      required this.commenter,
      required this.comment,
      required this.timestamp,
      this.likers = const [],
      this.quotes = const [],
      this.subThreads = const []});

  static ThreadData fromJson(json) {
    return ThreadData(
        threadId: json['threadId'],
        commenter: json['commenter'],
        comment: json['comment'],
        timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
        likers:
            ((json['likers'] as List?) ?? []).map((e) => e.toString()).toList(),
        quotes: (json['quotes'] as List)
            .map((e) => Passage.fromMap(null, e))
            .toList(),
        subThreads: (json['subThreads'] as List)
            .map((e) => ThreadData.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "threadId": threadId,
      "commenter": commenter,
      "comment": comment,
      "likers": likers,
      "quotes": quotes.map((quote) => quote.toMap()).toList(),
      "subThreads": subThreads.map((thread) => thread.toJson()).toList(),
      "timestamp": timestamp.toIso8601String()
    };
  }
}
