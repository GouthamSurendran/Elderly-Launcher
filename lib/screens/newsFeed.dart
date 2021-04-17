import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:senior_launcher/widgets.dart';

const url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=05d88a72b6f548c2aa621ab93961ed9b";
const defaultImage = "https://www.ledr.com/colours/black.jpg";

class NewsFeed extends StatefulWidget  {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with AutomaticKeepAliveClientMixin <NewsFeed> {
  @override
  bool get wantKeepAlive => true;
  List<Widget> newsItems = [];

  Future getNews() async {
    newsItems.clear();
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      int numNews = data["totalResults"];

      for (int i=0;i < numNews; i++){
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
        newsItems.add(NewsItem(auth, data["articles"][i]["title"], ur,data["articles"][i]["description"],data["articles"][i]["url"]));
        // print(data["articles"][i]["description"]);
      }
      return data;
    }
    else print("FAIL");
  }

  void helper() async {
    await getNews();
  }

  @override
  void initState() {
    super.initState();
    helper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: newsItems,
          ),
          onRefresh: () {
            return getNews();
          },
        ),
      ),
    );
  }
}




