import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senior_launcher/screens/appScreen.dart';
import 'package:senior_launcher/screens/contacts.dart';
import 'package:senior_launcher/screens/medsRem.dart';
import 'package:senior_launcher/screens/newsFeed.dart';
import 'package:senior_launcher/widgets.dart';

class Pview extends StatefulWidget {
  @override
  _PviewState createState() => _PviewState();
}

class _PviewState extends State<Pview> {
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xffC0EDF7),
        child: PageView(
          controller: _controller,
          children: <Widget>[
            NewsFeed(),
            TimeWidget(),
            AppScreen(),
            ContactsPage(),
            MedsRem()
          ],
        ),
      ),
    );
  }
}
