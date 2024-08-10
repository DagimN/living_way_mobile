import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/constants/content.dart' as content;
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/models/book.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/translation.dart';
import 'package:living_way/utils/load_json.dart';

class ContentController extends ChangeNotifier {
  final TextEditingController commentBoxTextEditingController =
      TextEditingController();
  ActivityFilter topicActivityFilter = ActivityFilter.latest;
  ActivityFilter threadActivityFilter = ActivityFilter.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];
  List<ThreadData> threads = content.threads;
  ValueNotifier<GlobalKey?> commentingThreadKeyNotifier = ValueNotifier(null);
  List<Book> bible = [];
  List<Translation> translations = [
    Translation(name: "KJV", isAvailabe: true),
    Translation(name: "NKJV", downloadUrl: ""),
    Translation(name: "ASV"),
    Translation(name: "NASB")
  ];
  List<ActivityContent> activityList = [
    ActivityContent(
        id: '1',
        isOngoing: true,
        type: ContentType.event,
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ActivityContent(
        id: '2',
        type: ContentType.article,
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ActivityContent(
        id: '3',
        type: ContentType.article,
        timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ActivityContent(
        id: '4',
        type: ContentType.external,
        timestamp: DateTime.now().add(const Duration(hours: 1))),
    ActivityContent(
        id: '5',
        type: ContentType.gallery,
        title: "“ሕይወት ለዋጭ ወንጌል” የቲቶ መልዕክት ጥናት Week 2",
        images: [
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454445120_515389501026011_2844082436010991590_n.jpg?stp=dst-jpg_e35_s1080x1080&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=w1VBbM8gkfMQ7kNvgFAS0JR&edm=AGenrX8BAAAA&ccb=7-5&oh=00_AYC7ZZyl1MFvB6ipq4zmRYlOEwmm7DZtqQTNqCaYMsPYqA&oe=66BD48E0&_nc_sid=ed990e",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454339781_823704839502816_8805898697190177090_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgwOS5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=HgbQOvJ6ZZ8Q7kNvgEhfITc&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxMDg0OTg4NA%3D%3D.2-ccb7-5&oh=00_AYAVHSmMSuzWenGrPEjwPS7oawwPm4j3nkoKfDoqio-BIQ&oe=66BD5CBE&_nc_sid=8f1549",
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454347125_502479292505207_2841394535742577413_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=ja4oDXI1Y-gQ7kNvgEOr0MA&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxOTEzOTg1OA%3D%3D.2-ccb7-5&oh=00_AYCrpM6npiKkGUFNWg8nNDerjfTUdAAfD8WezjmVxAdI0w&oe=66BD571D&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454355896_376052815519260_924894334783785225_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=JCjI-xdmtXYQ7kNvgGzaoMC&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzIxMjA4NjMzNg%3D%3D.2-ccb7-5&oh=00_AYC_JHnf-jM_m4YT0R8XKt0cf6CERquhQdbeb0xj-YRDQQ&oe=66BD4B1D&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454383853_844023010691391_7888535021732231256_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=103&_nc_ohc=1P-lqfsUXcQQ7kNvgH9zdKr&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAyNzU5NzMzMg%3D%3D.2-ccb7-5&oh=00_AYAOy9eW-iRD3-cNo-61IXEVA-uN3mSb6uKvoDCLqlFY-w&oe=66BD2656&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454390602_1042964344159074_8526859650911907146_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=eBK5hKvo4wIQ7kNvgGd-f1u&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxOTI1ODU4Nw%3D%3D.2-ccb7-5&oh=00_AYDKSi8nsM8ypoFhyu83j6s4aPXiSWZJ9XPHBDy0Vs4DKg&oe=66BD4A15&_nc_sid=8f1549",
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454626324_2402679976789943_2747565838855526354_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=vuy78KzeiI0Q7kNvgHBxMPW&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxOTE1NDAwOA%3D%3D.2-ccb7-5&oh=00_AYBPesuh2qQ5_eEOoOHEb6MFPE-boqRPngMgya0Dun7E8g&oe=66BD3313&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454386924_1223351595469970_2446944206604132944_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=102&_nc_ohc=Z6K8YNS5VbUQ7kNvgHjKSks&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAyNzUxNzAxNQ%3D%3D.2-ccb7-5&oh=00_AYDDofiozpCWic7-HWJ-q0M67y2ZfikUp5xAcGY_l7DjWA&oe=66BD3249&_nc_sid=8f1549",
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454387991_845543030855327_4041453556796890906_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=xVkeMtoHT9wQ7kNvgFPIxjo&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzExOTk1NTAxNg%3D%3D.2-ccb7-5&oh=00_AYD2-s6RDequlxoTa1vKWN-AZ70kcBhlySSDVz2E5NVYCQ&oe=66BD2CAF&_nc_sid=8f1549"
        ],
        timestamp: DateTime(2024, 8, 7, 16)),
    ActivityContent(
        id: '6',
        type: ContentType.poll,
        title: 'When will you be available?',
        pollOptions: [
          PollOptions(title: '10:00 AM', votes: 28),
          PollOptions(title: '10:30 AM', votes: 8),
          PollOptions(title: '11:00 AM', votes: 40),
          PollOptions(title: '12:00 PM', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 2))),
    ActivityContent(
        id: '7',
        type: ContentType.poll,
        title: 'What shall we study?',
        pollOptions: [
          PollOptions(title: 'Daniel', votes: 28),
          PollOptions(title: 'Hosea', votes: 8),
          PollOptions(title: 'Amos', votes: 40),
          PollOptions(title: 'Micah', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 8))),
    ActivityContent(
        id: '8',
        type: ContentType.poll,
        title: "How old are you?",
        pollOptions: [
          PollOptions(title: 'less than 18', votes: 28),
          PollOptions(title: '18 - 30', votes: 8),
          PollOptions(title: '31 - 50', votes: 40),
          PollOptions(title: '51 +', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 12))),
    ActivityContent(
        id: '9',
        type: ContentType.event,
        timestamp: DateTime.now().add(const Duration(days: 720)))
  ];

  Book? book;
  int? chapter;
  int? verse;
  Translation? translation;

  ContentController() {
    loadJson('assets/data/en_kjv.json').then((data) {
      bible = (data as List)
          .map((e) => Book(
              name: e['name'],
              chapters: (e['chapters'] as List)
                  .map((chapter) => (chapter as List)
                      .map((verse) => verse.toString())
                      .toList())
                  .toList()))
          .toList();
      notifyListeners();
    });
  }

  set setActivityFilter(ActivityFilter value) {
    topicActivityFilter = value;
    notifyListeners();
  }

  set setThreadFilter(ActivityFilter value) {
    threadActivityFilter = value;
    notifyListeners();
  }

  set setCategoryFilter(CategoryFilter value) {
    categoryFilter = value;
    notifyListeners();
  }

  set setBooksFilter(List<String> books) {
    booksFiltered = books;
    notifyListeners();
  }

  set setCommentingThreadKey(GlobalKey? value) {
    commentingThreadKeyNotifier.value = value;
    notifyListeners();
  }

  set setTranslation(Translation value) {
    translation = value;
    notifyListeners();
  }

  set setBook(Book value) {
    book = value;
    notifyListeners();
  }

  set setChapter(int? value) {
    chapter = value;
    notifyListeners();
  }

  set setVerse(int? value) {
    verse = value;
    notifyListeners();
  }
}

enum ActivityFilter { mostActive, mostLiked, mostViewed, latest }

enum CategoryFilter { all, ot, nt }
