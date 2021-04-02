import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:senior_launcher/models/medicine.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(),'meds_db.db'),
      onCreate: (db,version) async {
        await db.execute(
            "CREATE TABLE meds(id INTEGER PRIMARY KEY, name TEXT, desc TEXT,timeOfDayId INTEGER, hasTaken INTEGER)",
        );
        return db;
      },
      version: 1,
    );
  }

  Future<void> insertMed(Medicine medicine) async {
    Database _db = await database();
    await _db.insert('meds', medicine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Medicine>> getMeds(int timeOfDayId) async {
    Database _db = await database();
    List<Map<String, dynamic>> medsMap = await _db.rawQuery("SELECT * FROM meds WHERE timeOfDayId = $timeOfDayId");
    return List.generate(medsMap.length, (index) {
      return Medicine(
          id: medsMap[index]['id'],
          name: medsMap[index]['name'],
          desc: medsMap[index]['desc'],
          timeOfDayId: medsMap[index]['timeOfDayId'],
          hasTaken: medsMap[index]['hasTaken']
      );
    });
  }
}

