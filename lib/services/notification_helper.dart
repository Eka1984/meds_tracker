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

  //Repeating notification for meds
  static Future<void> scheduledNotification(int id, String title, String body,
      TimeOfDay time, int medicationID) async {
    var androidDetails = AndroidNotificationDetails(
        'important notifications', 'Meds Tracker',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'take_action_${medicationID}',
            'Take',
            showsUserInterface: true,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            'skip_action_${medicationID}',
            'Skip',
            showsUserInterface: true,
            cancelNotification: true,
          ),
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
        payload:
            'take_${medicationID}', // Adjusted payload to include action prefix
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents
            .time, // Ensures it repeats daily at the same time
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  //One time notification for prescription expiry date
  static Future<void> scheduledNotificationForDate(int id, String title,
      String body, String dateString, TimeOfDay time) async {
    // Parse the input date string
    List<String> dateParts = dateString.split('.');
    if (dateParts.length != 3) {
      throw FormatException("Invalid date format");
    }

    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    DateTime scheduledDateTime =
        DateTime(year, month, day, time.hour, time.minute);

    // Ensure the date is in the future
    if (scheduledDateTime.isBefore(DateTime.now())) {
      throw Exception("Scheduled date is in the past");
    }

    var androidDetails = AndroidNotificationDetails(
        'important notifications', 'Meds Tracker',
        importance: Importance.max, priority: Priority.high, ongoing: true);

    var iosDetails = DarwinNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    // Schedule the notification
    await _notification.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<void> deleteNotification(int id) async {
    await _notification.cancel(id);
  }

  static void handleAction(String payload) async {
    // Extract action and medicationID from payload
    List<String> parts = payload.split('_');
    String action = parts[0];
    int medicationID = int.parse(parts.last);

    // Handle actions based on the parsed action type
    if (action == 'take') {
      print("Taken");
      // Create a taken entry in the database
      int newEntry = await DatabaseHelper.createTakenEntry(medicationID);
      print(newEntry);
    } else if (action == 'skip') {
      print("Skipped");
    }
  }
}
