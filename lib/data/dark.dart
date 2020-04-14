import 'package:flutter/foundation.dart';

class DarkTheme with ChangeNotifier{
  bool _isDark = false;
  int _page=0;

  DarkTheme(this._isDark, this._page);

  getTheme()=> _isDark;
  getPage()=> _page;

  changeTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }

  changePage(int n){
    _page = n;
    notifyListeners();
  }
}