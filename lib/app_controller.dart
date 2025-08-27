import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isThemeDark = false;
  changeTheme() {
    isThemeDark = !isThemeDark;
    notifyListeners();
  }
}
