import 'package:flutter/material.dart';
import 'package:meds_tracker/pages/home.dart';
import 'package:meds_tracker/pages/new_medication.dart';
import 'package:meds_tracker/pages/history_of_taking.dart';

void main() {
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
        '/': (context) => const HomePage(),
        '/second': (context) => const NewMedicationPage(),
        '/third': (context) => const HistoryOfTakingPage(medicationID: 666,),

        // Add more routes as needed
      },
    );
  }
}
