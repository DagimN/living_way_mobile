import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/bible_quote.dart';
import 'package:living_way/core/models/thread.dart';

void main() {
  group('ThreadData', () {
    test('fromJson and toJson round-trip', () {
      final timestamp = DateTime(2025, 5, 16, 10, 30);
      final json = {
        'threadId': 'thread-1',
        'commenter': 'user-1',
        'comment': 'Great insight!',
        'timestamp': timestamp.toIso8601String(),
        'likers': ['user-2'],
        'quotes': [
          {'book': 'John', 'int': 3, 'verse': 16, 'index': 0},
        ],
        'subThreads': [
          {
            'threadId': 'sub-1',
            'commenter': 'user-3',
            'comment': 'Agreed',
            'timestamp': timestamp.toIso8601String(),
            'likers': [],
            'quotes': [],
            'subThreads': [],
          },
        ],
      };
      final thread = ThreadData.fromJson(json);
      expect(thread.threadId, 'thread-1');
      expect(thread.commenter, 'user-1');
      expect(thread.comment, 'Great insight!');
      expect(thread.likers, ['user-2']);
      expect(thread.quotes, hasLength(1));
      expect(thread.quotes.first, isA<BibleQuote>());
      expect(thread.subThreads, hasLength(1));

      final encoded = thread.toJson();
      expect(encoded['threadId'], 'thread-1');
      expect(encoded['comment'], 'Great insight!');
    });

    test('fromJson uses current time for invalid timestamp', () {
      final json = {
        'threadId': 't1',
        'commenter': 'u1',
        'comment': 'c',
        'timestamp': 'invalid',
        'likers': [],
        'quotes': [],
        'subThreads': [],
      };
      final thread = ThreadData.fromJson(json);
      expect(thread.timestamp.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
    });
  });
}
