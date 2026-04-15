import 'package:flutter/material.dart';
import 'package:living_way/core/config/env.dart';
import 'package:living_way/core/services/logging_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationController extends ChangeNotifier {
  NotificationController() {
    initializeOneSignal();
  }

  void initializeOneSignal() {
    OneSignal.Debug.setLogLevel(OSLogLevel.error);

    OneSignal.initialize(oneSignalApiKey);

    OneSignal.Notifications.requestPermission(true);

    OneSignalNotifications().addForegroundWillDisplayListener((event) {
      logger.i(event);
    });
  }
}
