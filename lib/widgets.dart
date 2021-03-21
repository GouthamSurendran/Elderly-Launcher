import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {

  final String title;
  final bool isDone;

  CardWidget({this.title,this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10,bottom: 15),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color:isDone?Colors.white38:Colors.white, borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Text(title,style: TextStyle(
            fontSize: 26,
            color: Colors.black54,
            fontWeight: FontWeight.w700
          ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(isDone?"Done":"Not Taken")
        ],
      ),
    );
  }
}
