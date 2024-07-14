import 'package:living_way/models/bible_quote.dart';

class ThreadData {
  String threadId;
  String commenter;
  String comment;
  int likes;
  List<BibleQuote> quotes;
  List<ThreadData> subThreads;

  ThreadData(
      {required this.threadId,
      required this.commenter,
      required this.comment,
      this.likes = 0,
      this.quotes = const [],
      this.subThreads = const []});

  static ThreadData fromJson(json) {
    return ThreadData(
        threadId: json['threadId'],
        commenter: json['commenter'],
        comment: json['comment'],
        likes: json['likes'],
        quotes: (json['quotes'] as List)
            .map((e) => BibleQuote.fromJson(e))
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
      "likes": likes,
      "quotes": quotes.map((quote) => quote.toJson()).toList(),
      "subThreads": subThreads.map((thread) => thread.toJson()).toList()
    };
  }
}
