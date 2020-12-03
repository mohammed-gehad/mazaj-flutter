import 'package:flutter/material.dart';
import 'package:mazajflutter/widgets/loginWidget.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تسجيل الدخول"),
        centerTitle: true,
      ),
      body: Center(
        child: LoginWidget(),
      ),
    );
  }
}
