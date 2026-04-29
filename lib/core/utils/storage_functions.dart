import 'dart:io';
import 'package:disk_space_2/disk_space_2.dart';
import 'package:living_way/core/services/logging_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

loadJson(String path) async {
  return json.decode(await rootBundle.loadString(path));
}

Future<String?> readFile(String path) async {
  try {
    return await File(path).readAsString();
  } catch (error) {
    logger.e(error);
    return null;
  }
}

Future<String?> writeFile(String fileName, String contents) async {
  try {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/translations/$fileName';

    File file = File(path);
    await file.create(recursive: true);
    await file.writeAsString(contents, mode: FileMode.write);

    return path;
  } catch (error) {
    logger.e(error);
    return null;
  }
}

Future<bool> canSafelyDownload(int fileSizeInBytes) async {
  double? freeMB = await DiskSpace.getFreeDiskSpace;

  if (freeMB == null) return true;

  double fileMB = fileSizeInBytes / (1024 * 1024);

  const double systemBuffer = 50.0;

  return freeMB > (fileMB + systemBuffer);
}
