import 'package:flutter/material.dart';
import 'new_medication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Meds Tracker",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 25,
            //fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(

        // Center text
        child: Text(
          'No meds today',
          style: TextStyle(fontSize: 25),
        ),
      ),

      // Button
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
              context,
          MaterialPageRoute(builder: (context) => NewMedicationPage()),
          );
        },
        child: const Icon( Icons.add_circle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
