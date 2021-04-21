import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_launcher/databaseHelper.dart';
import 'package:senior_launcher/screens/moreInfo.dart';
import 'package:senior_launcher/models/app.dart';

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
    if(mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 250,left: 10,right: 10),
      child: Column(
        children: [
          Container(
            child: Center(
              child: Text(_timeString,
                  style: GoogleFonts.josefinSans(
                      fontSize: 48,
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
      height: 200,
        child: Card(
          margin: EdgeInsets.only(top: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          elevation: 0.25,
          shadowColor: Colors.grey,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 0),
            child: Column(
                children: [
                  Row(children: [
                    Container(
                      child: imgUrl==""?Image.asset('assets/error.jpg'):Image.network(imgUrl),
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
                            padding: EdgeInsets.only(top: 20,bottom: 0),
                            width: 190,
                            child: heading == "No Internet Access"?Center(
                              child: Text(heading),
                            ):Text(heading.length<=120?heading:"${heading.substring(0,120)}...",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(
                            height: 16,
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

class AppCheckBox extends StatefulWidget {
  @override
  _AppCheckBoxState createState() => _AppCheckBoxState();

  final String packageName;

  AppCheckBox({this.packageName});

}

class _AppCheckBoxState extends State<AppCheckBox> {

  DatabaseHelper _databaseHelper = DatabaseHelper();

  dynamic filteredApps = [];
  dynamic _isAdded = false;

  void getFilteredApps() async {
    filteredApps =  await _databaseHelper.getApps();
    int flg = 0;
    for(int i=0;i<filteredApps.length;i++){
      if (filteredApps[i].packageName == widget.packageName){
        _isAdded  = true;
        flg = 1;
        break;
      }
    }
    if (flg == 0) _isAdded = false;
    setState(() {});
  }

  void addApp(App app) async {
    await _databaseHelper.addApp(app);
  }

  void removeApp(App app) async {
    String packageName = app.packageName;
    await _databaseHelper.removeApp(packageName);
  }

  @override
  void initState() {
    super.initState();
    getFilteredApps();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Checkbox(
          value: _isAdded,
          onChanged: (bool value) async{
            setState(() {
              _isAdded = value;
              App app = App(packageName: widget.packageName);
              _isAdded == true? addApp(app): removeApp(app);
            });
          },
        ),
    );
  }
}


