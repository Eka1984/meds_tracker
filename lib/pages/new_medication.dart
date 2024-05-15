import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meds_tracker/services/database_helper.dart';
import 'package:meds_tracker/services/ui_helper.dart';
import 'package:meds_tracker/services/notification_helper.dart';

class NewMedicationPage extends StatefulWidget {
  const NewMedicationPage({Key? key}) : super(key: key);

  @override
  State<NewMedicationPage> createState() => _NewMedicationPageState();
}

class _NewMedicationPageState extends State<NewMedicationPage> {
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _remindersController = TextEditingController();
  final TextEditingController _prescDeadlineController =
      TextEditingController();

  //A list for adding reminder times
  List<TimeOfDay> _reminders = [];

  void _addNewReminder() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _reminders.add(pickedTime);
      });
    }
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

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
              controller: _prescDeadlineController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter prescription deadline',
              ),
            ),
          ),

          Expanded(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _addNewReminder,
                  child: Text('Add Reminder'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminders[index];
                      return ListTile(
                        title: Text(
                            '${index + 1}. Reminder: ${reminder.format(context)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () => _removeReminder(index),
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ],
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
                  String prescDeadline = _prescDeadlineController.text;

                  // Save data to the database
                  try {
                    int newMedId = await DatabaseHelper.createItem(
                      medName,
                      dosage,
                      prescDeadline,
                      1, // Assuming active status is 1 for new medications
                    );

                    if (newMedId > 0) {
                      for (var reminder in _reminders) {
                        String formattedTime = reminder.format(context);
                        int reminderID = await DatabaseHelper.createReminder(
                            newMedId, formattedTime, 1);
                        NotificationHelper.scheduledNotification(reminderID,
                            "Hello!", "Time to take $medName", reminder);
                      }
                      UIHelper.showNotification(context, "$medName is added!");
                    }

                    // Navigate back to the home screen
                    Navigator.pop(context);
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
