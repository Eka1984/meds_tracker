import 'package:flutter/material.dart';

class NewMedicationPage extends StatefulWidget {
  const NewMedicationPage({super.key});

  @override
  State<NewMedicationPage> createState() => _NewMedicationPageState();
}

class _NewMedicationPageState extends State<NewMedicationPage> {
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
      body: const NewMedication(),
    );
  }
}

class NewMedication extends StatelessWidget {
  const NewMedication({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a medicine name',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter dosage',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter reminders',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter interval',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter prescription deadline',
            ),
          ),
        ),

        // save and cancel button
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('New medication'),
                  content: const Text('Your medication is saved'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
              ),
              ],
              ),
              );
            },
            child: Text('Save'),
        ),
        ElevatedButton(
          onPressed: () {
            // Add cancel logic here later
            Navigator.pop(context); // Close current page
            },
            child: Text('Cancel'),
          ),
        ],
        ),
      ],
    );
  }
}

