import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:living_way/services/logging_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationController extends ChangeNotifier {
  NotificationController() {
    initializeOneSignal();
  }

  void initializeOneSignal() {
    OneSignal.Debug.setLogLevel(OSLogLevel.error);
    
    OneSignal.initialize(dotenv.env['ONE_SIGNAL_API_KEY']!);
    
    OneSignal.Notifications.requestPermission(true);

    OneSignalNotifications().addForegroundWillDisplayListener((event) {
      logger.i(event);
    });
  }
}
