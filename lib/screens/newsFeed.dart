import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:senior_launcher/widgets.dart';

const url =
    "https://newsapi.org/v2/top-headlines?country=in&apiKey=05d88a72b6f548c2aa621ab93961ed9b";
const defaultImage = "https://www.ledr.com/colours/black.jpg";

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  bool connectionExists;

  List<Widget> newsItems = [];

  Future getNews() async {
    newsItems.clear();
    await http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        int count = data["articles"].length;
        for (int i = count - 1; i >= 0; i--) {
          String auth = "";
          String ur = "";
          if (data["articles"][i]["author"] == null)
            auth = "Unknown author";
          else
            auth = data["articles"][i]["author"];
          if (data["articles"][i]["urlToImage"] == null)
            ur = defaultImage;
          else
            ur = data["articles"][i]["urlToImage"];
          newsItems.add(NewsItem(auth, data["articles"][i]["title"], ur,
              data["articles"][i]["url"], data["articles"][i]["content"]));
        }
        return newsItems;
      }
    });
  }

  Future<void> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        connectionExists = false;
      }
      else {
        connectionExists = true;
        setState(() {});
      }
    } on SocketException catch (e) {
      print(e);
      connectionExists = false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SafeArea(
        child: RefreshIndicator(
          child: connectionExists == true? FutureBuilder(
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.none) {
                return Container();
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: newsItems.length,
                  itemBuilder: (context, index) {
                    return newsItems[index];
                  });
            },
            future: getNews(),
          ):SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text("Network Error !",style: TextStyle(fontSize: 18),),
                    Center(child: NewsItem("Unavailable", "No Internet Access", "", "___", "Please connect to the Internet")),
                  ],
                )),
          ),
          onRefresh: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  connectionExists = true;
                  setState(() {});
              }
            } on SocketException catch (e) {
              print(e);
            }
          },
        ),
      ),
    );
  }
}
