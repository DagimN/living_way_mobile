import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/DailyFeedScreen/widgets/updates_viewer_expanded.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@drawable/ic_notification');
    const ios = DarwinInitializationSettings();
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _handleTap,
    );
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
    //TODO: If app is on foreground, wait for an event a show the notification
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
        notificationDetails: notificationDetails);
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

  static void showProgressNotification(int id, int progress) {
    _plugin.show(
      id: id,
      title: 'Downloading...',
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
}
