import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SavedModel{
  String image;
  String title;
  String url;
  String description;
  int id;

  SavedModel({this.image,this.title,this.url,this.description,this.id});

  factory SavedModel.fromJson(Map<String, dynamic> json){
    return SavedModel(
      image: json['image'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      id: json['id'] as int,
    );
  }
}

class Saved with ChangeNotifier{
  List<SavedModel> savedArticle;
  bool isLoaded = false;
  Saved();

  loadSavedArticle(String id, String token) async{
    var url="https://afternoon-retreat-83502.herokuapp.com/articles/saved/"+id;
    var response = await http.get(url,
    headers: {"Authorization": token},
    );
    var list = jsonDecode(response.body) as List;
    savedArticle =  list.map((i)=>SavedModel.fromJson(i)).toList();
    isLoaded = true;
    notifyListeners();
  }
}