import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,

    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void>
  scheduleReminderNotification( TimeOfDay pickedTime) async {
    // Combine the picked time with the current date to get the scheduled time
    final now = DateTime.now();
    final scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
    );

    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Medication Reminder',
      'It is time to take your medication',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          importance: Importance.max,
          priority: Priority.high,
        ),

      ),
      //androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
