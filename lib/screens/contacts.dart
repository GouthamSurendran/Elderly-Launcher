import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key, this.title, this.contact}) : super(key: key);
  final String title;
  final List<Contact> contact;

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      contacts = widget.contact;
      filteredContacts = contacts
          .where((i) => i.avatar != null && i.avatar.length > 0)
          .toList();
    });
  }

  void callLaunch(phoneNo) async {
    if (await canLaunch(phoneNo)) {
      await launch(phoneNo);
    } else
      print("Error in calling the number $phoneNo");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title,style: GoogleFonts.josefinSans(color: Colors.black87,fontSize: 20),)),
        backgroundColor: Color(0xffC0EDF7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.count(
                physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 5,
                children: List.generate(filteredContacts.length, (index) {
                  Contact contact = filteredContacts[index];
                  return InkWell(
                    onTap: () {
                      callLaunch(
                          'tel: ${contact.phones.isEmpty ? " " : contact.phones.elementAt(0).value}');
                    },
                    child: Column(
                      children: <Widget>[
                        (contact.avatar != null && contact.avatar.length > 0)
                            ? CircleAvatar(
                                radius: 55,
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials()),
                              ),
                        Expanded(
                          child: Center(
                            child: Text(
                              contact.displayName.isEmpty
                                  ? " "
                                  : contact.displayName,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
