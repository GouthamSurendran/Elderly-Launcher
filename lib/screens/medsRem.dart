import 'package:flutter/material.dart';
import 'package:senior_launcher/screens/medsList.dart';
import 'package:senior_launcher/widgets.dart';
import 'package:senior_launcher/databaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedsRem extends StatefulWidget {
  @override
  _MedsRemState createState() => _MedsRemState();
}

class _MedsRemState extends State<MedsRem> {

  int isDone1;
  int isDone2;
  int isDone3;
  DatabaseHelper _dbHelper = DatabaseHelper();

  final DateTime date = DateTime.now();
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    getHasTaken(0);
    getHasTaken(1);
    getHasTaken(2).then((value){
      getDateFromSharedPreferences();
    });
  }

  Future<void> getHasTaken(int day) async{
    if(day == 0)
    isDone1 = await _dbHelper.getHasTaken(0);
    else if (day == 1) isDone2 = await _dbHelper.getHasTaken(1);
    else isDone3 = await _dbHelper.getHasTaken(2);
    setState(() {
    });
  }

  Future<void> getDateFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStampPref = prefs.getString('date');
    String currDate = DateFormat('d MMM').format(DateTime.now()).toString();
    if (dateStampPref != null) {
      if (isDone1 == 1 && dateStampPref != currDate){
        await _dbHelper.markAsTaken(0).then((value) => getHasTaken(0));
      }
      if (isDone2 == 1 && dateStampPref != currDate){
        await _dbHelper.markAsTaken(1).then((value) => getHasTaken(1));
      }
      if (isDone3 == 1 && dateStampPref != currDate){
        await _dbHelper.markAsTaken(2).then((value) => getHasTaken(2));
      }
    }
  }                               // Using Shared Preferences to get the date of last checked

  Future<void> setDate(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('date', value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(25)),
            Text(
              "Medicine Reminder",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              "Medicine timetable for today - ${weekdays[date.weekday - 1]}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MedsList(tDay: 0))).then((value) => getHasTaken(0));
              },
              child: CardWidget(
                title: "Morning",
                isDone: isDone1,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MedsList(tDay: 1))).then((value) => getHasTaken(1));
              },
              child: CardWidget(
                title: "Afternoon",
                isDone: isDone2,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MedsList(tDay: 2))).then((value) {
                  getHasTaken(2).then((value) {
                    if (isDone3 == 1){
                      setDate(DateFormat('d MMM').format(DateTime.now()).toString());
                    }
                  } );
                }
                );
              },
              child: CardWidget(
                title: "Night",
                isDone: isDone3,
              ),
            ),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //         margin: EdgeInsets.only(bottom: 10),
            //         width: double.infinity,
            //         height: 60,
            //         padding: EdgeInsets.only(left: 10, right: 10),
            //         child: ElevatedButton(
            //           onPressed: () {},
            //           child: Text(
            //             "Need Help",
            //             style: TextStyle(fontSize: 24),
            //           ),
            //         )),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
