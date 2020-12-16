import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mazajflutter/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/location.dart';

class OrdersCarriedBloc with ChangeNotifier {
  List<dynamic> ordersBeingCarred = [];
  bool snackbarShowed = false;

  void updateSnackBar(bool b) {
    snackbarShowed = b;
    notifyListeners();
  }

  Future refetchOrdersCarried() async {
    QueryResult response = await client.queryManager
        .query(QueryOptions(documentNode: ORDERS_BEING_CARRIED));

    if (response.data != null) {
      ordersBeingCarred = response.data["ordersBeingCarred"];
      notifyListeners();
    }

    if (ordersBeingCarred.isNotEmpty)
      locationService.locationManager.start();
    else
      locationService.locationManager.stop();
  }

  Future getOrdersCarried() async {
    refetchOrdersCarried();
    Timer.periodic(Duration(minutes: 1), (Timer t) async {
      refetchOrdersCarried();
    });
  }
}

dynamic ORDERS_BEING_CARRIED = gql('''
  {
  ordersBeingCarred{
    id
    orderId
  }
}
  ''');
