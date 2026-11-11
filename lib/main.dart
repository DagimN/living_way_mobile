import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:living_way/app.dart';
import 'package:living_way/core/core.dart';
import 'package:pdfrx/pdfrx.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.isEmpty) return;

  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
    await NotificationService.init(isForeground: false);
  }

  await NotificationService.handleIncomingNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await EasyLocalization.ensureInitialized();
  await pdfrxFlutterInitialize();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage
      .listen(NotificationService.handleIncomingNotification);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await NotificationService.init();
  DeepLinkService().initDeepLinks();

  runApp(const LivingWayApp());
}
