import 'package:flutter/material.dart';

import '../services/database_helper.dart';

class NewMedicationPage extends StatefulWidget {
  const NewMedicationPage({super.key});

  @override
  State<NewMedicationPage> createState() => _NewMedicationPageState();
}

class _NewMedicationPageState extends State<NewMedicationPage> {
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _remindersController = TextEditingController();
  final TextEditingController _prescDeadlineController =
  TextEditingController();

  @override
  void dispose() {
    _medNameController.dispose();
    _dosageController.dispose();
    _remindersController.dispose();
    _prescDeadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "New Medication",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 25,
            //fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _medNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a medicine name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter dosage',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _remindersController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter reminders',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _prescDeadlineController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter prescription deadline',
              ),
            ),
          ),

          // Save and Cancel Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  // Retrieve data from text fields
                  String medName = _medNameController.text;
                  String dosage = _dosageController.text;
                  String reminders = _remindersController.text;
                  String prescDeadline = _prescDeadlineController.text;

                  // Save data to the database
                  try {
                    await DatabaseHelper.createItem(
                      medName,
                      dosage,
                      prescDeadline,
                      reminders,
                      1, // Assuming active status is 1 for new medications
                    );

                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('New medication'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Medication Name: $medName'),
                            Text('Dosage: $dosage'),
                            Text('Reminders: $reminders'),
                            Text('Prescription Deadline: $prescDeadline'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    // Handle error
                    print("Error saving medication: $e");
                    // Optionally show a snackbar or dialog to inform the user about the error
                  }
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the home screen without saving
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
