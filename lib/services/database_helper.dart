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
      // prescdeadline is stored as TEXT in ISO8601 format, although it's called date
      await database.execute("""
      CREATE TABLE Medication(
        medicationID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        medname TEXT, 
        dosage TEXT,
        prescdeadline TEXT,  
        reminders TEXT,
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
      String? prescdeadline, String? reminders, int? active) async {
    try {
      final db = await DatabaseHelper.db();
      final data = {
        'medname': medname,
        'dosage': dosage,
        'prescdeadline': prescdeadline,
        'reminders': reminders,
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

  //Get items based on active status
  static Future<List<Map<String, dynamic>>> getItems(int active) async {
    try {
      final db = await DatabaseHelper.db();
      return db.query('Medication', where: "active = ?", whereArgs: [active]);
    } catch (e) {
      print("An error occurred while fetching items: $e");
      throw Exception("Failed to fetch items");
    }
  }

  static Future<void> deleteItem(int medicationId) async {
    try {
      final db = await DatabaseHelper.db();
      await db.delete('Medication', where: 'medicationID = ?', whereArgs: [medicationId]);
    } catch (e) {
      print("An error occurred while deleting medication: $e");
      throw Exception("Failed to delete medication");
    }
  }
}
