import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senior_launcher/screens/appScreen.dart';
import 'package:senior_launcher/screens/contacts.dart';
import 'package:senior_launcher/screens/homeScreen.dart';
import 'package:senior_launcher/screens/medsRem.dart';
import 'package:senior_launcher/screens/newsFeed.dart';
import 'package:senior_launcher/notifications.dart';

class Pview extends StatefulWidget {
  @override
  _PviewState createState() => _PviewState();
}

class _PviewState extends State<Pview> {
  PageController _controller;
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1);
    notificationService.initialize();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xffC0EDF7),
        child: PageView(
          controller: _controller,
          children: <Widget>[
            // Center(
            //             //   child: Container(
            //             //     child: Column(
            //             //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             //       children: [
            //             //         ElevatedButton(
            //             //           onPressed: (){
            //             //               notificationService.scheduledNotification();
            //             //           },
            //             //           child: Text("Click cheyy"),
            //             //         ),
            //             //         ElevatedButton(onPressed: (){
            //             //           notificationService.cancelNotification();
            //             //         }, child: Text("Stop notifications"))
            //             //       ],
            //             //     ),
            //             //   ),
            //             // ),
            NewsFeed(),
            HomeScreen(),
            AppScreen(),
            ContactsPage(),
            MedsRem()
          ],
        ),
      ),
    );
  }
}
