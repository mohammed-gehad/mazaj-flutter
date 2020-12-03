import 'package:flutter/material.dart';
import 'package:mazajflutter/blocs/waitingList.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:mazajflutter/services/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String token;
final HttpLink httpLink = HttpLink(
  uri: 'https://885f3210e0d1.ngrok.io/api/graphql',
);
final AuthLink authLink = AuthLink(
  getToken: () => token,
);
final Link link = authLink.concat(httpLink);
final client = GraphQLClient(
  cache: InMemoryCache(),
  link: link,
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier(client);
  LocationService locationService = LocationService();
  locationService.getLocation();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  WaitingListBloc waitingListBloc = WaitingListBloc();
  // prefs.setString("token", null);
  token = prefs.getString("token");

  if (token != null) waitingListBloc.getWaitingList();

  runApp(
    GraphQLProvider(
      client: clientNotifier,
      child: CacheProvider(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => waitingListBloc),
          ],
          child: Mazaj(),
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
