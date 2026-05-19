import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:living_way/app.dart';
import 'package:living_way/core/core.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.isEmpty) return;

  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
    await NotificationService.init(isForeground: false);
  }

  await _handleIncomingNotification(message);
}

Future<void> _handleIncomingNotification(RemoteMessage message) async {
  if (message.data.isEmpty) return;

  final notificationId =
      NotificationCodes.general.extendedCode(message.hashCode ~/ 10000);
  final imageUrl = (message.data['image'] as String?) ?? "";
  final payload = message.data['payload'] ?? "";

  if (payload.isNotEmpty && payload.contains('event_start')) {
    final event = jsonDecode(payload);
    await NotificationService.showEventNotification(
      id: notificationId,
      title: message.data['title'],
      body: message.data['body'],
      imageUrl: imageUrl.isEmpty ? null : imageUrl,
      location: event['location'],
      eventStart: DateTime.tryParse(event['event_start']) ?? DateTime.now(),
      eventEnd: event['event_end'] != null
          ? DateTime.tryParse(event['event_end'] ?? "")
          : null,
    );
  } else if (imageUrl.isNotEmpty) {
    await NotificationService.showImageNotification(
      id: notificationId,
      title: message.data['title'],
      body: message.data['body'],
      imageUrl: imageUrl,
      payload: message.data['payload'],
    );
  } else {
    await NotificationService.showNotification(
      id: notificationId,
      title: message.data['title'],
      body: message.data['body'],
      payload: message.data['payload'],
    );
  }

  await NotificationCache().init();
  await NotificationCache().save(Notification(
      id: notificationId.toString(),
      title: message.data['title'] ?? "",
      body: message.data['body'] ?? "",
      payload: message.data['payload'] ?? "",
      imageUrl: imageUrl));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await pdfrxFlutterInitialize();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_handleIncomingNotification);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await NotificationService.init();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Addis_Ababa'));

  runApp(const LivingWayApp());
  //TODO: Create a widget that can work as a base screen
}
