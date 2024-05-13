import 'package:flutter/material.dart';
import 'package:meds_tracker/services/database_helper.dart';

class EditMedicationPage extends StatefulWidget {
  final Map<String, dynamic> medication;

  const EditMedicationPage({Key? key, required this.medication})
      : super(key: key);

  @override
  _EditMedicationPageState createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  List<Map<String, dynamic>> remindersData = [];

  // Function refreshing reminderData variable
  _refreshData() async {
    final data = await DatabaseHelper.getReminders(widget.medication['medicationID']);
    setState(() {
      remindersData = data;
      // Join all reminder times with a separator, e.g., ", "
      _remindersController.text = remindersData.map((reminder) => reminder['time']).join(", ");
    });
  }

  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _remindersController = TextEditingController();
  final TextEditingController _prescDeadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Refreshing the reminders
    _refreshData();

    // Initialize the text controllers with the medication data passed to the page
    _medNameController.text = widget.medication['medname'] ?? '';
    _dosageController.text = widget.medication['dosage'] ?? '';
    _prescDeadlineController.text = widget.medication['prescdeadline'] ?? '';
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
          "${widget.medication['medname']}",
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
                  int medicationID = widget.medication['medicationID'];
                  String medName = _medNameController.text;
                  String dosage = _dosageController.text;
                  String reminders = _remindersController.text;
                  String prescDeadline = _prescDeadlineController.text;
                  int firstReminderID = remindersData.isNotEmpty ? remindersData[0]['reminderID'] : 0;

                  // Save data to the database
                  try {
                    await DatabaseHelper.updateItem(
                      medicationID,
                      medName,
                      dosage,
                      prescDeadline,
                      1, // Assuming active status is 1 for new medications
                    );

                    if (remindersData.isNotEmpty) {
                      await DatabaseHelper.updateReminder(
                        firstReminderID,
                        reminders,
                        1,
                      );
                    }

                    // Navigate back to the home screen
                    Navigator.pop(context, true);
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