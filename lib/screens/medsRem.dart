import 'package:flutter/material.dart';
import 'package:senior_launcher/screens/medsList.dart';
import 'package:senior_launcher/widgets.dart';
import 'package:senior_launcher/databaseHelper.dart';

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
    getHasTaken();
  }

  void getHasTaken() async{
    isDone1 = await _dbHelper.getHasTaken(0);
    isDone2 = await _dbHelper.getHasTaken(1);
    isDone3 = await _dbHelper.getHasTaken(2);
    setState(() {
    });
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
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MedsList(tDay: 0))).then((value) => getHasTaken());
              },
              child: CardWidget(
                title: "Morning",
                isDone: isDone1,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MedsList(tDay: 1))).then((value) => getHasTaken());
              },
              child: CardWidget(
                title: "Afternoon",
                isDone: isDone2,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MedsList(tDay: 2))).then((value) => getHasTaken());
              },
              child: CardWidget(
                title: "Night",
                isDone: isDone3,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    height: 60,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Need Help",
                        style: TextStyle(fontSize: 24),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
