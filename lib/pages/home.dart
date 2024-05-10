import 'package:flutter/material.dart';
import 'new_medication.dart';
import 'package:meds_tracker/services/database_helper.dart';
import 'package:meds_tracker/services/ui_helper.dart';
import 'package:meds_tracker/pages/edit_medication.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List with data fetched from the database
  List<Map<String, dynamic>> myData = [];

  Future<void> _refreshData() async {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditMedicationPage(medication: myData[index]),
                      ),
                    ).then((_) {
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
                                onSelected: (String result) async {
                                  if (result == 'delete') {
                                    bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm Delete"),
                                          content: Text(
                                              "Are you sure you want to delete ${myData[index]['medname']}?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false), // Cancel
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true), // Delete
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmDelete == true) {
                                      await DatabaseHelper.deleteItem(
                                          myData[index]['medicationID']);
                                      _refreshData();
                                    }
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
                              ),
                            ],
                          ),
                        ),
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

      // Button
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMedicationPage()),
          ).then((_) {
            _refreshData();
          });
        },
        child: Icon(Icons.add_circle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
