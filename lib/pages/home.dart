import 'package:flutter/material.dart';
import 'new_medication.dart';
import 'package:meds_tracker/services/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List with data fetched from the database
  List<Map<String, dynamic>> myData = [];

  //Function refreshing myData variable and the list of meds
  _refreshData() async {
    final data = await DatabaseHelper.getItems(1);
    setState(() {
      myData = data;
    });
  }

  //Refreshing the list of meds on the first load of the page
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

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
      body: myData.isEmpty
          ? Center(
              child: Text(
                "No meds today",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: myData.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the column content fits snugly.
                    children: [
                      ListTile(
                        title: Text(myData[index]['medname']),
                        subtitle: Text(
                            '10:45'), // Assuming this is a placeholder for a dynamic value.
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopupMenuButton<String>(
                              onSelected: (String result) {
                                if (result == 'delete') {
                                  // Handle delete action
                                } else if (result == 'history') {
                                  // Handle history action
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'history',
                                  child: Text('History'),
                                ),
                              ],
                              icon: Icon(Icons
                                  .more_vert), // Icon for the menu (three vertical dots)
                            ),
                          ],
                        ),
                      ),
                      // Adding the full-width Take button below the ListTile
                      SizedBox(
                        width: double
                            .infinity, // Makes the button expand to fill the card width
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle 'Take' action here, such as marking the medication as taken
                          },
                          child: Text('Take'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary, // Button color
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimary, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

      // Button
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMedicationPage()),
          );
        },
        child: const Icon(Icons.add_circle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
