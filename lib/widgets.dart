import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_launcher/screens/moreInfo.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final int isDone;

  CardWidget({this.title, this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15),
      width: 300,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
          color: isDone ==1 ? Colors.white38 : Colors.white,
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
          Text(isDone == 1 ? "Done" : "Not Taken")
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

class NewsItem extends StatelessWidget {
  NewsItem(this.author, this.heading, this.imgUrl,this.content,this.fullUrl);

  final imgUrl;
  final heading;
  final author;
  final content;
  final fullUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: EdgeInsets.only(bottom: 2 ,top: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          elevation: 1,
          shadowColor: Colors.grey,
          color: Colors.white,
          child: Column(
              children: [
                // Container(
                //   child: Text(heading),
                // ),
                Row(children: [
                  Container(
                    child: Image.network(imgUrl),
                    height: 150,
                    width: 170,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // Padding(padding: EdgeInsets.only(top: 0)),
                        Container(
                          width: 200,
                          child: Text(heading,style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(author,style: TextStyle(fontWeight: FontWeight.w600),),
                        TextButton(
                          child: Text("Read More",style: TextStyle(fontWeight: FontWeight.w700),),
                          onPressed: () {
                            // this builds a new window with current news's content as argument
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return MoreInfo(author,heading,imgUrl,content,fullUrl);
                            }));
                          },
                        )
                      ],
                    ),
                  )
                ]),
              ]
          ),
        ),
      ),
    );
  }
}

