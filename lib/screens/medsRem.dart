import 'package:flutter/material.dart';
import 'package:senior_launcher/widgets.dart';

class MedsRem extends StatefulWidget {
  @override
  _MedsRemState createState() => _MedsRemState();
}

class _MedsRemState extends State<MedsRem> {
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
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(20)),
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
            CardWidget(
              title: "Morning",
              isDone: true,
            ),
            CardWidget(
              title: "Afternoon",
              isDone: false,
            ),
            CardWidget(
              title: "Night",
              isDone: false,
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
