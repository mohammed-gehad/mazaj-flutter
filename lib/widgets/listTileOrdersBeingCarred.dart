import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/screens/showOrderDetails.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:provider/provider.dart';

class ListTileOrderBeingCarred extends StatefulWidget {
  dynamic order;
  ListTileOrderBeingCarred(this.order);

  @override
  _ListTileOrderBeingCarredState createState() =>
      _ListTileOrderBeingCarredState();
}

class _ListTileOrderBeingCarredState extends State<ListTileOrderBeingCarred> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // onTap: () => print(widget.orderId),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, router.OrderDetailsRoute,
                  arguments: widget.order["orderId"]);
            },
            child: Text("عرض"),
            color: Colors.blue,
            textColor: Colors.white,
          ),
          Text('${widget.order["orderId"]}طلب رقم'),
        ],
      ),
    );
  }
}
