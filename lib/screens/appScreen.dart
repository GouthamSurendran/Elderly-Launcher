import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:senior_launcher/screens/addApps.dart';
import 'package:senior_launcher/databaseHelper.dart';
import 'package:senior_launcher/models/app.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with AutomaticKeepAliveClientMixin <AppScreen> {

  DatabaseHelper _databaseHelper = DatabaseHelper();
  Widget appWidget;

  Future getFilteredApps() async {
    List<App> appNames = await _databaseHelper.getApps();
    List<Application> apps = [];
    for (int i = 0; i < appNames.length; i++) {
      apps.add(await DeviceApps.getApp(appNames[i].packageName,true));
    }
    return apps;
  }

    @override
    void initState() {
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xffC0EDF7),
        body: FutureBuilder(
          future: getFilteredApps(),
          builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              List<Application> allApps = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.count(crossAxisCount: 2,physics: BouncingScrollPhysics(),
                  children:List.generate(allApps.length, (index) {
                    return GestureDetector(
                      onTap: (){
                        DeviceApps.openApp(allApps[index].packageName);
                      },
                      child: Column(
                        children: <Widget>[
                          Image.memory((allApps[index] as ApplicationWithIcon).icon,width: 80,),
                          SizedBox(height: 10),
                          Text("${allApps[index].appName}",style: TextStyle(
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddApps())).then((value) {getFilteredApps(); setState(() {});} );
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