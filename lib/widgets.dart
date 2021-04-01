import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final bool isDone;

  CardWidget({this.title, this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
          color: isDone ? Colors.white38 : Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 26,
                color: Colors.black54,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text(isDone ? "Done" : "Not Taken")
        ],
      ),
    );
  }
}

class TimeWidget extends StatefulWidget {
  @override
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  String _timeString;
  @override
  void initState() {
    super.initState();
    _getTime();
    Timer.periodic(Duration(seconds: 10), (Timer t) => _getTime());
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat('h:mm a\nEEEE,MMM d').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 250),
      child: Column(
        children: [
          Container(
            child: Center(
              child: Text(_timeString,
                  style: GoogleFonts.josefinSans(
                      fontSize: 55,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w600)),
            ),
          ),
          Container(
              child: Text('Elderly launcher v1.0',
                  style: GoogleFonts.josefinSans(
                      fontSize: 25, color: Colors.black87)))
        ],
      ),
    );
  }
}

