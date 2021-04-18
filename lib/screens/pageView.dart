import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senior_launcher/screens/appScreen.dart';
import 'package:senior_launcher/screens/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:senior_launcher/screens/medsRem.dart';
import 'package:senior_launcher/screens/newsFeed.dart';
import 'package:senior_launcher/widgets.dart';

class Pview extends StatefulWidget {
  @override
  _PviewState createState() => _PviewState();
}

class _PviewState extends State<Pview> {
  PageController _controller;
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1);
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
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
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xffC0EDF7),
        child: PageView(
          controller: _controller,
          children: <Widget>[
            NewsFeed(),
            TimeWidget(),
            AppScreen(),
            ContactsPage(
              title: "Contacts",
              contact: contacts,
            ),
            MedsRem()
          ],
        ),
      ),
    );
  }
}
