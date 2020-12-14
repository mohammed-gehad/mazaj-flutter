import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mazajflutter/app_retain_widget.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/blocs/ordersBeingCarried.dart';
import 'package:mazajflutter/blocs/auth.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

OrdersCarriedBloc ordersBeingCarried = OrdersCarriedBloc();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

GraphQLClient client;

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

  String token;
  final HttpLink httpLink = HttpLink(
    uri: 'https://mzajasly-3cv0ypayp.vercel.app/api/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => token,
  );

  final Link link = authLink.concat(httpLink);

  client = GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  );

  ValueNotifier<GraphQLClient> clientNotifier;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token");

  clientNotifier = ValueNotifier(client);

  // prefs.setString("token", null);

  runApp(
    GraphQLProvider(
      client: clientNotifier,
      child: CacheProvider(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => waitingListBloc),
            ChangeNotifierProvider(create: (_) => ordersBeingCarried),
            ChangeNotifierProvider(create: (_) => AuthBloc()),
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
      initialRoute: router.HomeViewRoute,
    );
  }
}
