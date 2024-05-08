import 'package:flutter/material.dart';
import 'new_medication.dart';
import 'package:meds_tracker/services/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List with data fetched from the database
  List<Map<String, dynamic>> myData = [];

  //Function refreshing myData variable and the list of meds
<<<<<<< HEAD
  _refreshData() async {
=======
  Future<void> _refreshData() async {
>>>>>>> origin/Matilda
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
          ),
        ),
        centerTitle: true,
      ),
      body: myData.isEmpty
          ? Center(
<<<<<<< HEAD
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
                return InkWell(
                  onTap: () {
                    // Navigate to the details page when the card is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewMedicationPage()), // Replace DetailsPage with your actual page widget
                    );
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Ensures the column content fits snugly.
                      children: [
                        ListTile(
                          title: Text(myData[index]['medname']),
                          subtitle: Text(
                              '10:45'), // Placeholder for your dynamic value.
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
                                icon:
                                    Icon(Icons.more_vert), // Icon for the menu
                              ),
                            ],
                          ),
                        ),
                        // Full-width Take button
                        SizedBox(
                          width: double
                              .infinity, // Makes the button expand to fill the card width
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle 'Take' action here
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
=======
        child: Text(
          "No meds today",
          style: Theme.of(context).textTheme.headline6?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: myData.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigate to the details page when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewMedicationPage()),
              ).then((_) {
                // Refresh data when returning from NewMedicationPage
                _refreshData();
              });
            },
            child: Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(myData[index]['medname']),
                    subtitle: Text(myData[index]['prescdeadline']),
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
                          icon: Icon(Icons.more_vert),
>>>>>>> origin/Matilda
                        ),
                      ],
                    ),
                  ),
<<<<<<< HEAD
                );
              },
            ),
=======
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle 'Take' action here
                      },
                      child: Text('Take'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Theme.of(context).colorScheme.primary,
                        foregroundColor:
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
>>>>>>> origin/Matilda

      // Button
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMedicationPage()),
<<<<<<< HEAD
          );
        },
        child: const Icon(Icons.add_circle),
=======
          ).then((_) {
            // Refresh data when returning from NewMedicationPage
            _refreshData();
          });
        },
        child: Icon(Icons.add_circle),
>>>>>>> origin/Matilda
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
