import 'dart:async';
import 'package:location/location.dart' as loc;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/main.dart';

class LocationService {
  loc.Location location = new loc.Location();

  bool _serviceEnabled;
  loc.PermissionStatus _permissionGranted;
  loc.LocationData locationData;
  StreamSubscription<loc.LocationData> locationSubscription;

  Future getLocation() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          return;
        }
      }

      locationSubscription = location.onLocationChanged
          .listen((loc.LocationData currentLocation) async {
        locationData = currentLocation;
        // print(locationData);
      });
    } catch (e) {
      print("location err");
    }
  }
}

LocationService locationService = LocationService();

dynamic UPDATE_LOCATION = gql(r'''
  mutation UpdateDriverLocation($lng: Float!, $lat: Float!){
  updateDriverLocation(lng: $lng, lat: $lat)
}
  ''');

// await client.mutate(
//   MutationOptions(
//       documentNode: UPDATE_LOCATION,
//       variables: {
//         "lng": currentLocation.longitude,
//         "lat": currentLocation.latitude
//       },
//       onError: (e) {
//         print("error updating location");
//         print(e.toString());
//       }),
// );
