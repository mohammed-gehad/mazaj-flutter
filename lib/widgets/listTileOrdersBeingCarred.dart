import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/blocs/ordersBeingCarried.dart';
import 'package:mazajflutter/dataModels/orderModel.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:provider/provider.dart';

class ListTileOrderBeingCarred extends StatefulWidget {
  int orderId;
  ListTileOrderBeingCarred(this.orderId);

  @override
  _ListTileOrderBeingCarredState createState() =>
      _ListTileOrderBeingCarredState();
}

class _ListTileOrderBeingCarredState extends State<ListTileOrderBeingCarred> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RaisedButton(
            onPressed: () async {
              final accepted = await Navigator.pushNamed(
                  context, router.OrderDetailsRoute,
                  arguments: new Order(id: widget.orderId, accepted: true));
              print(accepted);
              if (accepted)
                context.read<OrdersCarriedBloc>().refetchOrdersCarried();
            },
            child: Text("عرض"),
            color: Colors.blue,
            textColor: Colors.white,
          ),
          Text('${widget.orderId}طلب رقم'),
        ],
      ),
    );
  }
}
