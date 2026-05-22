import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:image/image.dart' as image;
import 'package:provider/provider.dart';

class Content extends ChangeNotifier {
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
  bool isPopular;
  int? previouslyLeftOn;
  double? contentRemaining;
  bool isDownloading = false;
  double? downloadProgress;
  int? width;
  int? height;

  Content(
      {required this.id,
      required this.title,
      required this.presenter,
      required this.source,
      this.isPopular = false,
      this.filePath,
      this.fileType,
      this.thumbnail,
      this.previouslyLeftOn,
      this.contentRemaining}) {
    fileType ??= FileType.fromString((filePath ?? source).split('.').last);

    _loadPdfThumbnail().then((value) => _calculateThumbailSize());

    _loadFile();
  }

  factory Content.empty() {
    return Content(id: '', title: '', presenter: '', source: '');
  }

  Future<Uint8List?> _loadContent(String? url) async {
    try {
      final response = await http.get(Uri.parse(url ?? source));
      return response.bodyBytes;
    } catch (error) {
      logger.e(error);
      return null;
    }
  }

  Future<void> _loadPdfThumbnail() async {
    try {
      if (fileType != FileType.pdf) {
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

      final contentData = await _loadContent(thumbnail);

      if (contentData == null) return;

      if (thumbnail == null) {
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
      } else {
        thumbnailFile.writeAsBytes(contentData, flush: true);
        thumbnailData = contentData;
      }
    } catch (error) {
      logger.e(error);
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  Future<void> _calculateThumbailSize() async {
    if (thumbnailData == null) return;

    Image image = Image.memory(thumbnailData!);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
        width = info.image.width;
        height = info.image.height;

        notifyListeners();
      }),
    );
  }

  void _loadFile() {
    if (filePath == null) return;

    final file = File(filePath ?? "");

    if (file.existsSync()) {
      this.file = file;
    } else {
      filePath = null;
      previouslyLeftOn = null;
      contentRemaining = null;
    }

    notifyListeners();
  }

  Future<void> downloadContent(BuildContext context) async {
    isDownloading = true;
    notifyListeners();

    final themeController =
        Provider.of<ThemeController>(context, listen: false);
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/$title.${fileType?.name}';

    try {
      final response = await dio.head(source);
      final size = response.headers.value('content-length');
      final canDownload = await canSafelyDownload(int.parse(size ?? '0'));
      final notificationId = await NotificationService.getValidId(
          code: NotificationCodes.download);

      if (!canDownload) {
        UIService.showSnackbar(
            message: 'Low Storage. Clear up some files before continuing',
            backgroundColor: AppTheme(themeController.brightness).failedColor);
        return;
      }

      downloadProgress = 0;
      notifyListeners();

      await dio.download(source, filePath,
          onReceiveProgress: (received, total) async {
        downloadProgress = received / total;

        NotificationService.showProgressNotification(
          notificationId,
          title,
          (downloadProgress! * 100).toInt(),
        );
        notifyListeners();
      });

      this.filePath = filePath;
      file = File(filePath);

      NotificationService.cancelNotification(notificationId);

      UIService.showSnackbar(
        message: '$title downloaded successfully',
        backgroundColor: AppTheme(themeController.brightness).successColor,
      );
    } on FileSystemException catch (e) {
      if (e.message.toLowerCase().contains("no space left")) {
        logger.e("Critical Error: Device Storage Full.");

        UIService.showSnackbar(
            message: 'Low Storage. Clear up some files before continuing',
            backgroundColor: AppTheme(themeController.brightness).failedColor);

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

  static Content fromJson(map) {
    return Content(
        id: map['id'] ?? map['_id'],
        title: map['title'],
        presenter: map['presenter'],
        source: map['source'],
        thumbnail: map['thumbnail'],
        previouslyLeftOn: map['previouslyLeftOn'],
        contentRemaining: map['contentRemaining'],
        filePath: map['filePath'],
        fileType: map['fileType'] != null
            ? FileType.fromString(
                (map['fileType'] as String).replaceAll('.', ""))
            : null,
        isPopular: map['isPopular'] ?? false);
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
