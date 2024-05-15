import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {

  static Future<sql.Database> db() async {
    try {
      return sql.openDatabase(
        'medstracker.db',
        version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        },
      );
    } catch (e) {
      print("An error occurred while opening the database: $e");
      throw Exception("Failed to open the database");
    }
  }

  static Future<void> createTables(sql.Database database) async {
    try {
      // Create Medication table
      //prescdeadline is stored as TEXT in ISO8601 format, although it's called date
      await database.execute("""
      CREATE TABLE Medication(
        medicationID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        medname TEXT,
        dosage TEXT,
        prescdeadline TEXT,  
        active INTEGER
      )
      """);

      // Create Reminder table
      // Time can be stored as TEXT in 'HH:MM' format or as ISO8601
      await database.execute("""
      CREATE TABLE Reminder(
        reminderID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        medicationID INTEGER,
        time TEXT,  
        active INTEGER,
        FOREIGN KEY(medicationID) REFERENCES Medication(medicationID)
      )
    """);

      // Create MedicationTaken table
      await database.execute("""
      CREATE TABLE Medicationtaken(
        medicationtakenID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        medicationID INTEGER,
        time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
        FOREIGN KEY(medicationID) REFERENCES Medication(medicationID)
      )
    """);
    } catch (e) {
      print("An error occurred while creating tables: $e");
    }
  }

  // Create new medication entry
  static Future<int> createItem(String? medname, String? dosage,
      String? prescdeadline, int? active) async {
    try {
      final db = await DatabaseHelper.db();
      final data = {
        'medname': medname,
        'dosage': dosage,
        'prescdeadline': prescdeadline,
        'active': active
      };
      final id = await db.insert('Medication', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    } catch (e) {
      print("An error occurred while creating a new medication: $e");
      throw Exception("Failed to create a new medication");
    }
  }

  // Get items based on active status
  static Future<List<Map<String, dynamic>>> getItems(int active) async {
    try {
      final db = await DatabaseHelper.db();
      return db.query('Medication', where: "active = ?", whereArgs: [active]);
    } catch (e) {
      print("An error occurred while fetching items: $e");
      throw Exception("Failed to fetch items");
    }
  }

  // Create new medicationtaken entry
  static Future<int> createTakenEntry(int? medicationID) async {
    try {
      final db = await DatabaseHelper.db();
      final data = {
        'medicationID': medicationID,
      };
      final id = await db.insert('Medicationtaken', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    } catch (e) {
      print("An error occurred while creating a new medicationtaken entry: $e");
      throw Exception("Failed to create a new medicationtaken entry");
    }
  }


  // Delete a medication entry by id
  static Future<void> deleteItem(int medicationId) async {
    try {
      final db = await DatabaseHelper.db();
      await db.delete('Medication',
          where: 'medicationID = ?', whereArgs: [medicationId]);
    } catch (e) {
      print("An error occurred while deleting medication: $e");
      throw Exception("Failed to delete medication");
    }
  }


  // Add entry to Reminder table
  static Future<int> createReminder(
      int medicationID, String? time, int? active) async {
    try {
      final db = await DatabaseHelper.db();
      final data = {
        'medicationID': medicationID,
        'time': time,
        'active': active,
      };
      final id = await db.insert('Reminder', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    } catch (e) {
      print("An error occurred while creating a new reminder: $e");
      throw Exception("Failed to create a new reminder");
    }
  }

  // Update a medication entry by medicationID
  // Update a medication entry by id
  static Future<int> updateItem(int id, String? medname, String? dosage,
      String? prescdeadline, int? active) async {
    try {
      final db = await DatabaseHelper.db();

      final data = {
        'medname': medname,
        'dosage': dosage,
        'prescdeadline': prescdeadline,
        'active': active,
      };

      final result = await db.update('Medication', data,
          where: "medicationID = ?", whereArgs: [id]);
      return result;
    } catch (e) {
      print("An error occurred while updating a medication: $e");
      throw Exception("Failed to update a medication");
    }
  }

  //Get reminders based on medicationID
  static Future<List<Map<String, dynamic>>> getReminders(
      int medicationID) async {
    try {
      final db = await DatabaseHelper.db();
      return db.query('Reminder',
          where: "medicationID = ?",
          whereArgs: [medicationID]);
    } catch (e) {
      print("An error occurred while fetching reminders: $e");
      throw Exception("Failed to fetch reminders");
    }
  }

  // Update a reminder entry by id
  static Future<int> updateReminder(int? id, String? time, int? active) async {
    try {
      final db = await DatabaseHelper.db();

      final data = {
        'time': time,
        'active': active,
      };

      final result = await db
          .update('Reminder', data, where: "reminderID = ?", whereArgs: [id]);
      return result;
    } catch (e) {
      print("An error occurred while updating a reminder: $e");
      throw Exception("Failed to update a reminder");
    }
  }

  // Delete a medication entry by id
  static Future<void> deleteReminder(int medicationId, String time) async {
    try {
      final db = await DatabaseHelper.db();
      await db.delete('Reminder',
          where: 'medicationID = ? AND time = ?',
          whereArgs: [medicationId, time]);
    } catch (e) {
      print("An error occurred while deleting reminder: $e");
      throw Exception("Failed to delete reminder");
    }
  }

  // Get a single ReminderID by medicationID and time
  static Future<int> getReminderID(int medicationID, String time) async {
    try {
      final db = await DatabaseHelper.db();
      final List<Map<String, dynamic>> result = await db.query('Reminder',
          columns: ['reminderID'],
          where: 'medicationID = ? AND time = ?',
          whereArgs: [medicationID, time],
          limit: 1);

      if (result.isNotEmpty) {
        return result.first['reminderID'];
      } else {
        throw Exception("No reminder found for the given criteria.");
      }
    } catch (e) {
      print("An error occurred while fetching an item: $e");
      throw Exception("Failed to fetch an item");
    }
  }

  // // Create new medicationtaken entry
  // static Future<int> createTakenEntry(int? medicationID) async {
  //   try {
  //     final db = await DatabaseHelper.db();
  //     final data = {
  //       'medicationID': medicationID,
  //       'time': DateTime.now().toIso8601String(), // Include current timestamp
  //     };
  //     final id = await db.insert('Medicationtaken', data,
  //         conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //     return id;
  //   } catch (e) {
  //     print("An error occurred while creating a new medicationtaken entry: $e");
  //     throw Exception("Failed to create a new medicationtaken entry");
  //   }
  // }

  // Get taken times history for a specific medication, sorted by time (newest first)
  static Future<List<Map<String, dynamic>>> getMedicationTakenHistory(
      int medicationID) async {
    try {
      final db = await DatabaseHelper.db();
      return db.query('Medicationtaken',
          where: "medicationID = ?",
          whereArgs: [medicationID],
          orderBy: "time DESC");
    } catch (e) {
      print("An error occurred while fetching medication taken history: $e");
      throw Exception("Failed to fetch medication taken history");
    }
  }

  static Future<List<Map<String, dynamic>>> getMedicationNameById(
      int medicationID) async {
    try {
      final db = await DatabaseHelper.db();
      return db.query('Medication',
          where: "medicationID = ?", whereArgs: [medicationID]);
    } catch (e) {
      print("An error occurred while fetching medication name: $e");
      throw Exception("Failed to fetch medication name");
    }
  }
}

