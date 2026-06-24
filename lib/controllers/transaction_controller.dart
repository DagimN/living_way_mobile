import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionController extends ChangeNotifier {
  List<BankAccount> bankAccounts = [];

  TransactionController() {
    CacheService.instance
        .readData<List<String>>('bankAccounts', defaultValue: []).then((data) {
      bankAccounts =
          (data as List).map((item) => BankAccount.fromMap(item)).toList();
      sortAccounts();
      notifyListeners();
    });

    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    try {
      const url = appFlavor == "dev"
          ? Urls.devApiUrl
          : appFlavor == "staging"
              ? Urls.stagingApiUrl
              : Urls.prodApiUrl;
      final dio = Dio(BaseOptions(
          baseUrl: '$url/api/v1/misc/accounts',
          connectTimeout: const Duration(seconds: 15)));

      final res = await dio.get('/');
      final data = res.data['bankDetails'];

      bankAccounts =
          List.from(data).map((item) => BankAccount.fromMap(item)).toList();
      notifyListeners();
    } catch (error) {
      logger.e(error);
    } finally {
      await CacheService.instance.writeData<List<String>>('bankAccounts',
          bankAccounts.map((account) => account.toString()).toList());
      sortAccounts();
    }
  }

  void sortAccounts() {
    bankAccounts.sort((accountA, accountB) {
      if (accountA.isMain == accountB.isMain) return 0;
      return accountA.isMain ? -1 : 1;
    });
  }

  Future<bool> openBankApp(AppScheme scheme) async {
    Uri? appUri;

    if (Platform.isAndroid && scheme.android != null) {
      appUri = Uri.tryParse('android-app://${scheme.android}');
    }

    if (Platform.isIOS && scheme.ios != null) {
      appUri = Uri.tryParse(scheme.ios ?? "");
    }

    final canLaunchApp = appUri != null ? await canLaunchUrl(appUri) : false;

    if (!canLaunchApp) return false;

    final appLaunched =
        await launchUrl(appUri, mode: LaunchMode.externalApplication);

    if (appLaunched) return true;

    final storeUrl = Uri.tryParse(
        (Platform.isAndroid ? scheme.playStore : scheme.appStore) ?? "");

    final canLaunchStore =
        storeUrl != null ? await canLaunchUrl(storeUrl) : false;

    if (!canLaunchStore) return false;

    final storeLaunched =
        await launchUrl(storeUrl, mode: LaunchMode.externalApplication);

    if (storeLaunched) return true;

    return false;
  }
}
