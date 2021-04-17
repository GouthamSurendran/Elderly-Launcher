import 'package:flutter/material.dart';

class MoreInfo extends StatelessWidget {
  MoreInfo(this.author, this.heading, this.imgUrl,this.desc,this.fullUrl);
  final imgUrl;
  final heading;
  final author;
  final desc;
  final fullUrl;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("More Info"),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Image.network(imgUrl),
                height: 200,
                width: MediaQuery.of(context).size.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("by: $author"
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(desc==null?"No desc":desc),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text("Full article at $fullUrl"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}