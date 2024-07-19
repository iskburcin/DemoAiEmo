import 'package:demoaiemo/theme/dark_mode.dart';
import 'package:demoaiemo/theme/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;
  set themeData(ThemeData theme){
    _themeData = theme;
    notifyListeners();
  }

  void toggleTheme(){
    if (_themeData == lightMode){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }  }
}