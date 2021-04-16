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

  Future<void> updateMed(int id,name,desc) async{
    Database _db = await database();
    await _db.rawUpdate("UPDATE meds SET name='$name',desc='$desc' WHERE id='$id'");
  }

  Future<void> deleteMed(int id) async{
    Database _db = await database();
    await _db.rawDelete("DELETE FROM meds WHERE id='$id'");
  }

  Future<int> getHasTaken(int timeOfDayId) async{
    Database _db = await database();
    List<Map<String,dynamic>> hasTakenList = await _db.rawQuery("SELECT hasTaken from meds WHERE timeOfDayId='$timeOfDayId'");
    dynamic hasTaken = hasTakenList[0]['hasTaken'];
    return hasTaken;
  }

  Future<int> markAsTaken(int timeOfDayId) async{
    Database _db = await database();
    dynamic hasTaken = await getHasTaken(timeOfDayId);
    if (hasTaken == 0){
      hasTaken = 1;
      await _db.rawUpdate("UPDATE meds SET hasTaken='$hasTaken' WHERE timeOfDayId='$timeOfDayId'");
    }
    else {
      hasTaken = 0;
      await _db.rawUpdate("UPDATE meds SET hasTaken='$hasTaken' WHERE timeOfDayId='$timeOfDayId'");
    }
    return hasTaken;
  }

}



