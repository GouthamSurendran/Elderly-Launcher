import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_launcher/screens/apps.dart';

void main() {
  runApp(MyApp());
}
const PrimaryColor = const Color(0xffC0EDF7);
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elderly',
      theme: ThemeData(
        primaryColor: PrimaryColor,
        textTheme: GoogleFonts.josefinSansTextTheme(
          Theme.of(context).textTheme,
        ),
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: ContactsPage(title: 'Elderly'),
      home: Apps(),
    );
  }
}


