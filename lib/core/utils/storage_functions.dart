import 'dart:io';
import 'package:disk_space_2/disk_space_2.dart';
import 'package:living_way/core/core.dart';
import 'package:path/path.dart';
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

Future<String?> saveTranslationFile(String fileName, String contents) async {
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

Future<String?> getFilePath(String fileName) async {
  try {
    final applicationDocumentsDir = await getApplicationDocumentsDirectory();
    final downloadsDir = await getDownloadsDirectory();
    final publicDir = Directory(publicDirPath);

    final targetDirs = [applicationDocumentsDir, downloadsDir, publicDir]
        .whereType<Directory>();

    for (final dir in targetDirs) {
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);
      final fileExists = await file.exists();

      if (fileExists) {
        return filePath;
      }
    }

    return null;
  } catch (e) {
    logger.e('Error checking file existence: $e');
    return null;
  }
}

Future<List<File>> getStorageFiles() async {
  final directories = <Directory?>[
    await getExternalStorageDirectory(),
    await getApplicationDocumentsDirectory(),
    await getDownloadsDirectory(),
    Directory(publicDirPath),
  ];
  final files = <File>[];

  for (final directory in directories.whereType<Directory>()) {
    if (!await directory.exists()) continue;

    await for (final entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && !files.any((file) => file.path == entity.path)) {
        files.add(entity);
      }
    }
  }

  return files;
}

Future<void> cleanResources<T>(
    {required List<String> contentIds,
    String? path,
    bool isTemp = false}) async {
  final filePath = path != null
      ? path.startsWith('/')
          ? path
          : '/$path'
      : null;
  final parentDirectory = isTemp
      ? await getTemporaryDirectory()
      : await getApplicationDocumentsDirectory();
  final filesDirectory = Directory('${parentDirectory.path}$filePath');

  if (!await filesDirectory.exists()) return;

  final List<FileSystemEntity> files =
      await filesDirectory.list(recursive: false, followLinks: false).toList();

  for (final entity in files) {
    if (entity is File &&
        !contentIds.any((contentId) =>
            contentId == basenameWithoutExtension(entity.path))) {
      await entity.delete();
    }
  }
}
