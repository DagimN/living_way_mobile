import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

import '../enums.dart';
import '../services/logging_service.dart';

class Content {
  //TODO: Update name in the backend
  String title;
  String presenter;
  String source;
  String? thumbnail;
  Uint8List? thumbnailData;
  Uint8List? data;
  FileType? fileType;
  bool isFetching = true;

  Content(
      {required this.title,
      required this.presenter,
      required this.source,
      this.thumbnail}) {
    fileType = FileType.fromString(source.split('.').last);

    _loadContent().then((value) => _loadPdfThumbnail());
  }

  Future<void> _loadContent() async {
    try {
      final response = await http.get(Uri.parse(source));
      data = response.bodyBytes;
    } catch (error) {
      logger.e(error);
    }
  }

  Future<void> _loadPdfThumbnail() async {
    try {
      if ((data == null || thumbnail != null) && fileType != FileType.pdf) {
        return;
      }

      final document = await PdfDocument.openData(data!);
      final page = await document.getPage(1);
      final pageImage = await page.render(
        width: page.width / 2,
        height: page.height / 2,
        format: PdfPageImageFormat.png,
      );

      await page.close();
      await document.close();

      thumbnailData = pageImage?.bytes;
    } catch (error) {
      logger.e(error);
    } finally {
      isFetching = false;
    }
  }

  static Content fromJson(json) {
    return Content(
        title: json['title'],
        presenter: json['presenter'],
        source: json['source'],
        thumbnail: json['thumbnail']);
  }

  toJson() {
    return {"title": title, "presenter": presenter, "source": source};
  }
}
