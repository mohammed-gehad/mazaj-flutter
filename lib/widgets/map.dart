import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlng/latlng.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:graphql_flutter/graphql_flutter.dart';

class CustomerLocationMap extends StatefulWidget {
  dynamic _customerLocation;
  CustomerLocationMap(this._customerLocation);
  @override
  _CustomerLocationMapState createState() => _CustomerLocationMapState();
}

class _CustomerLocationMapState extends State<CustomerLocationMap> {
  latLng.LatLng pin;
  @override
  void initState() {
    super.initState();
    setState(() {
      pin = latLng.LatLng(
          widget._customerLocation["lat"], widget._customerLocation["lng"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تغيير موقع الطلب",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            child: FlutterMap(
              options: MapOptions(
                  center: pin,
                  zoom: 13.0,
                  onPositionChanged: (a, b) {
                    print(b);
                    Future.delayed(Duration.zero, () async {
                      setState(() {
                        pin = a.center;
                      });
                    });
                  }),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      point: pin,
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.pin_drop,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
                child: Mutation(
              options: MutationOptions(
                  documentNode: CHANGE_ORDER_LOCATION,
                  onCompleted: (dynamic resultData) {
                    print(resultData);
                    if (resultData["changeOrderLocation"] != null) {
                      Navigator.pop(context, true);
                    }
                  },
                  onError: (d) {
                    print(d);
                  }),
              builder: (
                RunMutation runMutation,
                QueryResult result,
              ) {
                if (result.loading)
                  return RaisedButton(
                    onPressed: () {},
                    child: Text("جاري الحفظ"),
                    color: Colors.grey,
                    textColor: Colors.white,
                  );

                return RaisedButton.icon(
                  onPressed: () {
                    runMutation({
                      "id": widget._customerLocation["id"],
                      "lng": pin.longitude,
                      "lat": pin.latitude
                    });
                  },
                  label: Text("حفظ الموقع الجديد"),
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.check),
                );
              },
            )),
          )
        ],
      ),
    );
  }
}

double checkDouble(dynamic value) {
  if (value is String) {
    return double.parse(value);
  } else {
    return value;
  }
}

dynamic CHANGE_ORDER_LOCATION = gql(r'''
  mutation ChangeOrderLocation($id: Int!, $lng: Float!, $lat: Float!){
  changeOrderLocation(id: $id, lng: $lng ,lat: $lat){
    customer{
      location{
        lng
        lat
      }
    }
    invoice{
      deliveryPrice
    }
  }
}
  ''');
