import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:news_provider/data/Article.dart';
import 'package:news_provider/data/Save.dart';
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
  bool exist = false;
  String selectValue;
  List<String> selectCountry = [
    "us:United States","ca:Canda","it:italia","fr:france","gb:United Kingdom","ru:Russia"];
  //DarkTheme page = new DarkTheme(false, 1);
  User();

  void setName(String value){
    name = value;
  }

  void setEmail(String value){
    error = false;
    notifyListeners();
    email = value;
  }
  void setPassword(String value){
    password = value;
  }

  void setCountry(String value){
    selectValue = value;
    notifyListeners();
  }
  void setExist(){
    exist = false;
    error=false;
    notifyListeners();
  }

  void logout(Saved saved, Articles articles){
    email="";
    password="";
    name="";
    token="";
    country="";
    id="";
    notifyListeners();
    saved.savedArticle = [];
    saved.isLoaded = false;
    notifyListeners();
    articles.loadArticles("no");
  }

  void login(Articles articleInstance, Saved savedIstance) async {
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
    savedIstance.loadSavedArticle(id, token);
    notifyListeners();
  }

  saveArticle(ArticleModel article, DarkTheme utilities, Saved instance) async {
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
      if(response.statusCode == 200){
      instance.loadSavedArticle(id, token);
    }
  }

  removeSavedArticle(SavedModel savedModel, Saved instance)async {
    var data =json.encode({
      "id": savedModel.id,
      "user_id": id
    });
    var headers = {
        'Content-Type': 'application/json',
        'Authorization': token
    };
    var response = await http.post("http://192.168.56.1:3000/articles/delete",
      headers: headers,
      body: data);
    if(response.statusCode == 200){
      instance.loadSavedArticle(id, token);
    }
  }

  void signup(Articles articleInstance) async{
    if( !email.contains('@') || password.length < 3 || name.length == null || selectValue == null){
      error = true;
      notifyListeners();
    }else{
      var helper = selectValue.split(":");
      var data =json.encode({
        "name": name,
        "email": email,
        "password": password,
        "country": helper[0]
      });
      print(data);
      var headers = {
          'Content-Type': 'application/json',
          'Authorization': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiR29wYWwgU2luZ2giLCJpYXQiOjE1ODY5NTQ3ODF9.tAfNLCv3UMnkVnXU1Inrw3rwk9PSCnLZoiiiasezzhg"
      };
      var response = await http.post("http://192.168.56.1:3000/user/signup",
      headers: headers,
      body: data);
      print(response.statusCode);
      if(response.statusCode == 400){
        exist = true;
        notifyListeners();
        print("Sono in error");
        return;
      }else{
        print("Sono qua");
        var helper = response.body.split(";");
        token = helper[0];
        name = helper[1];
        country = helper[2];
        id = helper[3];
        articleInstance.loadArticles(country);
        notifyListeners();
      }
    }
  }
}