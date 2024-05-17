import 'package:flutter/material.dart';
import 'package:meds_tracker/pages/home.dart';
import 'package:meds_tracker/pages/new_medication.dart';
import 'package:meds_tracker/pages/history_of_taking.dart';
import 'package:meds_tracker/services/notification_helper.dart';
import 'package:meds_tracker/pages/Loading.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Light theme configuration
    final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.greenAccent,
        brightness:
            Brightness.light, // Explicitly set brightness for light theme
      ),
      useMaterial3: true,
    );

    // Dark theme configuration
    final ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.greenAccent,
        brightness: Brightness.dark, // Explicitly set brightness for dark theme
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme, // Use the light theme
      darkTheme: darkTheme, // Use the dark theme
      themeMode: ThemeMode.system, // Use system theme mode
      initialRoute: '/', // The initial route when the app starts
      routes: {
        '/': (context) => LoadingPage(),
        'second': (context) => const HomePage(),
        '/third': (context) => const NewMedicationPage(),
        '/fourth': (context) => const HistoryOfTakingPage(
              medicationID: 666,
            ),

        // Add more routes as needed
      },
      // hide DEBUG sticker
      debugShowCheckedModeBanner: false,
    );
  }
}
