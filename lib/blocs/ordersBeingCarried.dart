// import 'package:flutter/cupertino.dart';
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

    if (ordersBeingCarred.isNotEmpty) {
      if (!await locationService.locationManager.isRunning)
        await locationService.locationManager.start();
    } else {
      await locationService.locationManager.stop();
    }
  }

  Future getOrdersCarried() async {
    refetchOrdersCarried();
    Timer.periodic(Duration(seconds: 30000), (Timer t) async {
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
