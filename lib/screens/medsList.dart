import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senior_launcher/databaseHelper.dart';
import 'package:senior_launcher/medsWidget.dart';
import 'package:senior_launcher/models/medicine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior_launcher/notifications.dart';

class MedsList extends StatefulWidget {
  final int tDay;

  MedsList({this.tDay});
  @override
  _MedsListState createState() => _MedsListState();
}

getTimeOfDay(int t) {
  if (t == 0)
    return "Morning";
  else if (t == 1)
    return "Afternoon";
  else
    return "Night";
}

class _MedsListState extends State<MedsList> {
  final NotificationService notificationService = NotificationService();
  TimeOfDay givenTime = TimeOfDay(hour: 00, minute: 00);
  int _timeOfDay;
  dynamic _hasTaken;
  TimeOfDay picked;

  FocusNode _desc1Focus;
  FocusNode _desc2Focus;

  final nameController = TextEditingController();
  final descController = TextEditingController();

  final editNameController = TextEditingController();
  final editDescController = TextEditingController();
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _timeOfDay = widget.tDay;
    getHasTaken();
    getTimeFromSharedPreferences().then((value) {
      givenTime = timeConvert(value);
      setState(() {});
    });
    notificationService.initialize();
    _desc1Focus = FocusNode();
    _desc2Focus = FocusNode();
  }

  void dispose() {
    _desc1Focus.dispose();
    _desc2Focus.dispose();
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

    TimeOfDay timeConvert(String normTime) {
      int hour;
      int minute;
      String ampm = normTime.substring(normTime.length - 2);
      String result = normTime.substring(0, normTime.indexOf(' '));
      if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
        hour = int.parse(result.split(':')[0]);
        if (hour == 12) hour = 0;
        minute = int.parse(result.split(":")[1]);
      } else {
        hour = int.parse(result.split(':')[0]) - 12;
        if (hour <= 0) {
          hour = 24 + hour;
        }
        minute = int.parse(result.split(":")[1]);
      }
      return TimeOfDay(hour: hour, minute: minute);
    }

  void getHasTaken() async {
    _hasTaken = await _dbHelper.getHasTaken(_timeOfDay);
    setState(() {});
  }

  Future<void> showEditDialog(BuildContext context, snapshot, index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Text(
                    "Edit Medicine",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: editNameController
                      ..text = snapshot.data[index].name,
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_desc1Focus);
                    },
                  ),
                  TextField(
                    focusNode: _desc1Focus,
                    controller: editDescController
                      ..text = snapshot.data[index].desc,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        deleteMed(snapshot.data[index].id);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Delete Med",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700),
                      )),
                  TextButton(
                    child: Text(
                      "Update Medicine info",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      editMed(snapshot.data[index].id, editNameController.text,
                          editDescController.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> showAddDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Text(
                    "Add Medicine",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: nameController,
                    decoration:
                        InputDecoration(hintText: "Enter Medicine Name"),
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_desc2Focus);
                    },
                  ),
                  TextField(
                    focusNode: _desc2Focus,
                    controller: descController,
                    decoration: InputDecoration(hintText: "Enter Description"),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Add new Medicine",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onPressed: () {
                  if (nameController.text != "") {
                    insertMed();
                  }
                  Navigator.of(context).pop();
                  nameController..text = "";
                  descController..text = "";
                },
              ),
            ],
          );
        });
  }

  void insertMed() async {
    if (nameController.text != null) {
      Medicine _newMed = Medicine(
          name: nameController.text,
          desc: descController.text,
          timeOfDayId: _timeOfDay,
          hasTaken: 0);
      await _dbHelper.insertMed(_newMed);
      setState(() {});
    }
  }

  void editMed(int medId, String medName, String medDesc) async {
    await _dbHelper.updateMed(medId, medName, medDesc);
    setState(() {});
  }

  void deleteMed(int medId) async {
    if (medId != 0) {
      await _dbHelper.deleteMed(medId);
    }
    setState(() {
      nameController..text = "";
      descController..text = "";
    });
  }

  void markAsTaken() async {
    _hasTaken = await _dbHelper.markAsTaken(_timeOfDay);
    setState(() {});
  }

  Future<String> getTimeFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final timePref = prefs.getString('time_$_timeOfDay');
    if (timePref != null) {

    }
    return timePref;
  }                               // Using Shared Preferences to get the date of last checked

  Future<void> setTime(dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('time_$_timeOfDay', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                padding: EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context, _hasTaken);
                        },
                        child: Icon(
                          IconData(58791,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      getTimeOfDay(_timeOfDay),
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: IconButton(
                  icon: Icon(
                    IconData(58735, fontFamily: 'MaterialIcons'),
                    color: Colors.green,
                    size: 50,
                  ),
                  onPressed: () {
                    showAddDialog(context);
                  }),
            ),
            FutureBuilder(
              initialData: [],
              future: _dbHelper.getMeds(_timeOfDay),
              builder: (context, snapshot) {
                return Expanded(
                    child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onLongPress: () async {
                          await showEditDialog(context, snapshot, index);
                        },
                        // child: Text(snapshot.data[index].name),
                        child: MedsWidget(
                          medName: snapshot.data[index].name,
                          hasTaken: snapshot.data[index].hasTaken,
                          desc: snapshot.data[index].desc,
                        ),
                      );
                    } else
                      return Text("");
                  },
                ));
              },
            ),
          ],
        ),
        //),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onLongPress: () async {
              picked = await showTimePicker(
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                          primary: Colors.blue, onSurface: Colors.green),
                      buttonTheme: ButtonThemeData(
                        colorScheme: ColorScheme.light(
                          primary: Colors.green,
                        ),
                      ),
                    ),
                    child: child,
                  );
                },
                initialTime: givenTime,
                initialEntryMode: TimePickerEntryMode.input,
              );
              if(picked!=null){
                setTime(picked.format(context));
                getTimeFromSharedPreferences().then((value) {
                  givenTime = timeConvert(value);
                  setState(() {});
                });
                final now = new DateTime.now();
                DateTime dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                notificationService.scheduledNotification(dateTime);
              }
            },
            child: FloatingActionButton(
              heroTag: "fab1",
              splashColor: Colors.greenAccent,
              onPressed: () {},
              child: Icon(IconData(0xea7f, fontFamily: 'MaterialIcons')),
              backgroundColor: Colors.black54,
            ),
          ),
          FloatingActionButton(
            heroTag: "fab2",
            splashColor: Colors.greenAccent,
            onPressed: () {
              markAsTaken();
            },
            child: Icon(_hasTaken == 1
                ? IconData(61826, fontFamily: 'MaterialIcons')
                : IconData(59087, fontFamily: 'MaterialIcons')),
            backgroundColor: Colors.green,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
