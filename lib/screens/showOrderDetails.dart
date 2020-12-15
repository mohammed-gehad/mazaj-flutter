import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/dataModels/orderModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mazajflutter/router.dart' as router;
import '../main.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  OrderDetailsScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طلب رقم ${order.id}',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Query(
        options: QueryOptions(
          documentNode: ORDER,
          variables: {"id": order.id},
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return Center(child: Text('جاري التحميل'));
          }

          if (result.data == null || result.hasException) {
            return Center(
                child: Text('لقد حدث خطاء, الرجاء المحاوله مره اخرى'));
          }

          List items = (result.data["order"]["invoice"]["products"] as List)
              .map(
                (e) => TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${e["PricePerProduct"] * e["count"]}",
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${e["count"]}",
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${e["PricePerProduct"]}",
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${e["name"]}",
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ]),
              )
              .toList();
          items.insert(
              0,
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "المجموع",
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "العدد",
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "السعر",
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "الاسم",
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ]));

          items.add(TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${result.data["order"]["invoice"]["deliveryPrice"]}',
                textDirection: TextDirection.rtl,
              ),
            ),
            Text(
              "",
            ),
            Text(
              "",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "التوصيل",
                textDirection: TextDirection.rtl,
              ),
            ),
          ]));
          items.add(TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${(result.data["order"]["invoice"]["deliveryPrice"] + result.data["order"]["invoice"]["totalProductPrice"])?.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.green, fontSize: 18),
                textDirection: TextDirection.rtl,
              ),
            ),
            Text(""),
            Text(""),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "الاجمالي",
                style: TextStyle(color: Colors.green, fontSize: 18),
                textDirection: TextDirection.rtl,
              ),
            ),
          ]));

          return SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                // margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${result.data["order"]["customer"]["name"]}'),
                          )),
                        ),
                        Card(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('اسم العميل'),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Card(
                            color: Colors.green,
                            child: FlatButton(
                              onPressed: () {
                                launch(
                                    "tel://${result.data["order"]["customer"]["mobileNumber"]}");
                              },
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            )),
                        Expanded(
                            child: Card(
                                child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${result.data["order"]["customer"]["mobileNumber"]}'),
                        ))),
                        Card(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('رقم الجوال'),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Card(
                                child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${result.data["order"]["customer"]["addressOSM"]}'),
                        ))),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('العنوان'),
                          ),
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Card(
                                child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${result.data["order"]["customer"]["address"]}'),
                        ))),
                        Card(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('ملاحظة'),
                            )),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.grey[200]),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: items,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton.icon(
                          onPressed: () async {
                            refetch();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          label: Text(
                            "تحديث",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
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
                          color: Colors.blue,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                color: Colors.white,
                              ),
                              Text(
                                "قوقل ماب",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    order.accepted
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton.icon(
                                    onPressed: () async {
                                      final locationChanged =
                                          await Navigator.pushNamed(
                                              context, router.CustomerMapRoute,
                                              arguments: {
                                            "lat": result.data["order"]
                                                ["customer"]["location"]["lat"],
                                            "lng": result.data["order"]
                                                ["customer"]["location"]["lng"],
                                            "id": result.data["order"]
                                                ["orderId"]
                                          });

                                      if (locationChanged) refetch();
                                    },
                                    label: Text("تعديل موقع الطلب"),
                                    icon: Icon(Icons.pin_drop),
                                    color: Colors.amber,
                                  ),
                                  Mutation(
                                    options: MutationOptions(
                                        documentNode:
                                            ORDER_WAS_DELIVERD, // this is the mutation string you just created
                                        onCompleted: (dynamic resultData) {
                                          Navigator.pop(context, true);
                                          ordersBeingCarried
                                              .refetchOrdersCarried();
                                        },
                                        onError: (e) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            title: Text(
                                                "لقد حدث خطاء, الرجاء المحاوله مره اخرى"),
                                          );
                                        }),
                                    builder: (
                                      RunMutation runMutation,
                                      QueryResult result,
                                    ) {
                                      if (result.loading)
                                        return RaisedButton(
                                          onPressed: null,
                                          child: Text("جاري التحميل"),
                                        );
                                      return RaisedButton.icon(
                                        label: Text("تم توصيل الطلب"),
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        onPressed: () => runMutation({
                                          'id': order.id,
                                        }),
                                        icon: Icon(Icons.check),
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        : Text("")
                  ],
                ),
              ),
            ),
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
