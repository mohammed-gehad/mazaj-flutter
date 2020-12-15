import 'package:flutter/material.dart';
import 'package:mazajflutter/screens/loginScreen.dart';
import 'package:mazajflutter/screens/homeScreen.dart';
import 'package:mazajflutter/screens/showOrderDetails.dart';
import 'package:mazajflutter/widgets/map.dart';

const String HomeViewRoute = '/';
const String LoginViewRoute = '/login';
const String OrderDetailsRoute = '/order';
const String CustomerMapRoute = '/customer_map';
const String MapWebViewRoute = '/map_webview';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case OrderDetailsRoute:
      return MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(settings.arguments));
    case CustomerMapRoute:
      return MaterialPageRoute(
          builder: (context) => CustomerLocationMap(settings.arguments));

    default:
      return MaterialPageRoute(builder: (context) => Text("unknown"));
  }
}
