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
  (0, 0, 0, null),
  (0, 0, 26, null),
  (0, 11, 0, 2),
  (0, 14, 5, null),
  (0, 27, 14, null),
  (0, 49, 19, null),

  // Exodus
  (1, 2, 13, null),
  (1, 13, 13, null),
  (1, 14, 1, null),
  (1, 18, 4, null),
  (1, 19, 0, 16),
  (1, 32, 13, null),

  // Leviticus
  (2, 10, 44, null),
  (2, 18, 1, null),
  (2, 18, 17, null),
  (2, 20, 25, null),

  // Numbers
  (3, 5, 23, 25),
  (3, 13, 17, null),
  (3, 23, 18, null),

  // Deuteronomy
  (4, 3, 28, null),
  (4, 5, 3, 4),
  (4, 7, 8, null),
  (4, 10, 11, null),
  (4, 30, 5, null),
  (4, 30, 7, null),
  (4, 32, 26, null),

  // Joshua
  (5, 0, 6, null),
  (5, 0, 7, null),
  (5, 0, 8, null),
  (5, 23, 13, null),
  (5, 23, 14, null),

  // Judges
  (6, 4, 2, null),
  (6, 4, 30, null),
  (6, 5, 11, null),

  // Ruth
  (7, 0, 15, null),
  (7, 1, 11, null),

  // 1 Samuel
  (8, 1, 1, null),
  (8, 11, 23, null),
  (8, 14, 21, null),
  (8, 15, 6, null),
  (8, 16, 46, null),

  // 2 Samuel
  (9, 6, 21, null),
  (9, 6, 27, null),
  (9, 21, 1, 2),
  (9, 21, 30, null),
  (9, 21, 32, null),

  // 1 Kings
  (10, 2, 8, null),
  (10, 7, 22, null),
  (10, 7, 55, null),
  (10, 17, 20, null),
  (10, 19, 11, null),

  // 2 Kings
  (11, 1, 8, null),
  (11, 5, 15, null),
  (11, 16, 38, null),
  (11, 18, 14, null),
  (11, 19, 4, null),

  // 1 Chronicles
  (12, 15, 10, null),
  (12, 15, 22, 23),
  (12, 15, 33, null),
  (12, 28, 10, null),
  (12, 28, 12, null),

  // 2 Chronicles
  (13, 6, 13, null),
  (13, 13, 10, null),
  (13, 14, 6, null),
  (13, 15, 8, null),
  (13, 19, 14, null),
  (13, 19, 16, null),

  // Ezra
  (14, 6, 9, null),
  (14, 7, 21, null),
  (14, 9, 3, null),

  // Nehemiah
  (15, 0, 4, null),
  (15, 3, 13, null),
  (15, 7, 9, null),
  (15, 8, 5, null),
  (15, 8, 16, null),

  // Esther
  (16, 3, 13, null),
  (16, 3, 15, null),

  // Job
  (17, 0, 20, null),
  (17, 11, 9, null),
  (17, 18, 24, null),
  (17, 22, 9, null),
  (17, 32, 3, null),
  (17, 41, 1, null),

  // Psalms
  (18, 0, 0, 2),
  (18, 15, 10, null),
  (18, 18, 0, null),
  (18, 18, 13, null),
  (18, 22, 0, 5),
  (18, 26, 0, null),
  (18, 26, 3, null),
  (18, 33, 0, null),
  (18, 33, 7, null),
  (18, 33, 17, null),
  (18, 36, 3, 4),
  (18, 41, 0, null),
  (18, 45, 0, null),
  (18, 45, 9, null),
  (18, 50, 9, null),
  (18, 83, 9, null),
  (18, 90, 0, 1),
  (18, 99, 0, 4),
  (18, 102, 0, 4),
  (18, 117, 23, null),
  (18, 118, 8, null),
  (18, 118, 104, null),
  (18, 120, 0, 1),
  (18, 135, 0, null),
  (18, 138, 12, 13),
  (18, 142, 7, null),
  (18, 149, 5, null),

  // Proverbs
  (19, 0, 6, null),
  (19, 2, 4, 5),
  (19, 3, 22, null),
  (19, 7, 10, null),
  (19, 13, 11, null),
  (19, 14, 0, null),
  (19, 15, 2, null),
  (19, 16, 8, null),
  (19, 17, 16, null),
  (19, 18, 9, null),
  (19, 18, 23, null),
  (19, 21, 5, null),
  (19, 26, 16, null),
  (19, 29, 4, null),
  (19, 30, 29, null),

  // Ecclesiastes
  (20, 2, 0, null),
  (20, 2, 10, null),
  (20, 3, 8, 9),
  (20, 6, 8, null),
  (20, 11, 12, null),

  // Song of Solomon
  (21, 1, 3, null),
  (21, 1, 15, null),
  (21, 3, 6, null),
  (21, 7, 6, null),

  // Isaiah
  (22, 0, 17, null),
  (22, 5, 7, null),
  (22, 8, 5, null),
  (22, 11, 1, null),
  (22, 25, 2, 3),
  (22, 29, 20, null),
  (22, 39, 7, null),
  (22, 39, 28, null),
  (22, 39, 30, null),
  (22, 40, 9, null),
  (22, 42, 0, 1),
  (22, 42, 18, null),
  (22, 52, 4, null),
  (22, 53, 16, null),
  (22, 54, 5, 6),
  (22, 54, 7, 8),
  (22, 57, 10, null),
  (22, 59, 0, null),

  // Jeremiah
  (23, 0, 4, null),
  (23, 0, 8, null),
  (23, 16, 6, 7),
  (23, 28, 10, 12),
  (23, 30, 2, null),
  (23, 31, 16, null),
  (23, 31, 26, null),
  (23, 32, 2, null),

  // Lamentations
  (24, 2, 21, 23),
  (24, 2, 24, 25),
  (24, 2, 39, null),

  // Ezekiel
  (25, 10, 18, null),
  (25, 33, 10, 11),
  (25, 33, 25, null),
  (25, 35, 25, 26),

  // Daniel
  (26, 1, 19, 21),
  (26, 3, 34, null),
  (26, 5, 21, null),
  (26, 5, 25, 26),

  // Hosea
  (27, 5, 0, null),
  (27, 5, 5, null),
  (27, 9, 11, null),
  (27, 13, 8, null),

  // Joel
  (28, 1, 11, 12),
  (28, 1, 24, null),
  (28, 1, 27, null),
  (28, 1, 31, null),

  // Amos
  (29, 4, 13, null),
  (29, 4, 23, null),
  (29, 8, 13, null),

  // Obadiah
  (30, 0, 2, null),
  (30, 0, 16, null),
  (30, 0, 20, null),

  // Jonah
  (31, 1, 1, null),
  (31, 1, 8, null),
  (31, 3, 1, null),

  // Micah
  (32, 3, 1, null),
  (32, 4, 1, null),
  (32, 5, 7, null),
  (32, 6, 6, null),
  (32, 7, 17, null),

  // Nahum
  (33, 0, 2, null),
  (33, 0, 6, null),

  // Habakkuk
  (34, 1, 3, null),
  (34, 1, 13, null),
  (34, 1, 19, null),
  (34, 2, 1, null),
  (34, 2, 16, 17),

  // Zephaniah
  (35, 3, 8, null),
  (35, 3, 14, null),
  (35, 3, 16, null),

  // Haggai
  (36, 0, 4, null),
  (36, 1, 3, null),
  (36, 1, 8, null),

  // Zechariah
  (37, 3, 5, null),
  (37, 6, 8, null),
  (37, 8, 8, null),
  (37, 8, 11, null),
  (37, 13, 8, null),

  // Malachi
  (38, 2, 0, null),
  (38, 2, 5, null),
  (38, 2, 9, null),
  (38, 3, 1, null),

  // Matthew
  (39, 3, 3, null),
  (39, 4, 2, 11),
  (39, 4, 13, 15),
  (39, 4, 43, null),
  (39, 5, 8, 12),
  (39, 5, 20, null),
  (39, 5, 24, 25),
  (39, 5, 32, 33),
  (39, 6, 6, 7),
  (39, 6, 11, null),
  (39, 10, 27, 29),
  (39, 15, 23, 24),
  (39, 17, 19, null),
  (39, 18, 25, null),
  (39, 21, 36, 38),
  (39, 23, 34, null),
  (39, 24, 39, null),
  (39, 27, 18, 19),

  // Mark
  (40, 0, 14, null),
  (40, 7, 35, null),
  (40, 8, 22, null),
  (40, 9, 26, null),
  (40, 9, 44, null),
  (40, 10, 23, null),
  (40, 10, 24, null),
  (40, 11, 29, null),

  // Luke
  (41, 0, 36, null),
  (41, 1, 13, null),
  (41, 3, 17, null),
  (41, 5, 30, null),
  (41, 5, 34, null),
  (41, 5, 35, null),
  (41, 8, 22, null),
  (41, 9, 26, null),
  (41, 10, 8, null),
  (41, 12, 14, null),
  (41, 12, 30, null),
  (41, 14, 6, null),
  (41, 17, 0, null),
  (41, 17, 26, null),
  (41, 18, 9, null),
  (41, 23, 33, null),

  // John
  (42, 0, 0, null),
  (42, 0, 3, null),
  (42, 0, 11, null),
  (42, 0, 13, null),
  (42, 0, 28, null),
  (42, 2, 15, 16),
  (42, 2, 29, null),
  (42, 2, 35, null),
  (42, 3, 13, null),
  (42, 3, 23, null),
  (42, 6, 34, null),
  (42, 7, 11, null),
  (42, 7, 30, 31),
  (42, 9, 9, null),
  (42, 9, 10, null),
  (42, 9, 26, 27),
  (42, 10, 24, 25),
  (42, 12, 33, 34),
  (42, 13, 0, null),
  (42, 13, 5, null),
  (42, 13, 14, null),
  (42, 13, 26, null),
  (42, 14, 3, 4),
  (42, 14, 6, null),
  (42, 14, 11, 12),
  (42, 15, 32, null),
  (42, 16, 2, null),
  (42, 19, 28, null),

  // Acts
  (43, 0, 7, null),
  (43, 1, 20, null),
  (43, 1, 37, null),
  (43, 1, 41, 46),
  (43, 2, 18, null),
  (43, 3, 11, null),
  (43, 4, 28, null),
  (43, 9, 33, 34),
  (43, 15, 30, null),
  (43, 16, 26, 27),
  (43, 19, 23, null),
  (43, 19, 34, null),

  // Romans
  (44, 0, 15, null),
  (44, 2, 22, null),
  (44, 4, 0, null),
  (44, 4, 4, null),
  (44, 4, 7, null),
  (44, 5, 22, null),
  (44, 7, 0, null),
  (44, 7, 17, null),
  (44, 7, 27, null),
  (44, 7, 30, null),
  (44, 7, 36, 38),
  (44, 9, 8, 9),
  (44, 9, 12, null),
  (44, 9, 16, null),
  (44, 11, 0, 1),
  (44, 11, 8, 12),
  (44, 11, 14, null),
  (44, 11, 17, null),
  (44, 11, 20, null),
  (44, 12, 7, null),
  (44, 13, 7, null),
  (44, 14, 3, null),
  (44, 14, 12, null),

  // 1 Corinthians
  (45, 0, 17, null),
  (45, 0, 24, null),
  (45, 1, 8, null),
  (45, 2, 15, null),
  (45, 5, 18, 19),
  (45, 9, 12, null),
  (45, 9, 30, null),
  (45, 12, 0, 2),
  (45, 12, 3, 6),
  (45, 12, 12, null),
  (45, 14, 2, 3),
  (45, 14, 54, 56),
  (45, 14, 57, null),
  (45, 15, 12, 13),

  // 2 Corinthians
  (46, 0, 2, 3),
  (46, 2, 16, null),
  (46, 3, 6, null),
  (46, 4, 15, 17),
  (46, 4, 6, null),
  (46, 5, 16, null),
  (46, 5, 20, null),
  (46, 8, 6, null),
  (46, 8, 7, null),
  (46, 11, 8, 9),

  // Galatians
  (47, 1, 19, null),
  (47, 2, 27, null),
  (47, 4, 0, null),
  (47, 4, 12, null),
  (47, 4, 15, null),
  (47, 4, 21, 22),
  (47, 5, 1, null),
  (47, 5, 6, null),
  (47, 5, 8, 9),

  // Ephesians
  (48, 0, 2, null),
  (48, 0, 6, null),
  (48, 1, 3, 4),
  (48, 1, 7, 9),
  (48, 1, 18, null),
  (48, 2, 15, 18),
  (48, 2, 19, 20),
  (48, 3, 0, 2),
  (48, 3, 25, 26),
  (48, 3, 28, null),
  (48, 3, 31, null),
  (48, 4, 0, 1),
  (48, 4, 14, 15),
  (48, 5, 9, 10),
  (48, 5, 12, 16),

  // Philippians
  (49, 0, 5, null),
  (49, 0, 20, null),
  (49, 1, 2, 3),
  (49, 1, 4, 7),
  (49, 1, 8, 10),
  (49, 1, 13, 14),
  (49, 2, 12, 13),
  (49, 2, 19, null),
  (49, 3, 3, null),
  (49, 3, 5, 6),
  (49, 3, 7, null),
  (49, 3, 10, 11),
  (49, 3, 12, null),
  (49, 3, 18, null),

  // Colossians
  (50, 0, 14, 16),
  (50, 1, 5, 6),
  (50, 2, 0, 1),
  (50, 2, 11, 13),
  (50, 2, 14, null),
  (50, 2, 15, null),
  (50, 2, 16, null),
  (50, 2, 22, 23),
  (50, 3, 1, null),
  (50, 3, 4, 5),

  // 1 Thessalonians
  (51, 0, 2, null),
  (51, 1, 12, null),
  (51, 2, 11, null),
  (51, 3, 10, 11),
  (51, 3, 12, 13),
  (51, 4, 8, 9),
  (51, 4, 10, null),
  (51, 4, 15, 17),
  (51, 4, 22, 23),

  // 2 Thessalonians
  (52, 0, 2, null),
  (52, 1, 15, 16),
  (52, 2, 2, null),
  (52, 2, 4, null),
  (52, 2, 12, null),

  // 1 Timothy
  (53, 0, 14, null),
  (53, 1, 4, null),
  (53, 3, 7, null),
  (53, 3, 11, null),
  (53, 5, 5, 6),
  (53, 5, 9, null),
  (53, 5, 11, null),
  (53, 5, 16, 18),

  // 2 Timothy
  (54, 0, 6, null),
  (54, 0, 8, null),
  (54, 0, 11, null),
  (54, 1, 14, null),
  (54, 1, 21, null),
  (54, 2, 15, 16),
  (54, 3, 1, null),
  (54, 3, 6, 7),

  // Titus
  (55, 1, 10, 11),
  (55, 2, 3, 4),
  (55, 3, 7, null),

  // Philemon
  (56, 0, 3, 4),
  (56, 0, 5, null),
  (56, 0, 6, null),

  // Hebrews
  (57, 0, 2, null),
  (57, 1, 17, null),
  (57, 3, 11, null),
  (57, 3, 13, 14),
  (57, 3, 15, null),
  (57, 5, 18, null),
  (57, 9, 22, 24),
  (57, 10, 0, null),
  (57, 10, 5, null),
  (57, 11, 0, 1),
  (57, 11, 10, null),
  (57, 11, 13, null),
  (57, 12, 4, 5),
  (57, 12, 7, null),
  (57, 12, 14, 15),
  (57, 12, 19, 20),

  // James
  (58, 0, 1, 3),
  (58, 0, 4, 5),
  (58, 0, 11, null),
  (58, 0, 16, null),
  (58, 0, 18, null),
  (58, 0, 21, null),
  (58, 0, 26, null),
  (58, 1, 16, null),
  (58, 1, 25, null),
  (58, 2, 16, null),
  (58, 3, 6, 7),
  (58, 3, 9, null),
  (58, 4, 12, null),
  (58, 4, 15, null),

  // 1 Peter
  (59, 0, 2, null),
  (59, 0, 14, 15),
  (59, 0, 23, 24),
  (59, 1, 8, 9),
  (59, 1, 23, null),
  (59, 2, 14, null),
  (59, 3, 7, null),
  (59, 4, 9, null),
  (59, 4, 5, 6),
  (59, 4, 7, 8),
  (59, 4, 9, null),

  // 2 Peter
  (60, 0, 2, 3),
  (60, 0, 4, 7),
  (60, 0, 19, 20),
  (60, 2, 7, 8),
  (60, 2, 12, null),
  (60, 2, 17, null),

  // 1 John
  (61, 0, 4, null),
  (61, 0, 6, null),
  (61, 0, 8, null),
  (61, 1, 0, 1),
  (61, 1, 14, 16),
  (61, 2, 0, null),
  (61, 2, 15, 17),
  (61, 3, 3, null),
  (61, 3, 6, 7),
  (61, 3, 8, 9),
  (61, 3, 15, null),
  (61, 3, 17, 18),
  (61, 4, 3, 4),
  (61, 4, 13, 14),

  // 2 John
  (62, 0, 2, null),
  (62, 0, 5, null),

  // 3 John
  (63, 0, 1, null),
  (63, 0, 3, null),
  (63, 0, 10, null),

  // Jude
  (64, 0, 1, null),
  (64, 0, 19, 20),
  (64, 0, 23, 24),

  // Revelation
  (65, 0, 2, null),
  (65, 0, 7, null),
  (65, 2, 19, null),
  (65, 3, 10, null),
  (65, 6, 15, 16),
  (65, 18, 5, null),
  (65, 20, 2, 3),
  (65, 20, 4, null),
  (65, 20, 5, null),
  (65, 21, 11, 12),
  (65, 22, 16, null),
  (65, 22, 19, 20)
];
