import 'dart:io';
import 'package:living_way/services/logging_service.dart';
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
