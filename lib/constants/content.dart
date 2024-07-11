import 'package:living_way/models/thread.dart';
import 'package:uuid/uuid.dart';

final books = {
  "ot": [
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalms",
    "Proverbs",
    "Ecclesiastes",
    "Songs of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi"
  ],
  "nt": [
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation"
  ]
};

final threads = [
  ThreadData(
      threadId: const Uuid(),
      commenter: const Uuid(),
      comment: 'Comment 1',
      likes: 50,
      subThreads: [
        ThreadData(
            threadId: const Uuid(),
            commenter: const Uuid(),
            comment: 'Comment 1',
            likes: 50),
        ThreadData(
            threadId: const Uuid(),
            commenter: const Uuid(),
            comment: 'Comment 1',
            likes: 50),
        ThreadData(
            threadId: const Uuid(),
            commenter: const Uuid(),
            comment: 'Comment 1',
            likes: 50)
      ]),
  ThreadData(
      threadId: const Uuid(),
      commenter: const Uuid(),
      comment: 'Comment 2',
      likes: 100,
      subThreads: [
        ThreadData(
            threadId: const Uuid(),
            commenter: const Uuid(),
            comment: 'Comment 2',
            likes: 50),
        ThreadData(
            threadId: const Uuid(),
            commenter: const Uuid(),
            comment: 'Comment 2',
            likes: 50)
      ]),
  ThreadData(
      threadId: const Uuid(),
      commenter: const Uuid(),
      comment: 'Comment 3',
      subThreads: [
        ThreadData(
            threadId: const Uuid(),
            commenter: const Uuid(),
            comment: 'Comment 3',
            likes: 50)
      ])
];
