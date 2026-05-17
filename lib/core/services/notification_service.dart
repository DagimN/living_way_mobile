import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/DailyFeedScreen/widgets/updates_viewer_expanded.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel broadcastChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'Broadcast Notifications',
    description: 'This channel is used for global scripture broadcasts.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static Future<void> init({bool isForeground = true}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    const android = AndroidInitializationSettings('@drawable/ic_notification');
    const ios = DarwinInitializationSettings();

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _handleTap,
    );

    if (androidPlugin != null) {
      if (isForeground) {
        await androidPlugin.requestNotificationsPermission();
      }

      await androidPlugin.createNotificationChannel(broadcastChannel);
    }

    if (isForeground) {
      final notificationSettings = await messaging.requestPermission(
          alert: true, badge: true, sound: true);

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        await messaging.subscribeToTopic('general');
      }
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'basic_channel',
      'Basic Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload);
  }

  static Future<void> showImageNotification({
    required int id,
    required String title,
    required String body,
    required String imageUrl,
    String? payload,
  }) async {
    final String filePath =
        await _downloadAndSaveFile(imageUrl, 'notification_img_$id.jpg');

    final androidDetails = AndroidNotificationDetails(
      'image_channel',
      'Image Alerts',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(filePath),
      ),
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }

  static void showProgressNotification(int id, String title, int progress) {
    _plugin.show(
      id: id,
      title: 'Downloading $title',
      body: '$progress%',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'progress_id',
          'Downloads',
          channelDescription: 'Progress updates',
          importance: Importance.low,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          onlyAlertOnce: true,
        ),
      ),
    );
  }

  // Use Case 5: Media (Android only via StyleInformation) TODO: Improve layout
  static void showMedia(int id, String title, String artist) {
    _plugin.show(
      id: id,
      title: title,
      body: artist,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'media_id', 'Music',
          styleInformation:
              MediaStyleInformation(), // Handles native media layout
        ),
      ),
    );
  }

  static void _handleTap(NotificationResponse response) {
    final payload = response.payload;

    if (payload == null) return;

    if (payload == 'verseOfTheDay') {
      UIService.push(const UpdatesViewerExpanded());
    }

    //TODO: Hanlde event notifications for adding to calendar
  }

  static Future<void> scheduleNotification(
      {required int id,
      String? title,
      String? body,
      String? imageUrl,
      required DateTime scheduledDate,
      String? payload}) async {
    String? filePath;

    if (imageUrl != null) {
      filePath =
          await _downloadAndSaveFile(imageUrl, 'notification_img_$id.jpg');
    }

    await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate:
            _nextInstanceOfTime(scheduledDate.hour, scheduledDate.minute),
        payload: payload,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'scheduled_channel',
            'Scheduled Alerts',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: filePath != null
                ? BigPictureStyleInformation(
                    FilePathAndroidBitmap(filePath),
                  )
                : null,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  static Future<int> getValidId({NotificationCodes? code}) async {
    final activeNotifications = await _plugin.getActiveNotifications();
    final ids = activeNotifications.map((notification) => notification.id);

    while (true) {
      final notificationId = code != null
          ? code.extendedCode(Random().nextInt(100))
          : Random().nextInt(100);

      if (!ids.contains(notificationId)) {
        return notificationId;
      }
    }
  }
}
