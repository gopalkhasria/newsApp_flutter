import 'package:flutter/material.dart';
import 'package:news_provider/data/User.dart';
import 'package:news_provider/navbar.dart';
import 'package:news_provider/pages/Login.dart';
import 'package:provider/provider.dart';

class UserData extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: myAppBar(context),
      bottomNavigationBar: myBottomNavBar(context),
      body: user.token == null ? Login() : Info(),
    );
  }
}

class Info extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Text('${user.name}'),
          Text('${user.email}'),
          Text('${user.country}'),
        ],
      ),
    );
  }

}