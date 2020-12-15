// import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mazajflutter/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/services/location.dart';
import 'package:carp_background_location/carp_background_location.dart';

class WaitingListBloc with ChangeNotifier {
  List<dynamic> waitingList = [];
  int waitingListLength = 0;
  bool snackBarShowed = false;

  void updateSnackBar(bool b) {
    snackBarShowed = b;
    notifyListeners();
  }

  Future refetchWaitingList() async {
    LocationDto location = locationService.location;
    print({"lat": location?.latitude, "lng": location?.longitude});
    QueryResult response = await client.queryManager.query(QueryOptions(
        documentNode: WAITING_LIST,
        variables: {"lat": location?.latitude, "lng": location?.longitude}));

    if (response.data != null)
      waitingList = response.data["updateDriverLocationGetWaitingList"];
    print("waiting list");
    print(waitingList);
    notifyListeners();
  }

  Future getWaitingList() async {
    refetchWaitingList();
    Timer.periodic(Duration(seconds: 30), (Timer t) async {
      refetchWaitingList();
    });
  }
}

dynamic WAITING_LIST = gql(r'''
query UpdateDriverLocationGetWaitingList($lng: Float, $lat:Float ){
  updateDriverLocationGetWaitingList(lng:$lng,lat:$lat)
}
  ''');
