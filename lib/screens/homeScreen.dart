import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:torch_compat/torch_compat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _timeString;
  bool isLightOn;
  final numberController = TextEditingController();
  final numberController2 = TextEditingController();
  String num_1 = "";
  String num_2 = "";

  @override
  void initState() {
    super.initState();
    getNums();
    _getTime();
    Timer.periodic(Duration(seconds: 10), (Timer t) => _getTime());
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat('   h:mm a\nEEEE, MMM d').format(DateTime.now()).toString();
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  void getNums() async {
    num_1 = await getNumFromSharedPreferences(1);
    num_2 = await getNumFromSharedPreferences(2);
    numberController..text = num_1;
    numberController2..text = num_2;
    setState(() {});
  }

  Future<String> getNumFromSharedPreferences(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('num_$id');
    return number;
  }

  Future<void> setNum(dynamic value, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('num_$id', value);
  }

  Future<void> showEditDialog(int id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    controller: id == 1 ? numberController : numberController2,
                    decoration:
                        InputDecoration(hintText: "Enter Emergency number $id"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent),
                    onPressed: () {
                      dynamic number = id == 1
                          ? numberController.text
                          : numberController2.text;
                      setNum(number, id).then((value) {
                        getNums();
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Set Emergency Contact $id"),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 250, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                child: Center(
                  child: Text(_timeString,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 44,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Container(
                  child: Text('Elderly launcher v1.0',
                      style: GoogleFonts.josefinSans(
                          fontSize: 25, color: Colors.black87))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(num_1);
                    },
                    onLongPress: () {
                      showEditDialog(1);
                    },
                    child: Text(
                      "Emergency 1",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26)),
                        primary: Colors.deepOrangeAccent),
                  ),
                ),
                Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                    onPressed: () {
                      isLightOn = isLightOn == true ? false : true;
                      isLightOn == true
                          ? TorchCompat.turnOn()
                          : TorchCompat.turnOff();
                      setState(() {});
                    },
                    child: Stack(children: <Widget>[
                      Icon(
                        isLightOn == true
                            ? IconData(62037, fontFamily: 'MaterialIcons')
                            : IconData(57894, fontFamily: 'MaterialIcons'),
                        size: 50,
                        color: isLightOn == true
                            ? Colors.yellowAccent
                            : Colors.black54,
                      ),
                      Icon(
                        IconData(57894, fontFamily: 'MaterialIcons'),
                        size: 50,
                        color: Colors.black38,
                      ),
                    ]),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26)),
                        primary: Colors.white),
                  ),
                ),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(num_2);
                    },
                    onLongPress: () {
                      showEditDialog(2);
                    },
                    child: Text(
                      "Emergency 2  ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26)),
                        primary: Colors.deepOrangeAccent),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
