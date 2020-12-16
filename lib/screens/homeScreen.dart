import 'package:flutter/material.dart';
import 'package:mazajflutter/main.dart';
import 'package:mazajflutter/widgets/account.dart';
import 'package:mazajflutter/widgets/ordersBeingCarred.dart';
import 'package:mazajflutter/blocs/auth.dart';
import 'package:mazajflutter/widgets/waitingList.dart';
import 'package:mazajflutter/background_main.dart';
import 'package:mazajflutter/screens/loginScreen.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mazajflutter/services/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> tabs = [WaitingList(), OrdersBeingCarredWidget(), Account()];

  @override
  void initState() {
    var channel = const MethodChannel('com.mazajasly/background_service');
    var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
    channel.invokeMethod('startService', callbackHandle.toRawHandle());
    locationService.getLocation();
    waitingListBloc.getWaitingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String token = context.watch<AuthBloc>().token;
    context.watch<AuthBloc>().reviveToken();

    if (token == "" || token == null) return LoginScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "مزاج اصلي",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(label: "معلق", icon: Icon(Icons.timer)),
          BottomNavigationBarItem(
            label: "مقبول",
            icon: Icon(Icons.delivery_dining),
          ),
          BottomNavigationBarItem(
            label: "حسابي",
            icon: Icon(Icons.supervised_user_circle),
          )
        ],
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }
}
