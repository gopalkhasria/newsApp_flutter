import 'package:flutter/material.dart';
import 'package:news_provider/data/Article.dart';
import 'package:news_provider/data/Save.dart';
import 'package:news_provider/data/User.dart';
import 'package:news_provider/data/dark.dart';
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
      body: user.token == "" || user.token == null ? Login() : Info(),
    );
  }
}

class Info extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DarkTheme utilities = Provider.of<DarkTheme>(context);
    Saved saveInstance = Provider.of<Saved>(context);
    Articles articleInstance = Provider.of<Articles>(context);
    return Container(
      margin: EdgeInsets.only(left: 30, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Your Name", style: TextStyle(fontSize: 25)),
              SizedBox(height: 5),
              Text('${user.name}', style: TextStyle(fontSize: 25)),    
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Your email", style: TextStyle(fontSize: 25)),
              SizedBox(height: 5),
              Text('${user.email}', style: TextStyle(fontSize: 25)),    
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Your country", style: TextStyle(fontSize: 25)),
               SizedBox(height: 5),
              Text('${user.country}', style: TextStyle(fontSize: 25)),    
            ],
          ),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: ()=> user.logout(saveInstance, articleInstance),
            textColor: utilities.getTheme() ? Colors.black : Colors.white,
            color: utilities.getTheme() ? Colors.white : Colors.black,
            child: Text("Logout", style: TextStyle(fontWeight: FontWeight.w700),),
          )
        ],
      ),
    );
  }

}