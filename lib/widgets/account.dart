import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _name;
  String _phone;

  Future readAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("user-name");
      _phone = prefs.getString("user-number");
    });
  }

  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authBloc.setToken(null);
    prefs.setString("user-name", null);
    prefs.setString("user-number", null);
  }

  @override
  void initState() {
    readAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _name != null ? Text(' ${_name} ') : Text(''),
              Text(" مرحباً "),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _phone != null ? Text(' ${_phone} ') : Text(""),
              Text(" رقم الجوال "),
            ],
          ),
          RaisedButton(
            onPressed: logOut,
            child: Text("تسجيل الخروج"),
          )
        ],
      ),
    );
  }
}
