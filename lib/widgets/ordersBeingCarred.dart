import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/blocs/ordersBeingCarried.dart';
import 'package:mazajflutter/widgets/listTileOrdersBeingCarred.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class OrdersBeingCarredWidget extends StatefulWidget {
  @override
  _OrdersBeingCarredWidgetState createState() =>
      _OrdersBeingCarredWidgetState();
}

class _OrdersBeingCarredWidgetState extends State<OrdersBeingCarredWidget> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    ordersBeingCarried.refetchOrdersCarried();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool snackbarShowed = context.watch<OrdersCarriedBloc>().snackbarShowed;

    List<dynamic> ordersBeingCarried =
        context.watch<OrdersCarriedBloc>().ordersBeingCarred;
    Future.delayed(Duration.zero, () {
      if (ordersBeingCarried.isEmpty && !snackbarShowed) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('لا يوجد لديك طلبات حالياً'),
          duration: Duration(seconds: 3),
        ));
        context.read<OrdersCarriedBloc>().updateSnackBar(true);
      }
    });

    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: () async {
        await context.read<OrdersCarriedBloc>().refetchOrdersCarried();
        _refreshController.refreshCompleted();
      },
      // onLoading: _onLoading,
      child: ListView.builder(
          itemCount: ordersBeingCarried.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTileOrderBeingCarred(
                    ordersBeingCarried[index]["orderId"]));
          }),
    );
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
