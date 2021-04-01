import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:senior_launcher/models/medicine.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(),'meds_db.db'),
      onCreate: (db,version) async {
        await db.execute(
            "CREATE TABLE medicines(id INTEGER PRIMARY KEY, name TEXT, desc TEXT,timeOfDayId INTEGER, hasTaken INTEGER)",
        );
        return db;
      },
      version: 1,
    );
  }
}