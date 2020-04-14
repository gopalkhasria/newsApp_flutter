import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ArticleModel{
  String image;
  String title;
  String url;
  String description;
  ArticleModel({this.image,this.title,this.description,this.url});
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      image: json['image'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
    );
  }
}

class Articles with ChangeNotifier{
  List<ArticleModel> articles;
  bool error = false;

  Articles(){
    loadArticles("us");
  }

  void loadArticles(String country) async{
    articles = [];
    notifyListeners();
    var response = await http.get("http://192.168.56.1:8080/articles?country="+country);
    var list = jsonDecode(response.body) as List;
    articles =  list.map((i)=>ArticleModel.fromJson(i)).toList();
    notifyListeners();
  }
}