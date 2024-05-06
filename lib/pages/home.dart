import 'package:flutter/material.dart';
import 'package:meds_tracker/services/database_helper.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Await the future to get the result of the database insertion
            // int id = await DatabaseHelper.createItem(
            //     'vitamin c', '1 pill', '02.06.2024', 1);
            // Once the future completes, the result can be used immediately
            // List<Map<String, dynamic>> myData = [];
            // final data = await DatabaseHelper.getItems(1);
            // myData = data;
            // print(myData);
          } catch (e) {
            // If an error occurs, it will be caught here
            print('Failed to insert item: $e');
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add new medication', // Optional: Tooltip text on long press
      ),
    );
  }
}
