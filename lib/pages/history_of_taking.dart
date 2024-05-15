import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:meds_tracker/services/database_helper.dart';

class HistoryOfTakingPage extends StatefulWidget {
  final int medicationID;

  const HistoryOfTakingPage({Key? key, required this.medicationID}) : super(key: key);

  @override
  _HistoryOfTakingPageState createState() => _HistoryOfTakingPageState();
}

class _HistoryOfTakingPageState extends State<HistoryOfTakingPage> {
  List<Map<String, dynamic>> history = [];
  String medicationName = ''; // Store the medication name

  @override
  void initState() {
    super.initState();
    loadMedicationName(); // Load medication name
    loadHistory();
  }

  Future<void> loadMedicationName() async {
    try {
      final medication = await DatabaseHelper.getMedicationNameById(widget.medicationID);
      setState(() {
        medicationName = medication.isNotEmpty ? medication[0]['medname'] : 'Unknown'; // Use 'Unknown' if medication not found
      });
    } catch (e) {
      print("Error loading medication name: $e");
    }
  }

  Future<void> loadHistory() async {
    try {
      final data = await DatabaseHelper.getMedicationTakenHistory(widget.medicationID);
      setState(() {
        history = data;
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
          // Format the time using intl package
          String formattedTime = DateFormat.yMMMd().add_jm().format(DateTime.parse(history[index]['time']));

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('$medicationName'), // Display medication name
              subtitle: Text('Taken at: $formattedTime'), // Display formatted time
            ),
          );
        },
      ),
    );
  }
}
