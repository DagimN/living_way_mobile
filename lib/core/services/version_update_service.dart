import 'dart:io';

import 'package:flutter/services.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

import '../constants/urls.dart';
import 'logging_service.dart';
import 'ui_service.dart';

class VersionCheckService {
  VersionCheckService();

  static Future<void> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version
          .replaceRange(info.version.indexOf('-'), info.version.length, "");
      const url = appFlavor == "dev"
          ? Urls.devApiUrl
          : appFlavor == "staging"
              ? Urls.stagingApiUrl
              : Urls.prodApiUrl;
      final dio = Dio(BaseOptions(
          baseUrl: '$url/api/v1/misc',
          connectTimeout: const Duration(seconds: 15)));

      final res = await dio.get('/');
      final data = res.data;

      final latestVersion = data['latest_version'];
      final minRequiredVersion = data['min_required_version'];
      final message = data['update_message'];

      if (_isOlderThan(current, minRequiredVersion)) {
        _showUpdateDialog(latestVersion, message, data, forceUpdate: true);
      }

      if (_isOlderThan(current, latestVersion)) {
        _showUpdateDialog(latestVersion, message, data, forceUpdate: false);
      }
    } catch (error) {
      logger.e(error);
    }
  }

  static bool _isOlderThan(String current, String target) {
    final currentVersion = current.split('.').map(int.parse).toList();
    final targetVersion = target.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (currentVersion[i] < targetVersion[i]) return true;
      if (currentVersion[i] > targetVersion[i]) return false;
    }

    return false;
  }

  static void _showUpdateDialog(String version, String message, Map data,
      {required bool forceUpdate}) {
    UIService.showCustomDialog(
        barrierDismissible: !forceUpdate,
        child: forceUpdate
            ? ForcedUpdateDialog(
                version: version,
                message: message,
                onUpdate: () => _openStore(data))
            : FlexibleUpdateDialog(
                version: version,
                message: message,
                onUpdate: () => _openStore(data)));
  }

  static Future<void> _openStore(Map data) async {
    final storeUrl =
        Platform.isAndroid ? data['android']['store'] : data['ios']['store'];
    final otherUrl =
        Platform.isAndroid ? data['android']['other'] : data['ios']['other'];
    final shouldUpdateFromStore = data['getFromStore'] ?? true;

    await launchUrl(Uri.parse(shouldUpdateFromStore ? storeUrl : otherUrl),
        mode: LaunchMode.externalApplication);
  }
}
