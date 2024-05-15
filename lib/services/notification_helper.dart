import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:meds_tracker/services/database_helper.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notification.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      if (response.payload != null) {
        handleAction(response.payload!);
      }
    });

    tz.initializeTimeZones();
  }

  static Future<void> scheduledNotification(int id, String title, String body,
      TimeOfDay time, int medicationID) async {
    var androidDetails = AndroidNotificationDetails(
        'important notifications', 'Meds Tracker',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('take_action', 'Take',
              showsUserInterface: true, cancelNotification: true),
          AndroidNotificationAction('skip_action', 'Skip',
              showsUserInterface: true, cancelNotification: true)
        ]);

    var iosDetails = DarwinNotificationDetails();
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
        payload: medicationID.toString(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents
            .time, // Ensures it repeats daily at the same time
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<void> deleteNotification(int id) async {
    await _notification.cancel(id);
  }

  static void handleAction(String payload) async {
    // Parse medicationID from payload
    int medicationID = int.parse(payload);
    // Handle actions based on the payload
    if (payload.startsWith('take_action')) {
      print("Taken");
      // Create a taken entry in the database
      int newEntry = await DatabaseHelper.createTakenEntry(medicationID);
      print(newEntry);
    } else if (payload.startsWith('skip_action')) {
      print("Skipped");
    }
  }
}
