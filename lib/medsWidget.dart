import 'package:flutter/material.dart';

class MedsWidget extends StatelessWidget {
  final String medName;
  final bool hasTaken;
  final String desc;

  MedsWidget({this.medName, this.hasTaken, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
          color: Color(0xffC0EDF7), borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            medName,
            style: TextStyle(
              fontSize: 26,
              color: Color(0xff2F2F2F),
              fontWeight: FontWeight.bold,
              decoration:
              hasTaken ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            desc,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blue),
          )
        ],
      ),
    );
  }
}