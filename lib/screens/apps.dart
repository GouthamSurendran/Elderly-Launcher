import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:senior_launcher/screens/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class Apps extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  BouncingScrollPhysics _bouncingScrollPhysics = BouncingScrollPhysics();
  List<Contact> contacts = [];

  @override
  void initState(){
    super.initState();
    getAppsList();
    getPermissions();
  }

  getAppsList() async {
    List<Application> _apps = await DeviceApps.getInstalledApplications
      (
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );                // Uses the device_apps package to retrieve the apps installed in the phone
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

  filterContacts() {
    //to be implemented
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: PageView(
          children: <Widget>[
            Container(
              child: Center(
                child: Text('Elderly Launcher',style: TextStyle(color: Colors.white,fontSize: 40),),
              ),
            ),
            FutureBuilder(
              future: DeviceApps.getInstalledApplications(
                includeSystemApps: true,
                onlyAppsWithLaunchIntent: true,
                includeAppIcons: true
              ),
              builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.done){
                  List<Application> allApps = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.count(crossAxisCount: 3,physics: _bouncingScrollPhysics,
                    children:List.generate(allApps.length, (index) {
                        return GestureDetector(
                          onTap: (){
                            DeviceApps.openApp(allApps[index].packageName);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.memory((allApps[index] as ApplicationWithIcon).icon,width: 60,),
                              Text("${allApps[index].appName}",style: TextStyle(
                                color: Colors.white
                              ),)
                            ],
                          ),
                        );
                    }),),
                  );
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
        ContactsPage(title: "Contacts",contact: contacts,) ],
        ),
      ),
    );
  }
}
