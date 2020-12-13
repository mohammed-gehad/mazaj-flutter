import 'package:flutter/material.dart';
import 'package:mazajflutter/main.dart';
import 'package:mazajflutter/widgets/ordersBeingCarred.dart';
import 'package:mazajflutter/widgets/waitingList.dart';
import 'package:mazajflutter/background_main.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:mazajflutter/services/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> tabs = [WaitingList(), OrdersBeingCarredWidget()];

  @override
  void initState() {
    var channel = const MethodChannel('com.example/background_service');
    var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
    channel.invokeMethod('startService', callbackHandle.toRawHandle());
    locationService.getLocation();
    waitingListBloc.getWaitingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مزاج اصلي"),
        centerTitle: true,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.grey[200],
        items: [
          BottomNavigationBarItem(
              label: "طلبات في انتظار القبول", icon: Icon(Icons.add_to_queue)),
          BottomNavigationBarItem(
            label: "طلباتي الحاليه",
            icon: Icon(Icons.query_builder),
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
