import 'dart:async';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mazajflutter/main.dart';

class LocationService {
  LocationManager locationManager = LocationManager.instance;
  Stream<LocationDto> dtoStream;
  StreamSubscription<LocationDto> dtoSubscription;
  LocationDto location;

  Future getLocation() async {
    try {
      locationManager.interval = 5;
      locationManager.distanceFilter = 0;
      locationManager.notificationTitle = 'المزاج الاصلي تتبع موقع السائق';
      locationManager.notificationMsg =
          'المزاج الاصلي يتتبع موقعك اثناء توصيل الطلبات';
      dtoStream = locationManager.dtoStream;
      dtoSubscription = dtoStream.listen((onData) {
        location = onData;
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
