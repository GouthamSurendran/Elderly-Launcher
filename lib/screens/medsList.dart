import 'package:flutter/material.dart';
import 'package:senior_launcher/medsWidget.dart';

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
  bool _hasTaken = false;

  FocusNode _nameFocus;
  FocusNode _descFocus;

  Future<void> showEditDialog(BuildContext context) async {
    return showDialog(context: context,
    builder: (context) {
      return AlertDialog(content: Container(
        height: 50,
        child: Column(children: [
          TextField(controller: TextEditingController()..text="Nice",)
        ],),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Update"),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],);
    }
    );
  }
  Future<void> showAddDialog(BuildContext context) async {
    return showDialog(context: context,
        builder: (context) {
          return AlertDialog(content: Container(
            height:100,
            child: Column(children: [
              TextField(controller: TextEditingController(),decoration: InputDecoration(
                  hintText: "Enter Medicine Name"
              ),),
              TextField(controller: TextEditingController(),decoration: InputDecoration(
                hintText: "Enter Description"
              ),)
            ],),
          ),
            actions: <Widget>[
              TextButton(
                child: Text("Add new Medicine"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],);
        }
    );
  }
  @override
  void initState() {
    super.initState();
    _timeOfDay = widget.tDay;

    _nameFocus = FocusNode();
    _descFocus = FocusNode();
  }

  void dispose() {
    _nameFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: SingleChildScrollView(
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
                                Navigator.pop(context);
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
                    // TextField(
                    //   focusNode: _nameFocus,
                    //   onSubmitted: (value){
                    //     _descFocus.requestFocus();
                    //   },
                    //   decoration: InputDecoration(
                    //     hintText: "Add new Medicine",
                    //     border: InputBorder.none,
                    //
                    //   ),
                    // ),
                    // TextField(
                    //   focusNode: _descFocus,
                    //   onSubmitted: (value){
                    //
                    //   },
                    //   decoration: InputDecoration(
                    //     hintText: "Enter description",
                    //     border: InputBorder.none,
                    //
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(icon: Icon(IconData(61522, fontFamily: 'MaterialIcons'),color: Colors.green,size: 45,), onPressed: (){
                        showAddDialog(context);
                      }),
                    ),
                    InkWell(
                        onLongPress: () async{
                          await showEditDialog(context);
                        },
                        child: MedsWidget(medName: "Ibuprofen",hasTaken: _hasTaken,desc: "1/2 dosage before food",)),
                    MedsWidget(medName: "Levipil 500",hasTaken: _hasTaken,desc: "After Food",),
                    MedsWidget(medName: "ZenRtard 250",hasTaken: _hasTaken,desc: "After Food",),
                  ],
                )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.greenAccent,
        onPressed: (){
          _hasTaken = !_hasTaken;
          setState(() {});
        },
        child: Icon(_hasTaken?IconData(61826, fontFamily: 'MaterialIcons'):IconData(59087, fontFamily: 'MaterialIcons')),
        backgroundColor:Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
