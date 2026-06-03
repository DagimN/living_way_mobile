import 'package:living_way/core/models/thread.dart';
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
      threadId: const Uuid().v4(),
      commenter: const Uuid().v4(),
      comment: 'Comment 1',
      likers: [],
      timestamp: DateTime.now(),
      subThreads: [
        ThreadData(
            threadId: const Uuid().v4(),
            commenter: const Uuid().v4(),
            comment: 'Comment 1',
            timestamp: DateTime.now(),
            likers: []),
        ThreadData(
            threadId: const Uuid().v4(),
            commenter: const Uuid().v4(),
            comment: 'Comment 1',
            timestamp: DateTime.now(),
            likers: []),
        ThreadData(
            threadId: const Uuid().v4(),
            commenter: const Uuid().v4(),
            comment: 'Comment 1',
            timestamp: DateTime.now(),
            likers: [])
      ]),
  ThreadData(
      threadId: const Uuid().v4(),
      commenter: const Uuid().v4(),
      comment: 'Comment 2',
      likers: [],
      timestamp: DateTime.now(),
      subThreads: [
        ThreadData(
            threadId: const Uuid().v4(),
            commenter: const Uuid().v4(),
            comment: 'Comment 2',
            timestamp: DateTime.now(),
            likers: []),
        ThreadData(
            threadId: const Uuid().v4(),
            commenter: const Uuid().v4(),
            comment: 'Comment 2',
            timestamp: DateTime.now(),
            likers: [])
      ]),
  ThreadData(
      threadId: const Uuid().v4(),
      commenter: const Uuid().v4(),
      comment: 'Comment 3',
      timestamp: DateTime.now(),
      subThreads: [
        ThreadData(
            threadId: const Uuid().v4(),
            commenter: const Uuid().v4(),
            comment: 'Comment 3',
            timestamp: DateTime.now(),
            likers: [])
      ])
];

