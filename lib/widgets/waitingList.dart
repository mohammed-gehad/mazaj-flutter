import 'package:flutter/material.dart';
import 'package:mazajflutter/blocs/ordersBeingCarried.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/main.dart';
import 'package:mazajflutter/widgets/listTileWaitingList.dart';
import 'package:provider/provider.dart';

class WaitingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<dynamic> waitingList = context.watch<WaitingListBloc>().waitingList;

    Future.delayed(
        Duration.zero,
        () => {
              if (waitingList.isEmpty)
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('لا يوجد طلبات جديده حالياً'),
                  duration: Duration(seconds: 3),
                ))
            });

    return ListView.builder(
        itemCount: waitingList.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTileWaitingList(int.parse(waitingList[index])));
        });
  }
}
