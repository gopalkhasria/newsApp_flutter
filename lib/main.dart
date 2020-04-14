import 'package:flutter/material.dart';
import 'package:news_provider/data/Article.dart';
import 'package:news_provider/data/User.dart';
import 'package:news_provider/data/dark.dart';
import 'package:news_provider/pages/ArticlePage.dart';
import 'package:news_provider/pages/Saved.dart';
import 'package:news_provider/pages/UserData.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> DarkTheme(false, 0)),
        ChangeNotifierProvider(create: (_)=> Articles()),
        ChangeNotifierProvider(create: (_)=> User())
      ],
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DarkTheme theme = Provider.of<DarkTheme>(context);
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter news app',
      theme: new ThemeData(
          fontFamily: 'Lato',
          brightness: theme.getTheme() ? Brightness.dark : Brightness.light,
          primaryColor: theme.getTheme() ? Colors.black : Colors.white),
      home: switchPage(context)
    );
  }
}

Widget switchPage(BuildContext context) {
  final theme = Provider.of<DarkTheme>(context);
  switch (theme.getPage()) {
    case 0:
      return ArticlePage();
    case 1:
      return Saved();
    case 2:
      return UserData();
  }

  return ArticlePage();
}