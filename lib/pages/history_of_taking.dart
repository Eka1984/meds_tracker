import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:meds_tracker/services/database_helper.dart';

class HistoryOfTakingPage extends StatefulWidget {
  final int medicationID;

  const HistoryOfTakingPage({Key? key, required this.medicationID})
      : super(key: key);

  @override
  _HistoryOfTakingPageState createState() => _HistoryOfTakingPageState();
}

class _HistoryOfTakingPageState extends State<HistoryOfTakingPage> {
  List<Map<String, dynamic>> history = [];
  String medicationName = '';

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize time zone data
    loadMedicationName();
    loadHistory();
  }

  Future<void> loadMedicationName() async {
    try {
      final medication =
          await DatabaseHelper.getMedicationNameById(widget.medicationID);
      setState(() {
        medicationName =
            medication.isNotEmpty ? medication[0]['medname'] : 'Unknown';
      });
    } catch (e) {
      print("Error loading medication name: $e");
    }
  }

  Future<void> loadHistory() async {
    try {
      final data =
          await DatabaseHelper.getMedicationTakenHistory(widget.medicationID);
      setState(() {
        history = data;
        print(
            "Data retrieved from DB: $history"); // Debug log for retrieved data
      });
    } catch (e) {
      print("Error loading history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History of Taking'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          // Parse the UTC time correctly
          DateTime utcTime = DateTime.parse(history[index]['time'] + 'Z');
          print("Stored UTC Time: $utcTime"); // Debug log for stored time

          // Convert UTC time to Finnish local time
          tz.Location helsinki = tz.getLocation('Europe/Helsinki');
          tz.TZDateTime finnishTime = tz.TZDateTime.from(utcTime, helsinki);
          print("Finnish Time: $finnishTime"); // Debug log for Finnish time

          // Format the time for display
          String formattedTime =
              DateFormat.yMMMd().add_jm().format(finnishTime);
          print(
              "Formatted Time: $formattedTime"); // Debug log for formatted time

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(medicationName),
              subtitle: Text('Taken at: $formattedTime'),
            ),
          );
        },
      ),
    );
  }
}
