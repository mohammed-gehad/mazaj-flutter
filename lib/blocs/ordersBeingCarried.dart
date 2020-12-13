// import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:mazajflutter/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OrdersCarriedBloc with ChangeNotifier {
  List<dynamic> ordersBeingCarred = [];

  Future refetchOrdersCarried() async {
    QueryResult response = await client.queryManager
        .query(QueryOptions(documentNode: ORDERS_BEING_CARRIED));

    if (response.data != null)
      ordersBeingCarred = response.data["ordersBeingCarred"];
    print(ordersBeingCarred);
    notifyListeners();
  }

  // Future getOrdersCarried() async {
  //   refetchOrdersCarried();
  //   Timer.periodic(Duration(seconds: 100), (Timer t) async {
  //     refetchOrdersCarried();
  //   });
  // }
}

dynamic ORDERS_BEING_CARRIED = gql('''
  {
  ordersBeingCarred{
    id
    orderId
  }
}
  ''');
