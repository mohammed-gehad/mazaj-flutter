// import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:mazajflutter/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/services/location.dart';
import 'package:location/location.dart' as loc;

class WaitingListBloc with ChangeNotifier {
  List<dynamic> waitingList = [];
  int waitingListLength = 0;

  Future refetchWaitingList() async {
    loc.LocationData location = locationService.locationData;

    QueryResult response = await client.queryManager.query(QueryOptions(
        documentNode: WAITING_LIST,
        variables: {"lat": location?.latitude, "lng": location?.longitude}));
    print(response.data);

    if (response.data != null)
      waitingList = response.data["updateDriverLocationGetWaitingList"];

    print(waitingList);
    if (waitingList.length > waitingListLength) {
      waitingListLength = waitingList.length;
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('1', 'مزاج اصلي', 'يوجد طلب جديد',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false);
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'مزاج اصلي', 'يوجد طلب جديد', platformChannelSpecifics,
          payload: 'طلب جديد');
    }
    notifyListeners();
  }

  Future getWaitingList() async {
    refetchWaitingList();
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      refetchWaitingList();
    });
  }
}

dynamic WAITING_LIST = gql(r'''
query UpdateDriverLocationGetWaitingList($lng: Float, $lat:Float ){
  updateDriverLocationGetWaitingList(lng:$lng,lat:$lat)
}
  ''');
