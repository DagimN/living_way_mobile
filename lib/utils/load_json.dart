import 'dart:convert';

import 'package:flutter/services.dart';

loadJson(String path) async {
  return json.decode(await rootBundle.loadString(path));
}
