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
  String id;
  bool error=false;
  bool disabled = false;
  DarkTheme page = new DarkTheme(false, 1);
  User();

  void setEmail(String value){
    email = value;
  }
  void setPassword(String value){
    password = value;
  }

  void login(Articles articleInstance) async {
    var headers = {
        'Content-Type': 'application/json',
      };
      var response = await http.post("http://192.168.56.1:3000/user/login",
      headers: headers,
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
    id = helper[3];
    articleInstance.loadArticles(country);
    notifyListeners();
  }

  saveArticle(ArticleModel article, DarkTheme utilities) async {
    var data =json.encode({
      "id": id,
      "title": article.title,
      "description": article.description,
      "url": article.url,
      "image": article.image,
    });
    var headers = {
        'Content-Type': 'application/json',
        'Authorization': token
      };
      var response = await http.post("http://192.168.56.1:3000/articles/save",
        headers: headers,
        body: data);
      print(response.statusCode);
  }
}