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
    );
  }
}
