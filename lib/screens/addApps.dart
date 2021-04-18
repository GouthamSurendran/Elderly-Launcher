import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class AddApps extends StatefulWidget {
  @override
  _AddAppsState createState() => _AddAppsState();

}

class _AddAppsState extends State<AddApps> {

  List<Widget> apps = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 5,bottom: 5),
        child: Container(
          margin: EdgeInsets.only(top:20),
            child: FutureBuilder(
              future: DeviceApps.getInstalledApplications(
                  includeSystemApps: true,
                  onlyAppsWithLaunchIntent: true,
                  includeAppIcons: true
              ),
              builder: (context,snap){
                if (snap.connectionState == ConnectionState.done && snap.hasData != null){
                  List<Application> allApps = snap.data;
                  return ListView.builder(
                      itemCount: allApps.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 70,
                          child: Card(
                              elevation: 0.15,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Image.memory((allApps[index] as ApplicationWithIcon).icon,width: 40,),
                                    SizedBox(width: 40,),
                                    Text(allApps[index].appName,style: TextStyle(fontSize: 24),),
                                  ],
                                ),
                              )),
                        );
                      });
                }
                else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  );
                }
              },
            ),
        ),
      ),
    );
  }
}
