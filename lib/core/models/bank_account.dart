import 'dart:convert';

class BankAccount {
  final String name;
  final String account;
  final String logo;
  final bool isMain;
  final AppScheme scheme;

  BankAccount(
      {required this.name,
      required this.account,
      required this.logo,
      this.isMain = false,
      required this.scheme});

  factory BankAccount.fromMap(map) {
    return BankAccount(
        name: map['name'],
        account: map['account'],
        logo: map['logo'],
        isMain: map['isMain'],
        scheme: AppScheme.fromMap(map['appScheme']));
  }

  Map toMap() {
    return {
      'name': name,
      'account': account,
      'logo': logo,
      'isMain': isMain,
      'appScheme': scheme.toMap()
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

class AppScheme {
  final String? android;
  final String? playStore;
  final String? ios;
  final String? appStore;

  AppScheme({this.android, this.playStore, this.ios, this.appStore});

  factory AppScheme.fromMap(map) {
    return AppScheme(
        android: map['android'],
        playStore: map['playStore'],
        ios: map['ios'],
        appStore: map['appStore']);
  }

  Map toMap() {
    return {
      'android': android,
      'playStore': playStore,
      'ios': ios,
      'appStore': appStore
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
