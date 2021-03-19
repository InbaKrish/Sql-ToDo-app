import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData basic_r = ThemeData(
  primaryColor: Colors.red,
  primarySwatch: Colors.red,
  accentColor: Colors.red,
  brightness: Brightness.light,
);
ThemeData basic_b = ThemeData(
  primaryColor: Colors.blue,
  primarySwatch: Colors.blue,
  accentColor: Colors.blue,
  brightness: Brightness.light,
);
ThemeData dark_b = ThemeData(
  primaryColor: Colors.blue,
  primarySwatch: Colors.blue,
  accentColor: Colors.blue,
  brightness: Brightness.dark,
);
ThemeData dark_r = ThemeData(
  primaryColor: Colors.red,
  primarySwatch: Colors.red,
  accentColor: Colors.red,
  brightness: Brightness.dark,
);

class ThemeChanger extends ChangeNotifier {
  final List<String> keys = ["theme", "red", "blue"];
  SharedPreferences prefs;
  bool _dark;
  bool _red;
  bool _blue;

  bool get darkTheme => _dark;
  bool get redColor => _red;
  bool get blueColor => _blue;

  ThemeChanger() {
    _dark = false;
    _red = true;
    _blue = false;
    _getPrefs();
  }

  toggleTheme() {
    _dark = !_dark;
    _savePrefs();
    notifyListeners();
  }

  toggleRed() {
    _red = !_red;
    _savePrefs();
    notifyListeners();
  }

  toggleBlue() {
    _blue = !_blue;
    _savePrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    prefs = await SharedPreferences.getInstance();
  }

  _getPrefs() async {
    await _initPrefs();
    _dark = prefs.getBool(keys[0].toString()) ?? false;
    _red = prefs.getBool(keys[1].toString()) ?? true;
    _blue = prefs.getBool(keys[2].toString()) ?? false;
    print('GOT THE PREFS..');
    notifyListeners();
  }

  _savePrefs() async {
    await _initPrefs();
    prefs.setBool(keys[0].toString(), _dark);
    prefs.setBool(keys[1].toString(), _red);
    prefs.setBool(keys[2].toString(), _blue);
    print("prefs set");
  }
}
