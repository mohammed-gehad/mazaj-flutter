// import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mazajflutter/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WaitingListBloc with ChangeNotifier {
  List<dynamic> waitingList = [];

  Future refetchWaitingList() async {
    QueryResult response = await client.queryManager
        .query(QueryOptions(documentNode: WAITING_LIST));

    waitingList = response.data["waitingList"];
    print("waitingList");
    print(waitingList);
    notifyListeners();
  }

  Future getWaitingList() async {
    refetchWaitingList();
    Timer.periodic(Duration(seconds: 100), (Timer t) async {
      refetchWaitingList();
    });
  }
}

dynamic WAITING_LIST = gql('''
{
  waitingList
}
  ''');
