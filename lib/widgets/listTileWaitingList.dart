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
          onError: (OperationException e) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text("there was an error, please try again."),
                  );
                },
                barrierDismissible: true);
          },
          documentNode: ACCEPT_DELIVERING),
      builder: (
        RunMutation acceptOrder,
        QueryResult result,
      ) {
        return ListTile(
          onTap: () => print(widget.orderId),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.orderId}طلب رقم'),
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  child: Query(
                      options: QueryOptions(
                          documentNode: ORDER,
                          variables: {"id": widget.orderId}),
                      builder: (QueryResult address,
                          {VoidCallback refetch, FetchMore fetchMore}) {
                        if (address.hasException ||
                            address.data == null ||
                            address.loading) return Text("");

                        return Text(
                            "${address.data["order"]["customer"]["addressOSM"]}");
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  result.loading
                      ? RaisedButton(
                          onPressed: null,
                          child: Text("جاري التحميل"),
                        )
                      : RaisedButton.icon(
                          onPressed: () {
                            acceptOrder({"id": widget.orderId});
                          },
                          label: Text("قبول"),
                          icon: Icon(Icons.check),
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, router.OrderDetailsRoute,
                          arguments:
                              new Order(id: widget.orderId, accepted: false));
                    },
                    icon: Icon(Icons.info),
                    label: Text("معلومات الطلب"),
                    color: Colors.grey,
                    textColor: Colors.white,
                  ),
                ],
              )
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

dynamic ORDER = gql(r'''
 query Order($id:Int!){
  order(id:$id){
    customer{
      addressOSM
      location{
        lng
        lat
      }
    }
  }
}
  ''');
