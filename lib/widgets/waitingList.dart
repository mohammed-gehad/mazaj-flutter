import 'package:flutter/material.dart';
import 'package:mazajflutter/blocs/ordersBeingCarried.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/main.dart';
import 'package:mazajflutter/widgets/listTileWaitingList.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WaitingList extends StatefulWidget {
  @override
  _WaitingListState createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    waitingListBloc.refetchWaitingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> waitingList = context.watch<WaitingListBloc>().waitingList;
    bool snackBarShowed = context.watch<WaitingListBloc>().snackBarShowed;

    Future.delayed(Duration.zero, () {
      if (waitingList.isEmpty && !snackBarShowed)
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('لا يوجد طلبات جديده حالياً'),
          duration: Duration(seconds: 10),
        ));
      context.read<WaitingListBloc>().updateSnackBar(true);
    });

    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: () async {
        await context.read<WaitingListBloc>().refetchWaitingList();
        _refreshController.refreshCompleted();
      },
      // onLoading: _onLoading,
      child: ListView.builder(
          itemCount: waitingList.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTileWaitingList(int.parse(waitingList[index])));
          }),
    );
  }
}
