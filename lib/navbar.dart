import 'package:flutter/material.dart';
import 'package:news_provider/data/dark.dart';
import 'package:provider/provider.dart';

Widget myAppBar(BuildContext context) {
  final theme = Provider.of<DarkTheme>(context);
  return AppBar(
    title: Text(
      "Reactynews",
    ),
    elevation: 0,
    actions: <Widget>[
      IconButton(
          icon: Icon(
            Icons.wb_sunny,
          ),
          onPressed: () => theme.changeTheme())
    ],
  );
}

Widget myBottomNavBar(BuildContext context){
  final theme = Provider.of<DarkTheme>(context);
  return BottomNavigationBar(
    selectedItemColor: theme.getTheme() ? Colors.white : Colors.black,
    currentIndex: theme.getPage(),
    items: [
         BottomNavigationBarItem(
           icon: new Icon(
              Icons.home,
            ),
           title: new Text('Home'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.bookmark),
           title: new Text('Saved'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person),
           title: Text('Profile')
         )
       ],
      onTap: (value) => theme.changePage(value),
  );
}