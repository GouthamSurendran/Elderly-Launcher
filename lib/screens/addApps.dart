import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:senior_launcher/widgets.dart';
import 'package:senior_launcher/models/app.dart';

class AddApps extends StatefulWidget {
  @override
  _AddAppsState createState() => _AddAppsState();
}

class _AddAppsState extends State<AddApps> {
  List<Widget> apps = [];
  List<App> filteredApps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: FutureBuilder(
            future: DeviceApps.getInstalledApplications(
                includeSystemApps: true,
                onlyAppsWithLaunchIntent: true,
                includeAppIcons: true),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData != null) {
                List<Application> allApps = snap.data;
                return ListView.builder(
                    itemCount: allApps.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 70,
                        child: Card(
                            elevation: 0.15,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 6, bottom: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.memory(
                                        (allApps[index] as ApplicationWithIcon)
                                            .icon,
                                        width: 40,
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Text(
                                        allApps[index].appName.length <= 14
                                            ? allApps[index].appName
                                            : "${allApps[index].appName.substring(0, 11)}...",
                                        style: TextStyle(fontSize: 24),
                                      )
                                    ],
                                  ),

                                  AppCheckBox(
                                    packageName: allApps[index].packageName,
                                  ),
                                  //checkbox for adding and deleting app in the database
                                ],
                              ),
                            )),
                      );
                    });
              } else {
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
