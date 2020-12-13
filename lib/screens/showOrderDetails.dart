import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/dataModels/orderModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mazajflutter/router.dart' as router;

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  OrderDetailsScreen(this.order);

  @override
  Widget build(BuildContext context) {
    print(order.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('طلب رقم ${order.id}'),
      ),
      body: Query(
        options: QueryOptions(
          documentNode: ORDER,
          variables: {"id": order.id},
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.loading) {
            return Text('Loading');
          }
          return Column(
            children: [
              Row(
                children: [
                  Text('${result.data["order"]["customer"]["name"]}'),
                  Text('اسم العميل'),
                ],
              ),
              Row(
                children: [
                  Text('${result.data["order"]["customer"]["mobileNumber"]}'),
                  Text('رقم العميل'),
                ],
              ),
              Row(
                children: [
                  Text('${result.data["order"]["customer"]["addressOSM"]}'),
                  Text('العنوان'),
                ],
              ),
              Row(
                children: [
                  Text('${result.data["order"]["customer"]["address"]}'),
                  Text('ملاحظة على العنوان'),
                ],
              ),
              Row(
                children: [
                  Text('${result.data["order"]["orderStatus"]}'),
                  Text('حالة الطلب'),
                ],
              ),
              Row(
                children: [
                  Text('${result.data["order"]["instructions"]}'),
                  Text('ملاحظة على الطلب'),
                ],
              ),
              Row(
                children: [
                  Text(
                      '${result.data["order"]["invoice"]["totalProductPrice"]}'),
                  Text('قيمة الطلبية'),
                ],
              ),
              Row(
                children: [
                  Text('${result.data["order"]["invoice"]["deliveryPrice"]}'),
                  Text('سعر التوصيل'),
                ],
              ),
              Row(
                children: [
                  Text(
                      '${result.data["order"]["invoice"]["deliveryPrice"] + result.data["order"]["invoice"]["totalProductPrice"]}'),
                  Text('السعر الاجمالي'),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  final url =
                      'https://www.google.com/maps/search/${result.data["order"]["customer"]["location"]["lat"]},${result.data["order"]["customer"]["location"]["lng"]}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.directions), Text("الخريطه")],
                ),
              ),
              order.accepted
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            final locationChanged = await Navigator.pushNamed(
                                context, router.CustomerMapRoute,
                                arguments: {
                                  "lat": result.data["order"]["customer"]
                                      ["location"]["lat"],
                                  "lng": result.data["order"]["customer"]
                                      ["location"]["lng"],
                                  "id": result.data["order"]["orderId"]
                                });

                            if (locationChanged) refetch();
                          },
                          child: Text("تعديل موقع الطلب"),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            refetch();
                          },
                          child: Icon(Icons.refresh),
                        ),
                        Mutation(
                          options: MutationOptions(
                              documentNode:
                                  ORDER_WAS_DELIVERD, // this is the mutation string you just created
                              // or do something with the result.data on completion
                              onCompleted: (dynamic resultData) {
                                Navigator.pop(context, true);
                              },
                              onError: (e) {
                                print(e);
                              }),
                          builder: (
                            RunMutation runMutation,
                            QueryResult result,
                          ) {
                            return RaisedButton(
                              child: Text("تم توصيل الطلب"),
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: () => runMutation({
                                'id': order.id,
                              }),
                            );
                          },
                        ),
                      ],
                    )
                  : Text("")
            ],
          );
        },
      ),
    );
  }
}

dynamic ORDER = gql(r'''
  query Order($id: Int!) {
  order(id: $id) {
    __typename
    id
    orderId
    customer {
      name
      mobileNumber
      address
      addressOSM
      location {
        lng
        lat
      }
    }
    orderStatus
    createdAt
    instructions
    invoice {
      __typename
      products {
        name
        count
        PricePerProduct
      }
      totalProductPrice
      deliveryPrice
      payment {
        paymentWay
        transactionNo
      }
      packaging
    }
  }
}
  ''');

dynamic ORDER_WAS_DELIVERD = gql(r'''
      mutation OrderWasDelivered($id: Int!){
      orderWasDelivered(id: $id)
    }
  ''');
