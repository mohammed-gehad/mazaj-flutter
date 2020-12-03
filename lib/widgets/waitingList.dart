import 'package:flutter/material.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/widgets/listTileWaitingList.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WaitingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<dynamic> waitingList = context.watch<WaitingListBloc>().waitingList;

    if (waitingList.isEmpty) return Text("لا يوجد طلبات جديده");

    return ListView.builder(
        itemCount: waitingList.length,
        itemBuilder: (context, index) {
          return Card(child: ListTileWaitingList(waitingList[index]));
        });
  }
}
