import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elderly',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Elderly'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts = [];
  final ScrollController _scrollController = ScrollController();

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
    List<Contact> _contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();
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
                      title: Text(contact.displayName),
                      subtitle: Text(
                        contact.phones.elementAt(0).value
                      ),
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
