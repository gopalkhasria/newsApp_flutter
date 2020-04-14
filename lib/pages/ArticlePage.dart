import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:news_provider/data/Article.dart';
import 'package:news_provider/data/User.dart';
import 'package:news_provider/data/dark.dart';
import 'package:news_provider/navbar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Articles _articlesList = Provider.of<Articles>(context);
    return Scaffold(
        appBar: myAppBar(context),
        bottomNavigationBar: myBottomNavBar(context),
        body: _articlesList.error
            ? errorWidget()
            : _articlesList.articles == null ? loadWidget() : ListArticle());
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
            "An error occured. Try to restart the app",
            style: TextStyle(fontSize: 20),
          )),
        )
      ],
    ),
  );
}

Widget loadWidget() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage("assets/loading.png"), fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            "Loading your articles",
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
    Articles articlesList = Provider.of<Articles>(context);
    return Container(
      child: ListView.builder(
          itemCount: articlesList.articles.length,
          itemBuilder: (context, index) => new Card(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ArticleWebState(url: articlesList.articles[index].url, 
                             article: articlesList.articles[index]
                            )),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(articlesList.articles[index].title,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInImage.assetNetwork(
                              placeholder: 'assets/news-placeholder.png',
                              image: articlesList.articles[index].image)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          articlesList.articles[index].description,
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
  final ArticleModel article;
  ArticleWebState({Key key, this.url, this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var utilities = Provider.of<DarkTheme>(context);
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
            child: Icon(Icons.save, color: utilities.getTheme() ? Colors.white : Colors.black),
            backgroundColor: utilities.getTheme() ? Colors.black : Colors.white,
            onTap: ()=> user.saveArticle(article,utilities),
          ),
        ]
      )
    );
  }
}
