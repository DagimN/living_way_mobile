import 'dart:io';

import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:living_way/services/logging_service.dart';
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
}
