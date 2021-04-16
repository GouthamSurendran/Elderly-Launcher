import 'package:flutter/material.dart';
import 'package:senior_launcher/databaseHelper.dart';
import 'package:senior_launcher/medsWidget.dart';
import 'package:senior_launcher/models/medicine.dart';

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
  int _timeOfDay;
  dynamic _hasTaken;

  FocusNode _nameFocus;
  FocusNode _descFocus;

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

    _nameFocus = FocusNode();
    _descFocus = FocusNode();
  }

  void dispose() {
    _nameFocus.dispose();
    _descFocus.dispose();
    nameController.dispose();
    descController.dispose();
    super.dispose();
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
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Text("Edit Medicine",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                  TextField(
                    controller: editNameController
                      ..text = snapshot.data[index].name,
                  ),
                  TextField(
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
                        style: TextStyle(color: Colors.redAccent),
                      )),
                  TextButton(
                    child: Text("Update Medicine info"),
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
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Text("Add Medicine",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                  TextField(
                    controller: nameController,
                    decoration:
                        InputDecoration(hintText: "Enter Medicine Name"),
                  ),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(hintText: "Enter Description"),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Add new Medicine"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
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
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.greenAccent,
        onPressed: () {
          markAsTaken();
        },
        child: Icon(_hasTaken == 1
            ? IconData(61826, fontFamily: 'MaterialIcons')
            : IconData(59087, fontFamily: 'MaterialIcons')),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
