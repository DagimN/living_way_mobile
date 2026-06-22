import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:living_way/core/constants/content.dart' as content;
import 'package:living_way/core/core.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:pdfrx/pdfrx.dart';

class ContentController extends ChangeNotifier {
  final contentScrollController = ScrollController();
  final _storyCache = StoryCache();

  List<String> images = [Urls.imageApiUrl];
  List<Story> stories = [];
  List<Content> library = [];

  SortOptions threadActivityFilter = SortOptions.latest;
  List<ThreadData> threads = content.threads;

  bool isFetchingStories = false;
  bool isFetchingContents = false;

  int contentPageIndex = 1;
  bool contentHasReachedEnd = false;

  ContentController() {
    _init();
    contentScrollController.addListener(() {
      if (contentScrollController.position.pixels >
              (contentScrollController.position.maxScrollExtent * .7) &&
          !contentHasReachedEnd) {
        fetchContents();
      }
    });
  }

  Future<void> _init() async {
    await _storyCache.init();
    await loadCache();
    await fetchStories();
    await fetchContents();

    cleanResources(
        contentIds: stories.map((story) => story.id).toList(),
        path: '/stories',
        isTemp: true);
    cleanResources(
        contentIds:
            library.map((content) => '${content.id}-pdf-thumbnail').toList(),
        path: '/content',
        isTemp: true);
    cleanResources(
        contentIds: library.map((content) => content.title).toList());
  }

  Future<void> loadCache() async {
    images = await CacheService.instance
        .readData<List<String>>('images', defaultValue: [Urls.imageApiUrl]);
    stories = _storyCache.getAllSorted();

    final cachedLibrary = List.from(await CacheService.instance
        .readData<List<String>>('library', defaultValue: []));
    for (final contentJson in cachedLibrary) {
      final contentMap = jsonDecode(contentJson);

      int contentIndex =
          library.indexWhere((content) => content.id == contentMap['id']);

      if (contentIndex == -1) {
        library.add(Content.fromJson(jsonDecode(contentJson)));
      } else {
        library[contentIndex].updateFromJson(contentMap);
      }
    }

    final lastImagesFetched = DateTime.parse(await CacheService.instance
        .readData<String>('lastImagesFetched',
            defaultValue: DateTime.now().toString()));

    if (images.length == 1 ||
        DateTime.now().difference(lastImagesFetched).inDays > 7) {
      images = await ImageService.fetchImages(page: Random(15).toString());
      await CacheService.instance.writeData<List<String>>('images', images);
      await CacheService.instance
          .writeData<String>('lastImagesFetched', DateTime.now().toString());
    }

    notifyListeners();
  }

  void viewStory(String storyId) async {
    final story = _storyCache.getByKey(storyId);
    if (story == null || story.isViewed) return;

    AnalyticsService.logEvent('story_opened',
        parameters: {'story_id': storyId});

    story.isViewed = true;
    await story.save();
  }

  Future<void> fetchStories({bool isRefreshing = false}) async {
    if (isFetchingStories) return;

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      isFetchingStories = true;
      if (isRefreshing) {
        stories.clear();
      }

      notifyListeners();

      final response = await dio.get(
        '$url/api/v1/content/story',
      );

      if (!response.statusCode.isSuccess) return;

      final result =
          (response.data as List).map((json) => Story.fromJson(json)).toList();

      stories.addOrReplaceAll(result, (oldStory, newStory) {
        return oldStory.id == newStory.id;
      });
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 1), () {
        isFetchingStories = false;
        notifyListeners();
      });

      _sortStories();
      for (final story in stories) {
        await _storyCache.save(story);
      }
    }
  }

  Future<void> fetchContents({bool isRefreshing = false}) async {
    if (isFetchingContents) return;

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    const url = appFlavor == "dev"
        ? Urls.devApiUrl
        : appFlavor == "staging"
            ? Urls.stagingApiUrl
            : Urls.prodApiUrl;

    try {
      isFetchingContents = true;
      if (isRefreshing) {
        contentPageIndex = 1;
        contentHasReachedEnd = false;
        library.clear();
      }

      notifyListeners();

      final response = await dio.get('$url/api/v1/content',
          queryParameters: {"page": contentPageIndex});

      if (!response.statusCode.isSuccess) return;

      final result = (response.data as List)
          .map((json) => Content.fromJson(json))
          .toList();

      library.addOrReplaceAll(result, (oldContent, newContent) {
        return oldContent.id == newContent.id;
      });
      contentPageIndex++;
      contentHasReachedEnd = result.isEmpty;
    } catch (e) {
      logger.e(e);
    } finally {
      dio.close();
      Future.delayed(const Duration(seconds: 1), () {
        isFetchingContents = false;
        notifyListeners();
      });

      fetchDownloadedFiles();
    }
  }

  Future<void> fetchDownloadedFiles() async {
    for (final book in library) {
      final mediaStore = MediaStore();
      final fileName = "${book.title}.${book.fileType?.name}";
      final bool isRegistered = await mediaStore.isFileExist(
        fileName: fileName,
        dirType: DirType.download,
        dirName: DirName.download,
        relativePath: "Living Way",
      );

      if (!isRegistered) continue;

      final String filePath =
          "/storage/emulated/0/Download/Living Way/$fileName";

      book.file = File(filePath);
      book.filePath = filePath;
      book.notify();
    }
  }

  Future<void> _sortStories() async {
    stories
        .sort((storyA, storyB) => storyB.timestamp.compareTo(storyA.timestamp));
    stories.sort((_, storyB) => storyB.isViewed ? -1 : 1);

    notifyListeners();
  }

  void saveLibrary(Content pausedContent,
      {PdfViewerController? pdfController}) {
    final currentPageIndex = pdfController?.pageNumber ?? 1;
    final isContentStarted =
        currentPageIndex != 1 && currentPageIndex != pdfController?.pageCount;

    if (isContentStarted) {
      pausedContent.contentRemaining =
          currentPageIndex / (pdfController?.pageCount ?? 1);
      pausedContent.previouslyLeftOn = currentPageIndex;

      library.addOrReplace(
          pausedContent, (content) => content.id == pausedContent.id);
    }

    if (!isContentStarted) {
      final index =
          library.indexWhere((content) => content.id == pausedContent.id);

      if (index == -1) return;

      library[index].contentRemaining = null;
      library[index].previouslyLeftOn = null;
    }

    CacheService.instance.writeData<List<String>>(
        'library',
        library
            .where((content) => content.filePath != null)
            .map((content) => content.toString())
            .toList());

    notifyListeners();
  }

  set setThreadFilter(SortOptions value) {
    threadActivityFilter = value;
    notifyListeners();
  }
}
