import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:meds_tracker/services/database_helper.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('ic_launcher_playstore.png');
    InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          importance: Importance.max,
          priority: Priority.high),
    );
  }

  Future scheduleNotification(
      {String? medname, String? dosage,String? prescdeadline, int? active}) async{
   return NotificationManager._flutterLocalNotificationsPlugin;
  }
  }





