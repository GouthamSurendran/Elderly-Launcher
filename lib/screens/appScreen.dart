import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:senior_launcher/screens/addApps.dart';
import 'package:senior_launcher/databaseHelper.dart';
import 'package:senior_launcher/models/app.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with AutomaticKeepAliveClientMixin <AppScreen>{

  List<String> allowedApps = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  Future getFilteredApps() async {
    List<App> apps =  await _databaseHelper.getApps();
    for(int i=0;i<apps.length;i++){
      allowedApps.add(apps[i].appName);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFilteredApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC0EDF7),
      body: FutureBuilder(
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
              child: GridView.count(crossAxisCount: 2,physics: BouncingScrollPhysics(),
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
                }),
              ),
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
      floatingActionButton: InkWell(
        onLongPress: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddApps())).then((value) => getFilteredApps());
        },
        child: FloatingActionButton(
          splashColor: Colors.greenAccent,
          onPressed: () {
          },
          child: Icon(IconData(58727, fontFamily: 'MaterialIcons'),
          size: 35,color: Colors.white,),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
