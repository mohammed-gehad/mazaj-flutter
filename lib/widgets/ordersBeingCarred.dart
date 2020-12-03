import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/widgets/listTileOrdersBeingCarred.dart';

class OrdersBeingCarredWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: ORDERS_BEING_CARRIED,
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.loading) return Text("جاري التحميل");
        return ListView.builder(
            itemCount: result.data["ordersBeingCarred"].length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTileOrderBeingCarred(
                      result.data["ordersBeingCarred"][index]));
            });
      },
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
