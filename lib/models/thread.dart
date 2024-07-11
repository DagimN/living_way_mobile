import 'package:living_way/models/bible_quote.dart';
import 'package:uuid/uuid.dart';

class ThreadData {
  Uuid threadId;
  Uuid commenter;
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
}
