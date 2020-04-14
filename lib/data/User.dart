import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:news_provider/data/Article.dart';
import 'package:news_provider/data/dark.dart';

class User with ChangeNotifier{
  String email;
  String password;
  String name;
  String token;
  String country;
  bool error=false;
  DarkTheme page = new DarkTheme(false, 1);
  User();

  void setEmail(String value){
    email = value;
  }
  void setPassword(String value){
    password = value;
  }

  void login(Articles articleInstance) async {
    var response = await http.post("http://192.168.56.1:8080/login",
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password
    }));
    if(response.statusCode != 200){
      error = true;
      notifyListeners();
      return;
    }
    var helper = response.body.split(";");
    token = helper[0];
    name = helper[1];
    country = helper[2];
    articleInstance.loadArticles(country);
    notifyListeners();
  }
}