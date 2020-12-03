import 'package:flutter/material.dart';
import 'package:mazajflutter/widgets/map.dart';
import 'package:mazajflutter/widgets/ordersBeingCarred.dart';
import 'package:mazajflutter/widgets/waitingList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> tabs = [WaitingList(), OrdersBeingCarredWidget()];
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
                label: "طلبات في انتظار القبول",
                icon: Icon(Icons.add_to_queue)),
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
        ));
  }
}
