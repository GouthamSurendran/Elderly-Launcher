import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin<ContactsPage> {
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
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
      filteredContacts = _contacts
          .where((i) => i.avatar != null && i.avatar.length > 0)
          .toList();
    });
  }

  _callNumber(dynamic number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Contacts",
          style: GoogleFonts.aBeeZee(color: Colors.black87, fontSize: 20),
        )),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filteredContacts.length< 1? Container(
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        ):Column(
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
                    onTap: () async {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              content: Container(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image.memory(
                                        contact.avatar,
                                        fit: BoxFit.fill,
                                        width: 100,
                                      ),
                                      elevation: 2,
                                      shadowColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Text(
                                      "Call ${contact.displayName.toUpperCase()} ?",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _callNumber(contact.phones.isEmpty
                                                ? " "
                                                : contact.phones
                                                    .elementAt(0)
                                                    .value);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          26)),
                                              primary: Colors.green),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          26)),
                                              primary: Colors.deepOrangeAccent),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Column(
                      children: <Widget>[
                        (contact.avatar != null && contact.avatar.length > 0)
                            ? Container(
                                height: 108,
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.memory(
                                    contact.avatar,
                                    fit: BoxFit.fill,
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26)),
                                ),
                              )
                            : Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Text(contact.initials()),
                                elevation: 5,
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
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

  @override
  bool get wantKeepAlive => true;
}
