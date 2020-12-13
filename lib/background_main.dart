import 'package:flutter/cupertino.dart';

import './services/location.dart';
import 'main.dart';

void backgroundMain() {
  WidgetsFlutterBinding.ensureInitialized();
  locationService.getLocation();
  waitingListBloc.getWaitingList();
}
