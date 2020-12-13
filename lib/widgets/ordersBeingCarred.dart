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
  void didChangeDependencies() {
    //location stream starts if there are orders being carried ONLY
    // if (locationService.locationSubscription != null)
    //   locationService.locationSubscription.cancel();
    // if (ordersBeingCarried.ordersBeingCarred.isNotEmpty)
    //   locationService.getLocation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> ordersBeingCarried =
        context.watch<OrdersCarriedBloc>().ordersBeingCarred;
    print(ordersBeingCarried);
    Future.delayed(Duration.zero, () {
      // context.read<OrdersCarriedBloc>().refetchOrdersCarried();
      if (ordersBeingCarried.isEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('لا يوجد لديك طلبات حالياً'),
          duration: Duration(seconds: 3),
        ));
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
