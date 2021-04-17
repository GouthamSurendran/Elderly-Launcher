import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfo extends StatelessWidget {
  MoreInfo(this.author, this.heading, this.imgUrl,this.fullUrl,this.content);
  final imgUrl;
  final heading;
  final author;
  final content;
  final fullUrl;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffC0EDF7),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("Source : $author",style: TextStyle(color: Colors.black87),),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Image.network(imgUrl),
                height: 200,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                padding: EdgeInsets.only(left: 10,top: 30,right: 2),
                child: Text(content==null?"No desc":content,style: TextStyle(
                  fontSize: 16
                ),),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: InkWell(child: Text("Full article at $fullUrl",style: TextStyle(fontSize: 15),),
                onTap: (){
                  launch(fullUrl);
                },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}