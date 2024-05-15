import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()));
    tz.initializeTimeZones();
  }

  static scheduledNotification(
      int id, String title, String body, TimeOfDay time) async {
    var androidDetails = AndroidNotificationDetails(
        'important notifications', 'Meds Tracker',
        importance: Importance.max, priority: Priority.high);

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Calculate the next scheduled date based on TimeOfDay
    final now = DateTime.now();
    final todayAtTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(todayAtTime, tz.local);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1)); // Next day
    }

    // Schedule the notification
    await _notification.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents
            .time, // Ensures it repeats daily at the same time
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<void> deleteNotification(int id) async {
    await _notification.cancel(id);
  }

  // static scheduledNotification(String title, String body) async {
  //   var androidDetails = AndroidNotificationDetails(
  //       'important notifications', 'Meds Tracker',
  //       importance: Importance.max, priority: Priority.high);
  //
  //   var iosDetails = const DarwinNotificationDetails();
  //
  //   var notificationDetails =
  //       NotificationDetails(android: androidDetails, iOS: iosDetails);
  //
  //   await _notification.periodicallyShow(
  //       0, title, body, RepeatInterval.everyMinute, notificationDetails,
  //       androidAllowWhileIdle: true);
  // }

  // static scheduledNotification(String title, String body) async {
  //   var androidDetails = AndroidNotificationDetails(
  //       'important notifications', 'Meds Tracker',
  //       importance: Importance.max, priority: Priority.high);
  //
  //   var iosDetails = const DarwinNotificationDetails();
  //
  //   var notificationDetails =
  //       NotificationDetails(android: androidDetails, iOS: iosDetails);
  //
  //   await _notification.zonedSchedule(
  //       0,
  //       title,
  //       body,
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
  //       notificationDetails,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  // }

  // static Future _notificationDetails() async {
  //   return NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'channel id',
  //       'channel name',
  //       // 'channel description',
  //       importance: Importance.max,
  //     ),
  //     // iOS: DarwinNotificationDetails(),
  //   );
  // }
  //
  // static Future showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payload,
  // }) async =>
  //     _notifications.show(
  //       id,
  //       title,
  //       body,
  //       await _notificationDetails(),
  //       payload: payload,
  //     );
  //
  // static Future showScheduledNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payload,
  //   required DateTime scheduledDate,
  // }) async =>
  //     _notifications.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tz,
  //       TZDateTime.from(scheduledDate, tz.local),
  //       await _notificationDetails(),
  //       payload: payload,
  //       // androidScheduleMode: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //     );
}
