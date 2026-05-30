import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:gal/gal.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

abstract class ImageService {
  static Future<bool> checkPermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }

    return status == PermissionStatus.granted;
  }

  static Future<List<File>> openGallery({int imageCount = 1}) async {
    try {
      final isGranted = await checkPermission();

      if (isGranted) {
        final result = await HLImagePicker().openPicker(
            pickerOptions: HLPickerOptions(
                maxSelectedAssets: imageCount,
                enablePreview: true,
                mediaType: MediaType.image,
                compressFormat: CompressFormat.jpg,
                compressQuality: .75));

        return result.map((item) => File(item.path)).toList();
      }
    } catch (error) {
      logger.e(error);
    }

    return [];
  }

  static Future<List<String>> fetchImages(
      {String page = '1',
      List<String> categories = const ['wallpapers', 'nature']}) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: Urls.unsplashApiUrl));
      final response = await dio.get('/search/photos', queryParameters: {
        'query': categories.join(','),
        'client_id': unsplasAccessKey,
        'page': page,
        'per_page': '30'
      });

      if (!response.statusCode.isSuccess) {
        logger.w({
          "data": response.data,
          "status": response.statusCode,
          "error": response.statusMessage
        });
        return [Urls.imageApiUrl];
      }

      if (response.headers.value('x-ratelimit-remaining') == '0') {
        logger.w('Rate limit exceeded for today.(UnsplashAPI)');
        return [Urls.imageApiUrl];
      }

      final data = List.from(response.data['results'])
          .map((item) => item['urls']['regular'] as String)
          .toList();

      return data;
    } catch (error) {
      logger.e(error);
      return [Urls.imageApiUrl];
    }
  }

  static Future<void> captureAndSaveImage(
      BuildContext context, GlobalKey key) async {
    try {
      final themeController =
          Provider.of<ThemeController>(context, listen: false);
      final isGranted = await checkPermission();

      if (!isGranted) {
        throw ErrorDescription(
            'Permission for accessing the storage is denied');
      }

      if (key.currentContext == null) {
        throw ErrorDescription('No context for the repaint boundary.');
      }

      RenderRepaintBoundary boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw ErrorDescription('Failed to get image data');
      }

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/verse_share.png').create();
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await Gal.putImage(file.path, album: 'Living Way');

      await file.delete();

      logger.i('Image successfully saved');
      UIService.showSnackbar(
          backgroundColor: AppTheme(themeController.brightness).successColor,
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(Tr.t('settings.saveSuccess')),
            ],
          ));
    } catch (e) {
      logger.e("Error capturing image: $e");
      UIService.showSnackbar(
          backgroundColor: Colors.redAccent,
          message: Tr.t('settings.saveError'));
    }
  }
}
