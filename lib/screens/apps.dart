import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:senior_launcher/screens/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_launcher/screens/medsRem.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:senior_launcher/widgets.dart';

class Apps extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  BouncingScrollPhysics _bouncingScrollPhysics = BouncingScrollPhysics();
  List<Contact> contacts = [];
  List<String> allowedApps = ['Chrome','Phone','Messages','Youtube','Photos','Settings'];
  String _timeString;

  @override
  void initState(){
    super.initState();
    getPermissions();
  }

  getPermissions() async{
    if(await Permission.contacts.request().isGranted){
      getAllContacts();
    }
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffC0EDF7),
        child: PageView(
          children: <Widget>[
            TimeWidget(),
            FutureBuilder(
              future: DeviceApps.getInstalledApplications(
                includeSystemApps: true,
                onlyAppsWithLaunchIntent: true,
                includeAppIcons: true
              ),
              builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.done){
                  List<Application> allApps = snapshot.data;
                  List<Application> filteredApps = allApps.where((app) => allowedApps.contains(app.appName)).toList();

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.count(crossAxisCount: 2,physics: _bouncingScrollPhysics,
                    children:List.generate(filteredApps.length, (index) {
                        return GestureDetector(
                          onTap: (){
                            DeviceApps.openApp(filteredApps[index].packageName);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.memory((filteredApps[index] as ApplicationWithIcon).icon,width: 80,),
                              SizedBox(height: 10),
                              Text("${filteredApps[index].appName}",style: TextStyle(
                                color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600
                              ),)
                            ],
                          ),
                        );
                    }),),
                  );
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              },
            ),
        ContactsPage(title: "Contacts",contact: contacts,),
        MedsRem()

          ],
        ),
      ),
    );
  }
}
