import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RemoteTranslationsLoader extends AssetLoader {
  const RemoteTranslationsLoader({required this.getStrings});

  final Function(Locale) getStrings;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return getStrings(locale);
  }
}
