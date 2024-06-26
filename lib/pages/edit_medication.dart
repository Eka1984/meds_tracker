import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meds_tracker/services/database_helper.dart';
import '../services/ui_helper.dart';
import 'package:meds_tracker/services/notification_helper.dart';

class EditMedicationPage extends StatefulWidget {
  final Map<String, dynamic> medication;

  const EditMedicationPage({Key? key, required this.medication})
      : super(key: key);

  @override
  _EditMedicationPageState createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  List<TimeOfDay> _reminders = [];

  //Editing controllers
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _prescDeadlineController =
      TextEditingController();


  @override
  void initState() {
    super.initState();
    _refreshData();
    _medNameController.text = widget.medication['medname'] ?? '';
    _dosageController.text = widget.medication['dosage'] ?? '';
    _prescDeadlineController.text = widget.medication['prescdeadline'] ?? '';
  }

  @override
  void dispose() {
    _medNameController.dispose();
    _dosageController.dispose();
    _prescDeadlineController.dispose();
    super.dispose();
  }

  //Function for converting time from db into TimeOfDay format
  TimeOfDay fromString(String formattedString) {
    DateFormat format =
        DateFormat("h:mm a"); // For parsing incoming time strings
    DateTime dateTime = format.parse(formattedString);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  //Function for converting TimeOfDay object from the list into H.MM a String for storage in db
  String toFormattedString(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat("h:mm a").format(dt); // For outgoing time strings
  }

  //Fetching reminders from db, converting into TimeOfDay objects and putting into _reminders list
  void _refreshData() async {
    final data =
        await DatabaseHelper.getReminders(widget.medication['medicationID']);
    setState(() {
      _reminders = data.map((r) => fromString(r['time'])).toList();
    });
  }

  //Function that adds new reminder into _reminders list and db
  void _addNewReminder() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _reminders.add(pickedTime);
      });
      int reminderID = await DatabaseHelper.createReminder(
          widget.medication['medicationID'], toFormattedString(pickedTime), 1);
      NotificationHelper.scheduledNotification(
          reminderID,
          "Hello!",
          "Time to take ${widget.medication['medname']}",
          pickedTime,
          widget.medication['medicationID']);
      print('reminder created');
    }
  }

  //Function that removes a reminder time from the _reminders list and db
  void _removeReminder(TimeOfDay reminder) async {
    String formattedTime = toFormattedString(reminder);

    int reminderID = await DatabaseHelper.getReminderID(
        widget.medication['medicationID'], formattedTime);

    await NotificationHelper.deleteNotification(reminderID);

    await DatabaseHelper.deleteReminder(
        widget.medication['medicationID'], formattedTime);

    setState(() {
      _reminders.remove(reminder);
    });
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
        children: [
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
                labelText: 'Enter prescription deadline (dd.mm.yyyy)',
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
                          onPressed: () => _removeReminder(reminder),
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Validate the medication name
                  if (_medNameController.text.isEmpty) {
                    UIHelper.showNotification(
                        context, "Please enter a medication name.");
                    return; // Return to stop execution if validation fails
                  }

                  if (_prescDeadlineController.text.isNotEmpty) {
                    //Validate prescription date
                    bool isInputDate = UIHelper.isValidDateFormat(
                        _prescDeadlineController.text);
                    if (!isInputDate) {
                      UIHelper.showNotification(
                          context, "Please enter a date in correct format.");
                      return;
                    }
                    TimeOfDay timeForReminder = TimeOfDay(hour: 12, minute: 0);
                    NotificationHelper.scheduledNotificationForDate(
                        widget.medication['medicationID'],
                        'Hello!',
                        'Prescription for ${widget.medication['medName']} is expiring today',
                        _prescDeadlineController.text,
                        timeForReminder);
                  }

                  int result = await DatabaseHelper.updateItem(
                    widget.medication['medicationID'],
                    _medNameController.text,
                    _dosageController.text,
                    _prescDeadlineController.text,
                    1,
                  );
                  if (result > 0) {
                    UIHelper.showNotification(
                        context, "${widget.medication['medname']} is edited!");
                  }

                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
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
