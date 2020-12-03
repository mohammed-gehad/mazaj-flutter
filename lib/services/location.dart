import 'package:location/location.dart' as loc;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/main.dart';

class LocationService {
  loc.Location location = new loc.Location();

  bool _serviceEnabled;
  loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData;

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
      location.onLocationChanged
          .listen((loc.LocationData currentLocation) async {
        print(currentLocation.toString());
        await client.mutate(
          MutationOptions(
              documentNode: UPDATE_LOCATION,
              variables: {"lng": 1.323, "lat": 1.231},
              onError: (e) {
                print("error updating location");
                print(e.toString());
              }),
        );
      });
    } catch (e) {
      print("location err");
    }
  }
}

dynamic UPDATE_LOCATION = gql(r'''
  mutation UpdateDriverLocation($lng: Float!, $lat: Float!){
  updateDriverLocation(lng: $lng, lat: $lat)
}
  ''');
