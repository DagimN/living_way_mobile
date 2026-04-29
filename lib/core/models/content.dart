import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:living_way/core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:image/image.dart' as image;

class Content extends ChangeNotifier {
  //TODO: Update name in the backend
  String id;
  String title;
  String presenter;
  String source;
  String? thumbnail;
  Uint8List? thumbnailData;
  String? filePath;
  File? file;
  FileType? fileType;
  bool isFetching = true;
  int? previouslyLeftOn;
  double? contentRemaining;
  bool isDownloading = false;
  double? downloadProgress;

  Content(
      {required this.id,
      required this.title,
      required this.presenter,
      required this.source,
      this.filePath,
      this.thumbnail,
      this.previouslyLeftOn,
      this.contentRemaining}) {
    fileType = FileType.fromString((filePath ?? source).split('.').last);

    _loadPdfThumbnail();

    _loadFile();
  }

  Future<Uint8List?> _loadContent() async {
    try {
      final response = await http.get(Uri.parse(source));
      return response.bodyBytes;
    } catch (error) {
      logger.e(error);
      return null;
    }
  }

  Future<void> _loadPdfThumbnail() async {
    try {
      if (fileType != FileType.pdf || thumbnail != null) {
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final Directory directory = Directory('${tempDir.path}/content');
      final thumbnailFile =
          File('${tempDir.path}/content/$id-pdf-thumbnail.jpg');

      if (thumbnailFile.existsSync()) {
        thumbnailData = await thumbnailFile.readAsBytes();
        return;
      }

      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      final contentData = await _loadContent();

      if (contentData == null) return;

      final document = await PdfDocument.openData(contentData);
      final renderedPage = await document.pages[0].render();

      if (renderedPage == null) return;

      final pageImage = image.Image.fromBytes(
          width: renderedPage.width,
          height: renderedPage.height,
          bytes: renderedPage.pixels.buffer,
          order: image.ChannelOrder.bgra,
          numChannels: 4);

      final imageData =
          Uint8List.fromList(image.encodeJpg(pageImage, quality: 70));

      thumbnailFile.writeAsBytes(imageData, flush: true);
      thumbnailData = imageData;

      await document.dispose();
    } catch (error) {
      logger.e(error);
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  void _loadFile() {
    if (filePath == null) return;

    final file = File(filePath ?? "");

    if (file.existsSync()) {
      this.file = file;
    } else {
      filePath = null;
    }

    notifyListeners();
  }

  Future<void> downloadContent() async {
    isDownloading = true;
    notifyListeners();

    final dio = Dio();
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/$title.${fileType?.name}';

    try {
      final response = await dio.head(source);
      final size = response.headers.value('content-length');
      final canDownload = await canSafelyDownload(int.parse(size ?? '0'));

      if (!canDownload) {
        UIService.showSnackbar(
            message: 'Low Storage. Clear up some files before continuing',
            backgroundColor: Colors.redAccent);
        return;
      }

      downloadProgress = 0;
      notifyListeners();

      await dio.download(source, filePath,
          onReceiveProgress: (received, total) {
        downloadProgress = received / total;
        notifyListeners();
      });

      this.filePath = filePath;
      file = File(filePath);

      UIService.showSnackbar(
          message: '$title downloaded successfully',
          backgroundColor: const Color(0xFF16A085)); //TODO: Store in app theme
    } on FileSystemException catch (e) {
      if (e.message.toLowerCase().contains("no space left")) {
        logger.e("Critical Error: Device Storage Full.");

        UIService.showSnackbar(
            message: 'Low Storage. Clear up some files before continuing',
            backgroundColor: Colors.redAccent);

        final file = File(filePath);

        if (file.existsSync()) {
          file.deleteSync();
        }
      } else {
        logger.e("File System Error: ${e.message}");
      }
    } catch (error) {
      logger.e(error);
    } finally {
      dio.close();
      isDownloading = false;
      downloadProgress = null;
      notifyListeners();
    }
  }

  static Content fromJson(json) {
    final map = jsonDecode(json);

    return Content(
        id: map['id'],
        title: map['title'],
        presenter: map['presenter'],
        source: map['source'],
        thumbnail: map['thumbnail'],
        previouslyLeftOn: map['previouslyLeftOn'],
        contentRemaining: map['contentRemaining'],
        filePath: map['filePath']);
  }

  void updateFromJson(map) {
    previouslyLeftOn = map['previouslyLeftOn'];
    contentRemaining = map['contentRemaining'];
    filePath = map['filePath'];

    _loadFile();

    notifyListeners();
  }

  Map toJson() {
    return {
      "id": id,
      "title": title,
      "presenter": presenter,
      "source": source,
      "previouslyLeftOn": previouslyLeftOn,
      "contentRemaining": contentRemaining,
      "filePath": filePath
    };
  }

  void notify() {
    notifyListeners();
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
