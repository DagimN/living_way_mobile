import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
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
  static const AndroidNotificationAction addToCalendarAction =
      AndroidNotificationAction(
    'ADD_TO_CALENDAR',
    'Add to Calendar',
    showsUserInterface: true,
    cancelNotification: true,
  );
  static final DarwinNotificationCategory eventCategory =
      DarwinNotificationCategory(
    'EVENT_CATEGORY',
    actions: [
      DarwinNotificationAction.plain(
        'ADD_TO_CALENDAR',
        'Add to Calendar',
        options: {DarwinNotificationActionOption.foreground},
      ),
    ],
  );

  static Future<void> init({bool isForeground = true}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    const android = AndroidInitializationSettings('@drawable/ic_notification');
    final ios =
        DarwinInitializationSettings(notificationCategories: [eventCategory]);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await _plugin.initialize(
      settings: InitializationSettings(android: android, iOS: ios),
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
    String? imageUrl,
    String? payload,
  }) async {
    final filePath = imageUrl != null
        ? await _downloadAndSaveFile(imageUrl, 'notification_img_$id.jpg')
        : null;
    final androidDetails = AndroidNotificationDetails(
      'basic_channel',
      'Basic Alerts',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: filePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(filePath),
            )
          : null,
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

    if (payload.contains('event_start')) {
      _onCalendarEvent(payload);
    }
  }

  static Future<void> showEventNotification({
    required int id,
    required String title,
    required String body,
    required DateTime eventStart,
    String? imageUrl,
    DateTime? eventEnd,
    String location = '',
  }) async {
    String? filePath;

    if (imageUrl != null) {
      filePath =
          await _downloadAndSaveFile(imageUrl, 'notification_img_$id.jpg');
    }

    final payload = jsonEncode({
      'title': title,
      'description': body,
      'location': location,
      'event_start': eventStart.toIso8601String(),
      'event_end': (eventEnd ?? eventStart.add(const Duration(hours: 1)))
          .toIso8601String(),
      'all_day': false,
    });

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'event_channel',
      'Event Notifications',
      channelDescription: 'Notifications for upcoming events',
      importance: Importance.high,
      priority: Priority.high,
      actions: [addToCalendarAction],
      styleInformation: filePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(filePath),
            )
          : null,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'EVENT_CATEGORY',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  static void _onCalendarEvent(String payload) {
    final Map<String, dynamic> notificationPayload = jsonDecode(payload);
    final DateTime eventStart =
        DateTime.parse(notificationPayload['event_start']);
    final DateTime eventEnd = notificationPayload['event_end'] != null
        ? DateTime.parse(notificationPayload['event_end'])
        : eventStart.add(const Duration(hours: 1));

    final Event calendarEvent = Event(
      title: notificationPayload['title'] ?? 'Event',
      description: notificationPayload['description'] ?? '',
      location: notificationPayload['location'] ?? '',
      startDate: eventStart,
      endDate: eventEnd,
      allDay: notificationPayload['all_day'] == true,
    );

    Add2Calendar.addEvent2Cal(calendarEvent);
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
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
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

  static Future<void> periodicNotification(
      {required int id,
      String? title,
      String? body,
      String? imageUrl,
      String? payload}) async {
    await _plugin.periodicallyShow(
        id: id,
        title: title,
        body: body,
        payload: payload,
        repeatInterval: RepeatInterval.daily,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'periodic_channel',
            'Periodic Alerts',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
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
