import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazajflutter/app_retain_widget.dart';
import 'package:mazajflutter/background_main.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/blocs/ordersBeingCarried.dart';
import 'package:mazajflutter/router.dart' as router;

import 'package:mazajflutter/services/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

GraphQLClient client;
String token;
OrdersCarriedBloc ordersBeingCarried = OrdersCarriedBloc();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final HttpLink httpLink = HttpLink(
  uri: 'https://a9b629853f4a.ngrok.io/api/graphql',
);
WaitingListBloc waitingListBloc = WaitingListBloc();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: null);

  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: null);

  // await flutterLocalNotificationsPlugin.show(
  //     10, 'plain title', 'plain body', platformChannelSpecifics,
  //     payload: 'item x');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token");

  final AuthLink authLink = AuthLink(
    getToken: () async => token,
  );
  final Link link = authLink.concat(httpLink);
  client = GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  );

  ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier(client);

  // prefs.setString("token", null);

  runApp(
    GraphQLProvider(
      client: clientNotifier,
      child: CacheProvider(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => waitingListBloc),
            ChangeNotifierProvider(create: (_) => ordersBeingCarried),
          ],
          child: AppRetainWidget(child: Mazaj()),
        ),
      ),
    ),
  );
}

class Mazaj extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mazaj Asly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute:
          token != null ? router.HomeViewRoute : router.LoginViewRoute,
    );
  }
}
