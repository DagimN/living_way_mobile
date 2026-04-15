import 'dart:io';

import 'package:dio/dio.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:living_way/core/config/env.dart';
import 'package:living_way/core/constants/urls.dart';
import 'package:living_way/core/services/logging_service.dart';
import 'package:permission_handler/permission_handler.dart';

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

      final data = List.from(response.data)
          .map((item) => item['urls']['regular'] as String)
          .toList();

      return data;
    } catch (error) {
      logger.e(error);
      return [Urls.imageApiUrl];
    }
  }
}
