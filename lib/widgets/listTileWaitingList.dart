import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/dataModels/orderModel.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:provider/provider.dart';

class ListTileWaitingList extends StatefulWidget {
  int orderId;
  ListTileWaitingList(this.orderId);

  @override
  _ListTileWaitingListState createState() => _ListTileWaitingListState();
}

class _ListTileWaitingListState extends State<ListTileWaitingList> {
  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
          onCompleted: (dynamic resultData) {
            if (resultData["acceptDeliveringOrder"]) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text("تم قبول الطلب بنجاح"),
                    );
                  },
                  barrierDismissible: true);
            }
            context.read<WaitingListBloc>().refetchWaitingList();
          },
          documentNode: ACCEPT_DELIVERING),
      builder: (
        RunMutation acceptOrder,
        QueryResult result,
      ) {
        return ListTile(
          onTap: () => print(widget.orderId),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              result.loading
                  ? RaisedButton(
                      onPressed: null,
                      child: Text("جاري التحميل"),
                    )
                  : RaisedButton(
                      onPressed: () {
                        acceptOrder({"id": widget.orderId});
                      },
                      child: Text("قبول"),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, router.OrderDetailsRoute,
                      arguments:
                          new Order(id: widget.orderId, accepted: false));
                },
                child: Text("عرض"),
                color: Colors.blue,
                textColor: Colors.white,
              ),
              Text('${widget.orderId}طلب رقم'),
            ],
          ),
        );
      },
    );
  }
}

dynamic ACCEPT_DELIVERING = gql(r'''
      mutation AcceptDeliveringOrder($id: Int!) {
      acceptDeliveringOrder(id:$id)
    }
  ''');
