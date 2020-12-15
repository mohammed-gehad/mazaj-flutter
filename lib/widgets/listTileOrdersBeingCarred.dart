import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/blocs/ordersBeingCarried.dart';
import 'package:mazajflutter/dataModels/orderModel.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:provider/provider.dart';
import '../main.dart';

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
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${widget.orderId}طلب رقم'),
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              child: Query(
                  options: QueryOptions(
                      documentNode: ORDER, variables: {"id": widget.orderId}),
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
              Mutation(
                options: MutationOptions(
                    documentNode: ORDER_WAS_DELIVERD,
                    onCompleted: (dynamic resultData) {
                      ordersBeingCarried.refetchOrdersCarried();
                    }),
                builder: (
                  RunMutation delivered,
                  QueryResult result,
                ) {
                  if (result.loading)
                    return RaisedButton(
                      onPressed: null,
                      child: Text("جاري التحميل"),
                    );
                  else
                    return RaisedButton.icon(
                      onPressed: () {
                        delivered({"id": widget.orderId});
                      },
                      label: Text("تم التوصيل"),
                      icon: Icon(Icons.check),
                      color: Colors.green,
                      textColor: Colors.white,
                    );
                },
              ),
              RaisedButton.icon(
                onPressed: () async {
                  final accepted = await Navigator.pushNamed(
                      context, router.OrderDetailsRoute,
                      arguments: new Order(id: widget.orderId, accepted: true));
                  if (accepted)
                    context.read<OrdersCarriedBloc>().refetchOrdersCarried();
                },
                icon: Icon(Icons.info),
                label: Text("معلومات الطلب"),
                color: Colors.grey,
                textColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

dynamic ORDER_WAS_DELIVERD = gql(r'''
      mutation OrderWasDelivered($id: Int!){
      orderWasDelivered(id: $id)
    }
  ''');
