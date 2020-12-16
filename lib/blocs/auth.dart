import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc with ChangeNotifier {
  String token = "";

  Future setToken(String t) async {
    token = t;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);

    notifyListeners();
  }

  Future reviveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String t = prefs.getString("token");
    if (t != null && token.isEmpty) {
      token = t;
      notifyListeners();
    }
  }
}
