import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {

  ContactsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];

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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Contacts List',
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (context, index){
                  Contact contact = contacts[index];
                  return ListTile(
                    title: Text(contact.displayName.isEmpty?" ":contact.displayName),
                    subtitle: Text(
                        contact.phones.isEmpty?" ":contact.phones.elementAt(0).value
                    ),
                    leading: (contact.avatar != null && contact.avatar.length>0)?
                    CircleAvatar(
                      backgroundImage: MemoryImage(contact.avatar),
                    ):
                    CircleAvatar(child: Text(contact.initials()),)
                    ,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}