List<(int, int, int, int?)> dailyVerses = [
  (48, 3, 14, null),
  (39, 23, 25, 26),
  (42, 14, 7, null),

  // Genesis
  (1, 1, 1, null),
  (1, 1, 27, null),
  (1, 15, 6, null),
  (1, 28, 15, null),
  (1, 50, 20, null),

  // Exodus
  (2, 3, 14, null),
  (2, 14, 14, null),
  (2, 15, 2, null),
  (2, 19, 5, null),
  (2, 20, 1, 17),
  (2, 33, 14, null),

  // Leviticus
  (3, 11, 45, null),
  (3, 19, 2, null),
  (3, 19, 18, null),
  (3, 20, 26, null),

  // Numbers
  (4, 6, 24, 26),
  (4, 14, 18, null),
  (4, 23, 19, null),

  // Deuteronomy
  (5, 4, 29, null),
  (5, 6, 4, 5),
  (5, 7, 9, null),
  (5, 10, 12, null),
  (5, 31, 6, null),
  (5, 31, 8, null),
  (5, 33, 27, null),

  // Joshua
  (6, 1, 7, null),
  (6, 1, 8, null),
  (6, 1, 9, null),
  (6, 24, 14, null),
  (6, 24, 15, null),

  // Judges
  (7, 5, 3, null),
  (7, 5, 31, null),
  (7, 6, 12, null),

  // Ruth
  (8, 1, 16, null),
  (8, 2, 12, null),

  // 1 Samuel
  (9, 2, 2, null),
  (9, 12, 24, null),
  (9, 15, 22, null),
  (9, 16, 7, null),
  (9, 17, 47, null),

  // 2 Samuel
  (10, 7, 22, null),
  (10, 7, 28, null),
  (10, 22, 2, 3),
  (10, 22, 31, null),
  (10, 22, 33, null),

  // 1 Kings
  (11, 3, 9, null),
  (11, 8, 23, null),
  (11, 8, 56, null),
  (11, 18, 21, null),
  (11, 19, 12, null),

  // 2 Kings
  (12, 2, 9, null),
  (12, 6, 16, null),
  (12, 17, 39, null),
  (12, 19, 15, null),
  (12, 20, 5, null),

  // 1 Chronicles
  (13, 16, 11, null),
  (13, 16, 23, 24),
  (13, 16, 34, null),
  (13, 29, 11, null),
  (13, 29, 13, null),

  // 2 Chronicles
  (14, 7, 14, null),
  (14, 14, 11, null),
  (14, 15, 7, null),
  (14, 16, 9, null),
  (14, 20, 15, null),
  (14, 20, 17, null),

  // Ezra
  (15, 7, 10, null),
  (15, 8, 22, null),
  (15, 10, 4, null),

  // Nehemiah
  (16, 1, 5, null),
  (16, 4, 14, null),
  (16, 8, 10, null),
  (16, 9, 6, null),
  (16, 9, 17, null),

  // Esther
  (17, 4, 14, null),
  (17, 4, 16, null),

  // Job
  (18, 1, 21, null),
  (18, 12, 10, null),
  (18, 19, 25, null),
  (18, 23, 10, null),
  (18, 33, 4, null),
  (18, 42, 2, null),

  // Psalms
  (19, 16, 11, null),
  (19, 19, 1, null),
  (19, 19, 14, null),
  (19, 27, 1, null),
  (19, 27, 4, null),
  (19, 34, 1, null),
  (19, 34, 8, null),
  (19, 34, 18, null),
  (19, 37, 4, 5),
  (19, 42, 1, null),
  (19, 46, 1, null),
  (19, 46, 10, null),
  (19, 51, 10, null),
  (19, 84, 10, null),
  (19, 91, 1, 2),
  (19, 118, 24, null),
  (19, 119, 9, null),
  (19, 119, 105, null),
  (19, 121, 1, 2),
  (19, 136, 1, null),
  (19, 139, 13, 14),
  (19, 143, 8, null),
  (19, 150, 6, null),

  // Proverbs
  (20, 1, 7, null),
  (20, 3, 5, 6),
  (20, 4, 23, null),
  (20, 8, 11, null),
  (20, 14, 12, null),
  (20, 15, 1, null),
  (20, 16, 3, null),
  (20, 16, 9, null),
  (20, 17, 17, null),
  (20, 18, 10, null),
  (20, 18, 24, null),
  (20, 22, 6, null),
  (20, 27, 17, null),
  (20, 30, 5, null),
  (20, 31, 30, null),

  // Ecclesiastes
  (21, 3, 1, null),
  (21, 3, 11, null),
  (21, 4, 9, 10),
  (21, 7, 9, null),
  (21, 12, 13, null),

  // Song of Solomon
  (22, 2, 4, null),
  (22, 2, 16, null),
  (22, 4, 7, null),
  (22, 8, 7, null),

  // Isaiah
  (23, 1, 18, null),
  (23, 6, 8, null),
  (23, 9, 6, null),
  (23, 12, 2, null),
  (23, 26, 3, 4),
  (23, 30, 21, null),
  (23, 40, 8, null),
  (23, 40, 29, null),
  (23, 40, 31, null),
  (23, 41, 10, null),
  (23, 43, 1, 2),
  (23, 43, 19, null),
  (23, 53, 5, null),
  (23, 54, 17, null),
  (23, 55, 6, 7),
  (23, 55, 8, 9),
  (23, 58, 11, null),
  (23, 60, 1, null),

  // Jeremiah
  (24, 1, 5, null),
  (24, 1, 9, null),
  (24, 17, 7, 8),
  (24, 31, 3, null),
  (24, 32, 17, null),
  (24, 32, 27, null),
  (24, 33, 3, null),

  // Lamentations
  (25, 3, 25, 26),
  (25, 3, 40, null),

  // Ezekiel
  (26, 11, 19, null),
  (26, 34, 11, 12),
  (26, 34, 26, null),
  (26, 36, 26, 27),

  // Daniel
  (27, 4, 35, null),
  (27, 6, 22, null),
  (27, 6, 26, 27),

  // Hosea
  (28, 6, 1, null),
  (28, 6, 6, null),
  (28, 10, 12, null),
  (28, 14, 9, null),

  // Joel
  (29, 2, 12, 13),
  (29, 2, 25, null),
  (29, 2, 28, null),
  (29, 2, 32, null),

  // Amos
  (30, 5, 14, null),
  (30, 5, 24, null),
  (30, 9, 14, null),

  // Obadiah
  (31, 1, 3, null),
  (31, 1, 17, null),
  (31, 1, 21, null),

  // Jonah
  (32, 2, 2, null),
  (32, 2, 9, null),
  (32, 4, 2, null),

  // Micah
  (33, 4, 2, null),
  (33, 5, 2, null),
  (33, 6, 8, null),
  (33, 7, 7, null),
  (33, 7, 18, null),

  // Nahum
  (34, 1, 3, null),
  (34, 1, 7, null),

  // Habakkuk
  (35, 2, 4, null),
  (35, 2, 14, null),
  (35, 2, 20, null),
  (35, 3, 2, null),
  (35, 3, 17, 18),

  // Zephaniah
  (36, 3, 9, null),
  (36, 3, 15, null),
  (36, 3, 17, null),

  // Haggai
  (37, 1, 5, null),
  (37, 2, 4, null),
  (37, 2, 9, null),

  // Zechariah
  (38, 4, 6, null),
  (38, 7, 9, null),
  (38, 9, 9, null),
  (38, 9, 12, null),
  (38, 14, 9, null),

  // Malachi
  (39, 3, 1, null),
  (39, 3, 6, null),
  (39, 3, 10, null),
  (39, 4, 2, null),

  // Matthew
  (40, 4, 4, null),
  (40, 5, 44, null),
  (40, 6, 21, null),
  (40, 6, 25, 26),
  (40, 6, 33, 34),
  (40, 7, 7, 8),
  (40, 7, 12, null),
  (40, 16, 24, 25),
  (40, 18, 20, null),
  (40, 19, 26, null),
  (40, 24, 35, null),
  (40, 25, 40, null),
  (40, 28, 19, 20),

  // Mark
  (41, 1, 15, null),
  (41, 8, 36, null),
  (41, 9, 23, null),
  (41, 10, 27, null),
  (41, 10, 45, null),
  (41, 11, 24, null),
  (41, 11, 25, null),
  (41, 12, 30, null),

  // Luke
  (42, 1, 37, null),
  (42, 2, 14, null),
  (42, 4, 18, null),
  (42, 6, 31, null),
  (42, 6, 35, null),
  (42, 6, 36, null),
  (42, 9, 23, null),
  (42, 10, 27, null),
  (42, 11, 9, null),
  (42, 12, 15, null),
  (42, 12, 31, null),
  (42, 15, 7, null),
  (42, 18, 1, null),
  (42, 18, 27, null),
  (42, 19, 10, null),
  (42, 24, 34, null),

  // John
  (43, 1, 1, null),
  (43, 1, 4, null),
  (43, 1, 12, null),
  (43, 1, 14, null),
  (43, 1, 29, null),
  (43, 3, 16, 17),
  (43, 3, 30, null),
  (43, 3, 36, null),
  (43, 4, 14, null),
  (43, 4, 24, null),
  (43, 6, 35, null),
  (43, 8, 12, null),
  (43, 8, 31, 32),
  (43, 10, 10, null),
  (43, 10, 11, null),
  (43, 10, 27, 28),
  (43, 11, 25, 26),
  (43, 13, 34, 35),
  (43, 14, 1, null),
  (43, 14, 6, null),
  (43, 14, 15, null),
  (43, 14, 27, null),
  (43, 15, 4, 5),
  (43, 15, 7, null),
  (43, 15, 12, 13),
  (43, 16, 33, null),
  (43, 17, 3, null),
  (43, 20, 29, null),

  // Acts
  (44, 1, 8, null),
  (44, 2, 21, null),
  (44, 2, 38, null),
  (44, 3, 19, null),
  (44, 4, 12, null),
  (44, 5, 29, null),
  (44, 10, 34, 35),
  (44, 16, 31, null),
  (44, 17, 27, 28),
  (44, 20, 24, null),
  (44, 20, 35, null),

  // Romans
  (45, 1, 16, null),
  (45, 3, 23, null),
  (45, 5, 1, null),
  (45, 5, 5, null),
  (45, 5, 8, null),
  (45, 6, 23, null),
  (45, 8, 1, null),
  (45, 8, 18, null),
  (45, 8, 28, null),
  (45, 8, 31, null),
  (45, 10, 9, 10),
  (45, 10, 13, null),
  (45, 10, 17, null),
  (45, 12, 1, 2),
  (45, 12, 15, null),
  (45, 12, 18, null),
  (45, 12, 21, null),
  (45, 13, 8, null),
  (45, 14, 8, null),
  (45, 15, 4, null),
  (45, 15, 13, null),

  // 1 Corinthians
  (46, 1, 18, null),
  (46, 1, 25, null),
  (46, 2, 9, null),
  (46, 3, 16, null),
  (46, 6, 19, 20),
  (46, 10, 13, null),
  (46, 10, 31, null),
  (46, 13, 13, null),
  (46, 15, 3, 4),
  (46, 15, 58, null),
  (46, 16, 13, 14),

  // 2 Corinthians
  (47, 1, 3, 4),
  (47, 3, 17, null),
  (47, 4, 7, null),
  (47, 5, 7, null),
  (47, 5, 17, null),
  (47, 5, 21, null),
  (47, 9, 7, null),
  (47, 9, 8, null),
  (47, 12, 9, 10),

  // Galatians
  (48, 2, 20, null),
  (48, 3, 28, null),
  (48, 5, 1, null),
  (48, 5, 13, null),
  (48, 5, 16, null),
  (48, 5, 22, 23),
  (48, 6, 2, null),
  (48, 6, 7, null),
  (48, 6, 9, 10),

  // Ephesians
  (49, 1, 3, null),
  (49, 1, 7, null),
  (49, 2, 4, 5),
  (49, 2, 19, null),
  (49, 3, 20, 21),
  (49, 4, 1, 3),
  (49, 4, 26, 27),
  (49, 4, 29, null),
  (49, 4, 32, null),
  (49, 5, 1, 2),
  (49, 5, 15, 16),
  (49, 6, 10, 11),

  // Philippians
  (50, 1, 6, null),
  (50, 1, 21, null),
  (50, 2, 3, 4),
  (50, 2, 14, 15),
  (50, 3, 13, 14),
  (50, 3, 20, null),
  (50, 4, 4, null),
  (50, 4, 6, 7),
  (50, 4, 8, null),
  (50, 4, 11, 12),
  (50, 4, 13, null),
  (50, 4, 19, null),

  // Colossians
  (51, 2, 6, 7),
  (51, 3, 1, 2),
  (51, 3, 15, null),
  (51, 3, 16, null),
  (51, 3, 17, null),
  (51, 3, 23, 24),
  (51, 4, 2, null),
  (51, 4, 5, 6),

  // 1 Thessalonians
  (52, 1, 3, null),
  (52, 2, 13, null),
  (52, 3, 12, null),
  (52, 4, 11, 12),
  (52, 4, 13, 14),
  (52, 5, 9, 10),
  (52, 5, 11, null),
  (52, 5, 23, 24),

  // 2 Thessalonians
  (53, 1, 3, null),
  (53, 2, 16, 17),
  (53, 3, 3, null),
  (53, 3, 5, null),
  (53, 3, 13, null),

  // 1 Timothy
  (54, 1, 15, null),
  (54, 2, 5, null),
  (54, 4, 8, null),
  (54, 4, 12, null),
  (54, 6, 6, 7),
  (54, 6, 10, null),
  (54, 6, 12, null),

  // 2 Timothy
  (55, 1, 7, null),
  (55, 1, 9, null),
  (55, 1, 12, null),
  (55, 2, 15, null),
  (55, 2, 22, null),
  (55, 3, 16, 17),
  (55, 4, 2, null),
  (55, 4, 7, 8),

  // Titus
  (56, 2, 11, 12),
  (56, 3, 4, 5),
  (56, 3, 8, null),

  // Philemon
  (57, 1, 4, 5),
  (57, 1, 6, null),
  (57, 1, 7, null),

  // Hebrews
  (58, 1, 3, null),
  (58, 2, 18, null),
  (58, 4, 12, null),
  (58, 4, 14, 15),
  (58, 4, 16, null),
  (58, 6, 19, null),
  (58, 11, 1, null),
  (58, 11, 6, null),
  (58, 12, 1, 2),
  (58, 12, 11, null),
  (58, 12, 14, null),
  (58, 13, 5, 6),
  (58, 13, 8, null),
  (58, 13, 15, 16),
  (58, 13, 20, 21),

  // James
  (59, 1, 2, 4),
  (59, 1, 5, 6),
  (59, 1, 12, null),
  (59, 1, 17, null),
  (59, 1, 19, null),
  (59, 1, 22, null),
  (59, 1, 27, null),
  (59, 2, 17, null),
  (59, 2, 26, null),
  (59, 3, 17, null),
  (59, 4, 7, 8),
  (59, 4, 10, null),
  (59, 5, 13, null),
  (59, 5, 16, null),

  // 1 Peter
  (60, 1, 3, null),
  (60, 1, 15, 16),
  (60, 1, 24, 25),
  (60, 2, 9, 10),
  (60, 2, 24, null),
  (60, 3, 15, null),
  (60, 4, 8, null),
  (60, 4, 10, null),
  (60, 5, 8, 9),
  (60, 5, 10, null),

  // 2 Peter
  (61, 1, 3, 4),
  (61, 1, 20, 21),
  (61, 3, 8, 9),
  (61, 3, 13, null),
  (61, 3, 18, null),

  // 1 John
  (62, 1, 5, null),
  (62, 1, 7, null),
  (62, 1, 9, null),
  (62, 2, 1, 2),
  (62, 3, 1, null),
  (62, 4, 4, null),
  (62, 4, 7, 8),
  (62, 4, 9, 10),
  (62, 4, 16, null),
  (62, 4, 18, 19),
  (62, 5, 4, 5),
  (62, 5, 14, 15),

  // 2 John
  (63, 1, 3, null),
  (63, 1, 6, null),

  // 3 John
  (64, 1, 2, null),
  (64, 1, 4, null),
  (64, 1, 11, null),

  // Jude
  (65, 1, 2, null),
  (65, 1, 20, 21),
  (65, 1, 24, 25),

  // Revelation
  (66, 1, 3, null),
  (66, 1, 8, null),
  (66, 3, 20, null),
  (66, 4, 11, null),
  (66, 7, 16, 17),
  (66, 19, 6, null),
  (66, 21, 3, 4),
  (66, 21, 5, null),
  (66, 21, 6, null),
  (66, 22, 12, 13),
  (66, 22, 17, null),
  (66, 22, 20, 21)
];
