import 'package:flutter/cupertino.dart';
import 'main.dart';

void backgroundMain() {
  WidgetsFlutterBinding.ensureInitialized();
  waitingListBloc.getWaitingList();
}
