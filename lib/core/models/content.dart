import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:image/image.dart' as image;

import '../enums.dart';
import '../services/logging_service.dart';

class Content {
  //TODO: Update name in the backend
  String id;
  String title;
  String presenter;
  String source;
  String? thumbnail;
  Uint8List? thumbnailData;
  File? file;
  FileType? fileType;
  bool isFetching = true;
  int? previouslyLeftOn;
  double? contentRemaining;

  Content(
      {required this.id,
      required this.title,
      required this.presenter,
      required this.source,
      this.thumbnail,
      this.previouslyLeftOn,
      this.contentRemaining}) {
    fileType = FileType.fromString(source.split('.').last);

    _loadContent().then((value) => _loadPdfThumbnail());
  }

  Future<void> _loadContent() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final Directory directory = Directory('${tempDir.path}/content');

      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      final file = File('${tempDir.path}/content/$id.${fileType?.name}');

      if (!file.existsSync()) {
        final response = await http.get(Uri.parse(source));
        await file.writeAsBytes(response.bodyBytes);
      }

      this.file = file;
    } catch (error) {
      logger.e(error);
    }
  }

  Future<void> _loadPdfThumbnail() async {
    try {
      if ((file == null || thumbnail != null) && fileType != FileType.pdf) {
        return;
      }

      final document = await PdfDocument.openFile(file!.path);
      final renderedPage = await document.pages[0].render();

      if (renderedPage == null) return;

      final pageImage = image.Image.fromBytes(
          width: renderedPage.width,
          height: renderedPage.height,
          bytes: renderedPage.pixels.buffer,
          order: image.ChannelOrder.bgra,
          numChannels: 4);

      thumbnailData = Uint8List.fromList(image.encodePng(pageImage));

      await document.dispose();
    } catch (error) {
      logger.e(error);
    } finally {
      isFetching = false;
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
        contentRemaining: map['contentRemaining']);
  }

  Map toJson() {
    return {
      "id": id,
      "title": title,
      "presenter": presenter,
      "source": source,
      "previouslyLeftOn": previouslyLeftOn,
      "contentRemaining": contentRemaining
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
