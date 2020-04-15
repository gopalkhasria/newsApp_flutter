import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:news_provider/data/Save.dart';
import 'package:news_provider/data/User.dart';
import 'package:news_provider/data/dark.dart';
import 'package:news_provider/navbar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SavedPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Saved savedArticle = Provider.of<Saved>(context);
    return Scaffold(
      appBar: myAppBar(context),
      bottomNavigationBar:  myBottomNavBar(context),
      body: savedArticle.savedArticle == null ? errorWidget() : ListArticle());
  }
}

Widget errorWidget() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage("assets/error.png"), fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            "There is no data saved",
            style: TextStyle(fontSize: 20),
          )),
        )
      ],
    ),
  );
}

class ListArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Saved articleSave = Provider.of<Saved>(context);
    return Container(
      child: ListView.builder(
          itemCount: articleSave.savedArticle.length,
          itemBuilder: (context, index) => new Card(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ArticleWebState(url: articleSave.savedArticle[index].url, 
                             article: articleSave.savedArticle[index]
                            )),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(articleSave.savedArticle[index].title,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInImage.assetNetwork(
                              placeholder: 'assets/news-placeholder.png',
                              image: articleSave.savedArticle[index].image)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          articleSave.savedArticle[index].description,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}

class ArticleWebState extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final url;
  final SavedModel article;
  ArticleWebState({Key key, this.url, this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var utilities = Provider.of<DarkTheme>(context);
    var saved = Provider.of<Saved>(context);
    return Scaffold(
      appBar: myAppBar(context),
      body: Column(
        children: [
        Expanded(
          child:  WebView(
            initialUrl: url,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
      ]),
      floatingActionButton: SpeedDial(
        backgroundColor: utilities.getTheme() ? Colors.black : Colors.white,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(
          color: utilities.getTheme() ? Colors.white : Colors.black
        ),
        visible: utilities.dial,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(Icons.share, color: utilities.getTheme() ? Colors.white : Colors.black),
            backgroundColor: utilities.getTheme() ? Colors.black : Colors.white,
          ),
          if(user.token != null)
          SpeedDialChild(
            child: Icon(Icons.delete, color: utilities.getTheme() ? Colors.white : Colors.black),
            backgroundColor: utilities.getTheme() ? Colors.black : Colors.white,
            onTap: ()=> user.removeSavedArticle(article,saved),
          ),
        ]
      )
    );
  }
}