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

class _NewsFeedState extends State<NewsFeed> with AutomaticKeepAliveClientMixin{
  bool get wantKeepAlive => true;

  List<Widget> newsItems = [];
  int numNews;

  Future getNews() async {
    newsItems.clear();
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      int numNews = data["totalResults"];

      for (int i = 0; i < numNews; i++) {
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
  }

  void helper() async {
    await getNews();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          child: FutureBuilder(
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.none &&
                  snap.hasData == null) {
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
          ),
          onRefresh: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                return getNews();
              }
            } on SocketException catch (e) {
              //print(e);
            }
          },
        ),
      ),
    );
  }
}
